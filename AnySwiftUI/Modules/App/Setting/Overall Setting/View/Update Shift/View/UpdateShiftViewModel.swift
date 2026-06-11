//
//  UpdateShiftViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 26/05/26.
//

import Observation
import Foundation

@Observable
@MainActor
class UpdateShiftViewModel {
    
    // MARK: Form Fields
    var selectedOutletName: String = ""
    var selectedOutletID: String = ""
    
    var jobTypeName: String = ""
    var jobTypeID: String = ""
    
    var workerCount: Int = 1 {
        didSet { syncWorker() }
    }
    
    var scheduleType: ScheduleType? = nil
    
    // Weekly days
    var selectedDaysName: String = ""
    var shiftStatus: String = ""
    
    // Specific dates
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
    
    var shiftiD: String?
    var isLoading: Bool = false
    var customError: CustomError?
    
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
    var navigateBack = false
    
    init(shiftiD: String, selectedOutletName: String) {
        self.shiftiD = shiftiD
        self.selectedOutletName = selectedOutletName
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
    
    // MARK: API - Fetch Shift Details
    func fetchShiftDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            var paramDict: [String : Any] = [:]
            paramDict["set_shift_id"] = shiftiD
            
            let response = try await Service.shared.request (
                url: Router.get_set_shift_details.url(),
                params: paramDict,
                responseType: Api_ShiftDetails.self
            )
            
            if response.status == "1", let res = response.result {
                populateData(from: res)
            } else {
                customError = .customError(message: response.message ?? "Failed to fetch details")
            }
        } catch {
            customError = .customError(message: error.localizedDescription)
        }
    }
    
    private func populateData(from res: Res_ShiftDetails) {
//        selectedOutletName = res ?? ""
        selectedOutletID = res.outlet_id ?? ""
        jobTypeName = res.job_type ?? ""
        jobTypeID = res.job_type_id ?? ""
        workerCount = Int(res.worker_count ?? "1") ?? 1
        
        // Schedule Type
        if res.shift_type == "Broadcast" {
            scheduleType = .urgent
        } else if res.shift_type == "SingleDate" {
            scheduleType = .specificDate
            selectedDates = (res.single_date ?? "").components(separatedBy: ",").filter { !$0.isEmpty }
            // Assuming we need day names too, if the API doesn't provide them separately, we might need to derive them or they might be in day_name
            selectedDayNames = (res.day_name ?? "").components(separatedBy: ",").filter { !$0.isEmpty }
        } else {
            scheduleType = .weekly
            selectedDaysName = res.day_name ?? ""
        }
        
        shiftStatus = res.shiftStatus ?? ""
        applyTimeToAllWorkers = (res.apply_time_same_for_allworkers ?? "No") == "Yes"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        globalStartTime = formatter.date(from: res.start_time ?? "09:00") ?? Date()
        globalEndTime = formatter.date(from: res.end_time ?? "18:00") ?? Date()
        
        // Multi work time
        if let multiStart = res.start_time, let multiEnd = res.end_time {
            let starts = multiStart.components(separatedBy: ",")
            let ends = multiEnd.components(separatedBy: ",")
            
            workerShifts = []
            for i in 0..<workerCount {
                let startStr = i < starts.count ? starts[i] : "09:00"
                let endStr = i < ends.count ? ends[i] : "18:00"
                
                var shift = WorkerShift()
                shift.startTime = formatter.date(from: startStr) ?? Date()
                shift.endTime = formatter.date(from: endStr) ?? Date()
                workerShifts.append(shift)
            }
        }
        
//        rateName = res.shift_rate ?? ""
        breakType = res.break_type ?? ""
        breakTime = res.shift_break_time ?? ""
        meal = res.meals ?? ""
        notes = res.note ?? ""
    }
    
    // MARK: API - Update Shift
    func updateShift() async {
        if let errorMsg = validate() {
            alertMessage = errorMsg
            showAlert = true
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let params = collectParams()
            let response = try await Service.shared.request (
                url: Router.update_my_shifts.url(),
                params: params,
                responseType: Api_CommonModel.self
            )
            
            if response.status == "1" {
                alertMessage = response.message ?? "Shift updated successfully"
                showAlert = true
                navigateBack = true
            } else {
                alertMessage = response.message ?? "Failed to update shift"
                showAlert = true
            }
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
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
    
    // MARK: Collect Params
    func collectParams() -> [String: Any] {
        var params: [String: Any] = [:]
        
        let startTimes = applyTimeToAllWorkers
        ? Array(repeating: formattedTime(globalStartTime), count: workerCount)
        : workerShifts.map { formattedTime($0.startTime) }
        
        let endTimes = applyTimeToAllWorkers
        ? Array(repeating: formattedTime(globalEndTime), count: workerCount)
        : workerShifts.map { formattedTime($0.endTime) }
        
        params["id"] = shiftiD
        params["user_id"] = AppState.shared.useriD
        params["job_type"] = jobTypeName
        params["job_type_id"] = jobTypeID
        params["worker_count"] = workerCount
        
        params["start_time"] = applyTimeToAllWorkers
        ? formattedTime(globalStartTime)
        : (startTimes.first ?? "")
        
        params["end_time"] = applyTimeToAllWorkers
        ? formattedTime(globalEndTime)
        : (endTimes.first ?? "")
        
        params["shiftStatus"] = shiftStatus
        params["break_type"] = breakType
        params["shift_type"] = shiftType
        params["meals"] = meal
        params["note"] = notes
        
        params["single_date"] = selectedDates.joined(separator: ",")
        
        params["apply_time_same_for_allworkers"] = applyTimeToAllWorkers ? "Yes" : "No"
        
        params["multi_work_start_time"] = startTimes.joined(separator: ",")
        params["multi_work_end_time"] = endTimes.joined(separator: ",")
        
        params["shift_break_time"] = breakTime
        params["shift_break_time_in_min"] = Utility.convertToMinutes(from: breakTime)
        params["outlet_id"] = selectedOutletID
        params["business_name"] = selectedOutletName
        
        var dayName: String
        switch scheduleType {
        case .weekly:
            dayName = selectedDaysName
        case .urgent:
            dayName = Utility.getCurrentDay()
        case .specificDate:
            dayName = selectedDayNames.joined(separator: ",")
        case .none:
            dayName = ""
        }
        params["day_name"] = dayName
        
        print("Update Params: \(params)")
        
        return params
    }
    
    private func formattedTime(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}
