//
//  JobDetailViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/05/26.
//

internal import Combine

class JobDetailViewModel: ObservableObject {
    
    let mode: PickerMode
    @Published var items: [SelectionItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
 
    // Break Type specific
    @Published var showBreakTimePicker: Bool = false
    @Published var selectedBreakType: String = ""
    
    let breakTimes = ["1 hour", "1 hour, 30 mins", "2 hours", "2 hours, 30 mins", "3 hours"]
 
    // Days specific
    @Published var selectedDayIDs: Set<String> = []
    @Published var shiftStatusArray: [String] = [] // ✅ ADD THIS — mirrors arr_ShiftStu
    
    @Published var showBreakTimeSheet = false
    @Published var alertMessage: String? = nil
    @Published var showAlert = false
 
    init(mode: PickerMode) {
        self.mode = mode
        loadStaticData()
    }
 
    var navigationTitle: String {
        switch mode {
        case .outlet:          return "Outlet Selection"
        case .jobType:         return "Job Selection"
        case .schedule:        return "Schedule Selection"
        case .numberOfWorkers: return "Manpower"
        case .breakType:       return "Breaks"
        case .mealProvision:   return "Meals"
        case .days:            return "Choose Working Days"
        }
    }
 
    var showDoneButton: Bool {
        if case .days = mode { return true }
        return false
    }
  
    // MARK: Static data loaders
    private func loadStaticData() {
        switch mode {
        case .schedule:
            items = [
                SelectionItem(id: "Specific Date", name: "Specific Date"),
                SelectionItem(id: "Weekly", name: "Weekly"),
                SelectionItem(id: "Urgent", name: "Same-Day Booking (Urgent)")
            ]
        case .numberOfWorkers:
            items = (1...10).map { SelectionItem(id: "\($0)", name: "\($0)") }
        case .breakType:
            items = [
                SelectionItem(id: "Paid", name: "Paid"),
                SelectionItem(id: "Unpaid", name: "Unpaid"),
                SelectionItem(id: "Not Applicable", name: "Not Applicable")
            ]
        case .mealProvision:
            items = [
                SelectionItem(id: "Provided", name: "Provided"),
                SelectionItem(id: "Not Provided", name: "Not Provided")
            ]
        case .days(let existing):
            // Static week days — real data loaded via loadWeekDays()
            // ✅ Pre-populate with static days immediately (no blank screen while loading)
            let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
            items = weekDays.map { SelectionItem(id: $0, name: $0) }
            selectedDayIDs = Set(existing) // ✅ preserve existing selection
            
            // ✅ Then fetch real data from API
            Task { await loadWeekDays() }
        default:
            break // outlet & jobType loaded via API
        }
    }
    
    // MARK: API Loaders
    func fetchOutlets() async throws -> Api_ClientOutlet {
        var paramDict: [String: Any] = [:]
        paramDict["client_id"] = AppState.shared.useriD
        
        print("fetchOutlets params: \(paramDict)")
        
        let response = try await Service.shared.request (
            url: Router.get_Outlet.url(),
            params: paramDict,
            responseType: Api_ClientOutlet.self
        )
        
        return response
    }
    
    /// Fetches all available job categories/types.
    func fetchJobTypes() async throws -> Api_JobType {
        let paramDict: [String: Any] = [:]
 
        print("fetchJobTypes params: \(paramDict)")
 
        let response = try await Service.shared.request(
            url: Router.get_job_type.url(),
            params: paramDict,
            responseType: Api_JobType.self
        )
 
        return response
    }
 
    /// Fetches the client's weekly working days (with shift status for update flow).
    func fetchWeekDays() async throws -> Api_WeeklyDayRate {
        var paramDict: [String: Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
 
        print("fetchWeekDays params: \(paramDict)")
 
        let response = try await Service.shared.request (
            url: Router.get_client_weekly_rate.url(),
            params: paramDict,
            responseType: Api_WeeklyDayRate.self
        )
 
        return response
    }
    
    func applyWeekDays(_ response: Api_WeeklyDayRate) {
        guard response.status == "1", let result = response.result else { return }
        DispatchQueue.main.async {
            // ✅ mirrors: self.arr_DaysName = self.arrayOfWeekDays.map({$0["day_name"].stringValue})
            self.items = result.map { SelectionItem(id: $0.day_name ?? "", name: $0.day_name ?? "") }
            
            // ✅ mirrors: arr_ShiftStu — rebuild based on already selected days
            self.shiftStatusArray = result.map { day in
                self.selectedDayIDs.contains(day.day_name ?? "") ? "Yes" : "No"
            }
        }
    }

    // ✅ ADD THIS — mirrors didSelectRowAt toggle logic
    func toggleDay(_ item: SelectionItem) {
        if selectedDayIDs.contains(item.id) {
            selectedDayIDs.remove(item.id)
        } else {
            selectedDayIDs.insert(item.id)
        }
        // ✅ mirrors: arr_ShiftStu[indexPath.row] = "Yes"/"No"
        shiftStatusArray = items.map { selectedDayIDs.contains($0.id) ? "Yes" : "No" }
    }

    // Update selectedDaysResult to use shiftStatusArray
    var selectedDaysResult: (days: String, shiftStatus: String) {
        let selected = items.filter { selectedDayIDs.contains($0.id) }.map { $0.name }
        return (selected.joined(separator: ","), shiftStatusArray.joined(separator: ","))
    }
    
    func applyOutlets(_ response: Api_ClientOutlet) {
        guard response.status == "1", let result = response.result else { return }
        
        var outletItems = result
        
        if let defaultOutlet = Res_ClientOutlet.makeDefault(
            id: AppState.shared.useriD,
            businessName: AppState.shared.businessName,
            businessLogo: AppState.shared.businessLogo
        ), outletItems.first?.id != defaultOutlet.id {
            outletItems.insert(defaultOutlet, at: 0)
        }

        // ✅ This line was commented out — now actually sets items
        self.items = outletItems.map { SelectionItem(id: $0.id ?? "", name: $0.business_name ?? "") }
    }
    
    func applyJobTypes(_ response: Api_JobType) {
        guard response.status == "1", let result = response.result else { return }
        DispatchQueue.main.async {
            self.items = result.map { SelectionItem(id: $0.id ?? "", name: $0.name ?? "") }
        }
    }
    
    @MainActor
    func loadWeekDays() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await fetchWeekDays()
            applyWeekDays(response)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
