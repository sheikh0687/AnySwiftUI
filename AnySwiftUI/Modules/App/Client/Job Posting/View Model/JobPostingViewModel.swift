//
//  JobPostingViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/05/26.
//

import Observation

@Observable
class JobPostingViewModel {
    
    // MARK: Form Fields
    var selectedOutletName: String = ""
    var selectedOutletID: String = ""
    var showOutletRow: Bool = false  // driven by API response
    
    var jobTypeName: String = ""
    var jobTypeID: String = ""
    
    var workerCount: Int = 1 {
        didSet { syncWorker() }
    }
    
    var scheduleType: ScheduleType? = nil
    
    // Weekly days
    var selectedDaysName: String = ""
    var shiftStatus: String = ""
    
    //    c dates
    var selectedDates: [String] = []
    var selectedDayNames: [String] = []
    
    var workerShifts: [WorkerShift] = [WorkerShift()]
    var applyTimeToAllWorkers: Bool = false
    
    var globalStartTime: Date = Date()
    var globalEndTime: Date = Date()
    
    var rateName: String = ""
    var breakType: String = ""
    
    var breakTime: String = ""
    var meal: String = ""
    
    var notes: String = ""
    
    init(selectedType: ScheduleType) {
        self.scheduleType = selectedType
    }
    
    init() {
        self.selectedOutletName = AppState.shared.outletName
        self.selectedOutletID = AppState.shared.clientiD
    }
    
    // MARK: Computed helpers
    var scheduleLabel: String {
        guard let s = scheduleType else { return "Choose Schedule" }
        return s.rawValue
    }
    
    var dayLabel: String {
        switch scheduleType {
        case .weekly:   return selectedDaysName.isEmpty ? "Select Days" : selectedDaysName
        case .specificDate: return selectedDates.isEmpty ? "Select Date" : "\(selectedDates.count) date(s)"
        case .urgent:   return "Today"
        case .none:     return "Select Days"
        }
    }
    
    var defaultRateLabel: String {
        switch scheduleType {
        case .weekly:    return "Default Weekly Rate"
        case .specificDate: return "Default Date Or Day Rate"
        case .urgent:    return "Default Urgent Rate"
        case .none:      return "Default Date or Day Rate"
        }
    }
    
    var shiftType: String {
        switch scheduleType {
        case .weekly:    return "Normal"
        case .specificDate: return "SingleDate"
        case .urgent:    return "Broadcast"
        case .none:      return ""
        }
    }
    
    var showNoteForWorker: Bool {
        return scheduleType == .urgent
    }
    
    // MARK: Sync worker array
    func syncWorker() {
        
        //        objectWillChange.send()   // 🔥 FORCE UI REFRESH
        
        if workerShifts.count < workerCount {
            let diff = workerCount - workerShifts.count
            workerShifts.append(contentsOf: Array(repeating: WorkerShift(), count: diff))
        }
        
        if workerShifts.count > workerCount {
            workerShifts = Array(workerShifts.prefix(workerCount))
        }
    }
    
    // MARK: Apply global time to all workers
    func applyGlobalTimeToAll() {
        workerShifts = workerShifts.map { shift in
            var s = shift
            s.startTime = globalStartTime
            s.endTime = globalEndTime
            return s
        }
    }
    
    // MARK: Remove a specific date
    func removeDate(at index: Int) {
        guard index < selectedDates.count else { return }
        selectedDates.remove(at: index)
        if index < selectedDayNames.count {
            selectedDayNames.remove(at: index)
        }
    }
    
    // MARK: Validation
    func validate() -> String? {
        if jobTypeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Please Select Job Type"
        }
        if scheduleType == nil {
            return "Please Select The Schedule"
        }
        if scheduleType == .weekly && selectedDaysName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Please Select Days"
        }
        if scheduleType == .specificDate && selectedDates.isEmpty {
            return "Please Select Date"
        }
        if breakType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Please Select Break Type"
        }
        if meal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Please Select Meal"
        }
        return nil
    }
    
    // MARK: Collect Params (mirrors collectParamJobPost)
    func collectParams() {
        
        let startTimes = applyTimeToAllWorkers
        ? Array(repeating: formattedTime(globalStartTime), count: workerCount)
        : workerShifts.map { formattedTime($0.startTime) }
        
        let endTimes = applyTimeToAllWorkers
        ? Array(repeating: formattedTime(globalEndTime), count: workerCount)
        : workerShifts.map { formattedTime($0.endTime) }
        
        paramJobPostDict["user_id"] = AppState.shared.useriD
        paramJobPostDict["job_type"] = jobTypeName
        paramJobPostDict["job_type_id"] = jobTypeID
        paramJobPostDict["worker_count"] = workerCount
        
        paramJobPostDict["start_time"] = applyTimeToAllWorkers
        ? formattedTime(globalStartTime)
        : (startTimes.first ?? "")
        
        paramJobPostDict["end_time"] = applyTimeToAllWorkers
        ? formattedTime(globalEndTime)
        : (endTimes.first ?? "")
        
        paramJobPostDict["shiftStatus"] = shiftStatus
        paramJobPostDict["break_type"] = breakType
        paramJobPostDict["shift_type"] = shiftType
        paramJobPostDict["meals"] = meal
        paramJobPostDict["note"] = notes
        
        paramJobPostDict["single_date"] = selectedDates.joined(separator: ",")
        
        paramJobPostDict["apply_time_same_for_allworkers"] = applyTimeToAllWorkers ? "Yes" : "No"
        
        paramJobPostDict["multi_work_start_time"] = startTimes.joined(separator: ",")
        paramJobPostDict["multi_work_end_time"] = endTimes.joined(separator: ",")
        
        paramJobPostDict["shift_break_time"] = breakTime
        paramJobPostDict["shift_break_time_in_min"] = Utility.convertToMinutes(from: breakTime)
        paramJobPostDict["outlet_id"] = selectedOutletID
        paramJobPostDict["business_name"] = selectedOutletName
        
        // MARK: - day_name logic (mirrors UIKit PublishJobVC exactly)
        var dayName: String
        
        switch scheduleType {
        case .weekly:
            // Comes directly from days picker — already comma separated
            // e.g. "Monday,Tuesday,Friday"
            dayName = selectedDaysName
            
        case .urgent:
            // Auto set to today — same as Utility.getCurrentDay()
            dayName = Utility.getCurrentDay()
            
        case .specificDate:
            // Derived from selected dates → day names joined
            // e.g. selectedDayNames = ["Monday", "Wednesday"]
            // result = "Monday,Wednesday"
            dayName = selectedDayNames.joined(separator: ",")
            
        case .none:
            dayName = ""
        }
        
        paramJobPostDict["day_name"] = dayName
        
        print(paramJobPostDict)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
    
    var showOutletPicker = false
    var showJobTypePicker = false
    var showWorkerCountPicker = false
    var showSchedulePicker = false
    var showDaysPicker = false
    var showDatePicker = false
    var showRatePicker = false
    var showBreakPicker = false
    var showMealPicker = false
    
    var alertMessage: String? = nil
    var showAlert = false
    
    var isLoading = false
    var navigateToAssign = false
}
