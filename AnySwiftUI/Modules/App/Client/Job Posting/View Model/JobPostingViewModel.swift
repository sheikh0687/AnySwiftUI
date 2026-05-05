//
//  JobPostingViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/05/26.
//

internal import Combine

class JobPostingViewModel: ObservableObject {
    
    // MARK: Form Fields
    @Published var selectedOutletName: String = ""
    @Published var selectedOutletID: String = ""
    @Published var showOutletRow: Bool = false  // driven by API response
 
    @Published var jobTypeName: String = ""
    @Published var jobTypeID: String = ""
 
    @Published var workerCount: Int = 1 {
        didSet { syncWorker() }
    }
 
    @Published var scheduleType: ScheduleType? = nil
 
    // Weekly days
    @Published var selectedDaysName: String = ""
    @Published var shiftStatus: String = ""
 
    // Specific dates
    @Published var selectedDates: [String] = []
    @Published var selectedDayNames: [String] = []
 
    // Shift
    @Published var workerShifts: [WorkerShift] = [WorkerShift()]
    @Published var applyTimeToAllWorkers: Bool = false
    
    @Published var globalStartTime: Date = Date()
    @Published var globalEndTime: Date = Date()
 
    @Published var rateName: String = ""
    @Published var breakType: String = ""
    
    @Published var breakTime: String = ""
    @Published var meal: String = ""
 
    @Published var notes: String = ""

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
        
        objectWillChange.send()   // 🔥 FORCE UI REFRESH
        
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
    func collectParams() -> [String: Any] {
        let startTimes = applyTimeToAllWorkers
            ? Array(repeating: formattedTime(globalStartTime), count: workerCount)
            : workerShifts.map { formattedTime($0.startTime) }
        let endTimes = applyTimeToAllWorkers
            ? Array(repeating: formattedTime(globalEndTime), count: workerCount)
            : workerShifts.map { formattedTime($0.endTime) }
 
        return [
            "job_type": jobTypeName,
            "job_type_id": jobTypeID,
            "worker_count": workerCount,
            "start_time": applyTimeToAllWorkers ? formattedTime(globalStartTime) : (startTimes.first ?? ""),
            "end_time": applyTimeToAllWorkers ? formattedTime(globalEndTime) : (endTimes.first ?? ""),
            "day_name": selectedDaysName,
            "shiftStatus": shiftStatus,
            "break_type": breakType,
            "shift_type": shiftType,
            "meals": meal,
            "note": notes,
            "single_date": selectedDates.joined(separator: ","),
            "apply_time_same_for_allworkers": applyTimeToAllWorkers ? "Yes" : "No",
            "multi_work_start_time": startTimes.joined(separator: ","),
            "multi_work_end_time": endTimes.joined(separator: ","),
            "shift_break_time": breakTime,
            "outlet_id": selectedOutletID,
            "business_name": selectedOutletName
        ]
    }
    
    private func formattedTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
    
    @Published var showOutletPicker = false
    @Published var showJobTypePicker = false
    @Published var showWorkerCountPicker = false
    @Published var showSchedulePicker = false
    @Published var showDaysPicker = false
    @Published var showDatePicker = false
    @Published var showRatePicker = false
    @Published var showBreakPicker = false
    @Published var showMealPicker = false
    
    @Published var alertMessage: String? = nil
    @Published var showAlert = false
}
