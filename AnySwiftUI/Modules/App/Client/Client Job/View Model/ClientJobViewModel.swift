//
//  ClientJobViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 20/04/26.
//

internal import Combine

@MainActor
class ClientJobViewModel: ObservableObject {
    
    // Tab
    @Published var selectedTab: JobTab = .daily
    
    // Outlet
    @Published var outlets: [Res_ClientOutlet] = []
    @Published var selectedOutlet: Res_ClientOutlet?
    @Published var showOutletDropDown = false
    
    // Daily
    @Published var todayShiftName: String = ""
    @Published var todayShiftDescription: String = ""
    @Published var manpowerWorkers: [Worker_details] = []
    @Published var weeklyPendingCount: Int = 0
    @Published var dailyPendingCount: Int = 0
    
    // Weekly
    @Published var currentWeekIndex: Int = 0
    @Published var weekStartDates: [Date] = []
    @Published var weekEndDates: [Date] = []
    @Published var weekStartToEnd: [String] = []
    @Published var weekDays: [Date] = []
    @Published var currentMonthYear: String = ""
    @Published var jobTypes: [Res_WeeklyShift] = []
    
    // Upcoming
    @Published var upcomingShifts: [Res_UpcomingShifts] = []
    
    // Loading
    @Published var isLoading = false
    
    @Published var navigateToRequest = false
    @Published var navigateToRequestByDate: String? = nil
    
    var selectedTabIndex: Int {
        get { selectedTab == .daily ? 0 : 1 }
        set { switchTab(newValue == 0 ? .daily : .weekly) }
    }
    
    let weekDayNames = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    init() {
        buildWeekRanges()
        loadCurrentWeekDays()
    }
    
    enum JobTab {
        case daily, weekly
    }
    
    // MARK: - Week Ranges
    func buildWeekRanges() {
        let calendar = Calendar.current
        guard let last100 = calendar.date(byAdding: .day, value: 100, to: Date()) else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "ccc"
        
        let apiFormatter = DateFormatter()
        apiFormatter.dateFormat = "yyyy-MM-dd"
        
        var currentDate = Date()
        let components = calendar.dateComponents([.hour], from: currentDate)
        if let hours = components.hour, hours >= 0 && hours < 6 {
            currentDate = calendar.date(byAdding: .hour, value: 8, to: currentDate) ?? currentDate
        }
        
        let dayOfWeek = dateFormatter.string(from: currentDate)
        
        while currentDate < last100 {
            let startDay: Date
            let endDay: Date
            
            if dayOfWeek == "Mon" {
                startDay = currentDate
            } else {
                startDay = currentDate.previous(.monday)
            }
            
            if dayOfWeek == "Sun" {
                endDay = currentDate
            } else {
                endDay = currentDate.next(.sunday)
            }
            
            weekStartDates.append(startDay)
            weekEndDates.append(endDay)
            weekStartToEnd.append("\(apiFormatter.string(from: startDay)),\(apiFormatter.string(from: endDay))")
            currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
        }
    }
    
    func loadCurrentWeekDays() {
        guard currentWeekIndex < weekStartDates.count else { return }
        weekDays = []
        var d = weekStartDates[currentWeekIndex]
        let end = weekEndDates[currentWeekIndex]
        while d <= end {
            weekDays.append(d)
            d = Calendar.current.date(byAdding: .day, value: 1, to: d) ?? d
        }
        let fmt = DateFormatter()
        fmt.dateFormat = "MMM yyyy"
        currentMonthYear = fmt.string(from: weekDays.first ?? Date())
    }
    
    func goToPreviousWeek() {
        guard currentWeekIndex > 0 else { return }
        currentWeekIndex -= 1
        loadCurrentWeekDays()
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                let response = try await fetchWeeklyReport()
                applyWeeklyReport(response)
            } catch {
                print("goToPreviousWeek error: \(error)")
            }
        }
    }
    
    func goToNextWeek() {
        currentWeekIndex += 1
        loadCurrentWeekDays()
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                let response = try await fetchWeeklyReport()
                applyWeeklyReport(response)
            } catch {
                print("goToNextWeek error: \(error)")
            }
        }
    }
    
    // MARK: - API Calls
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
    
    func fetchManpowerJobRequests() async throws -> Api_ManpowerShift {
        var paramDict: [String: Any] = [:]
        paramDict["user_id"] = AppState.shared.clientiD
        paramDict["today_date"] = SGDate.currentDate()
        paramDict["today_day_name"] = SGDate.dayName(from: Date())
        
        print("fetchManpowerJobRequests params: \(paramDict)")
        
        let response = try await Service.shared.request (
            url: Router.get_client_shift_by_date.url(),
            params: paramDict,
            responseType: Api_ManpowerShift.self
        )
        
        return response
    }
    
    func fetchWeeklyReport() async throws -> Api_WeeklyShift {
        
        guard currentWeekIndex < weekStartToEnd.count else {
            throw NSError(domain: "ClientJobViewModel", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid week index"])
        }
        
        let parts = weekStartToEnd[currentWeekIndex].components(separatedBy: ",")
        
        guard parts.count == 2 else {
            throw NSError(domain: "ClientJobViewModel", code: -2,
                          userInfo: [NSLocalizedDescriptionKey: "Invalid date range format"])
        }
        
        var paramDict: [String: Any] = [:]
        paramDict["user_id"] = AppState.shared.clientiD
        paramDict["start_date"] = parts[0]
        paramDict["end_date"] = parts[1]
        
        print("fetchWeeklyReport params: \(paramDict)")
        
        let response = try await Service.shared.request (
            url: Router.get_set_shift_book_client_side.url(),
            params: paramDict,
            responseType: Api_WeeklyShift.self
        )
        
        return response
    }
    
    func fetchUpcomingShifts() async throws -> Api_UpcomingShifts {
        var paramDict: [String: Any] = [:]
        paramDict["user_id"] = AppState.shared.clientiD
        
        print("fetchUpcomingShifts params: \(paramDict)")
        
        let response = try await Service.shared.request (
            url: Router.get_shift_by_10day_count.url(),
            params: paramDict,
            responseType: Api_UpcomingShifts.self
        )
        
        return response
    }
    
    // MARK: - Apply Responses to State
    func applyManpowerShift(_ response: Api_ManpowerShift) {
        if response.status == "1", let result = response.result {
            todayShiftName = result.shift_name ?? ""
            todayShiftDescription = result.shift_description ?? ""
            weeklyPendingCount = response.pending_shift_count ?? 0
            dailyPendingCount = response.today_pending_shift_count ?? 0
            manpowerWorkers = result.worker_details ?? []
        } else {
            todayShiftName = ""
            todayShiftDescription = ""
            manpowerWorkers = []
            weeklyPendingCount = 0
            dailyPendingCount = 0
        }
    }
    
    func applyWeeklyReport(_ response: Api_WeeklyShift) {
        if response.status == "1", let result = response.result {
            jobTypes = result
        } else {
            jobTypes = []
        }
    }
    
    func applyUpcomingShifts(_ response: Api_UpcomingShifts) {
        if response.status == "1", let result = response.result {
            upcomingShifts = result
        } else {
            upcomingShifts = []
        }
    }
    
    func applyOutlets(_ response: Api_ClientOutlet) {
        guard response.status == "1", let result = response.result else { return }
        
        var items = result
        
        // Insert default business as first if not already present
        if let defaultOutlet = Res_ClientOutlet.makeDefault (
            id: AppState.shared.useriD,
            businessName: AppState.shared.businessName,
            businessLogo: AppState.shared.businessLogo
        ), items.first?.id != defaultOutlet.id {
            items.insert(defaultOutlet, at: 0)
        }
        
        outlets = items
        
        let savedClientId = AppState.shared.clientiD
        if savedClientId.isEmpty {
            selectedOutlet = items.first
            if let first = items.first {
                AppState.shared.clientiD = first.id ?? ""
                AppState.shared.outletName = first.business_name ?? ""
                AppState.shared.outletImage = first.business_logo ?? ""
            }
        } else {
            selectedOutlet = items.first(where: { $0.id == savedClientId }) ?? items.first
            if let selected = selectedOutlet {
                AppState.shared.clientiD = selected.id ?? ""
                AppState.shared.outletName = selected.business_name ?? ""
                AppState.shared.outletImage = selected.business_logo ?? ""
            }
        }
    }
    
    // MARK: - UI Actions
    func selectOutlet(_ outlet: Res_ClientOutlet) {
        selectedOutlet = outlet
        showOutletDropDown = false
        AppState.shared.clientiD = outlet.id ?? ""
        AppState.shared.outletName = outlet.business_name ?? ""
        AppState.shared.outletImage = outlet.business_logo ?? ""
        
        // Clear old data to prevent showing stale info while loading
        todayShiftName = ""
        todayShiftDescription = ""
        manpowerWorkers = []
        upcomingShifts = []
        jobTypes = []
        weeklyPendingCount = 0
        dailyPendingCount = 0
        
        Task {
            await refreshData()
        }
    }
    
    func switchTab(_ tab: JobTab) {
        selectedTab = tab
        Task {
            isLoading = true
            defer { isLoading = false }
            do {
                if tab == .daily {
                    let response = try await fetchManpowerJobRequests()
                    applyManpowerShift(response)
                } else {
                    let response = try await fetchWeeklyReport()
                    applyWeeklyReport(response)
                }
            } catch {
                print("switchTab error: \(error)")
            }
        }
    }
    
    func refreshData() async {
        isLoading = true
        defer { isLoading = false }
        do {
            async let shiftResponse = fetchManpowerJobRequests()
            async let upcomingResponse = fetchUpcomingShifts()
            
            if selectedTab == .weekly {
                async let weeklyResponse = fetchWeeklyReport()
                let (shift, upcoming, weekly) = try await (shiftResponse, upcomingResponse, weeklyResponse)
                applyManpowerShift(shift)
                applyUpcomingShifts(upcoming)
                applyWeeklyReport(weekly)
            } else {
                let (shift, upcoming) = try await (shiftResponse, upcomingResponse)
                applyManpowerShift(shift)
                applyUpcomingShifts(upcoming)
            }
        } catch {
            print("refreshData error: \(error)")
        }
    }
}

// MARK: - Date Extensions
extension Date {
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next, weekday, considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous, weekday, considerToday: considerToday)
    }
    
    private func get(_ direction: SearchDirection, _ weekDay: Weekday, considerToday: Bool = false) -> Date {
        let cal = Calendar(identifier: .gregorian)
        var nextDate = self
        let weekdayOrdinal = weekDay.rawValue
        if direction == .next {
            while cal.component(.weekday, from: nextDate) != weekdayOrdinal || (!considerToday && nextDate == self) {
                nextDate = cal.date(byAdding: .day, value: 1, to: nextDate)!
            }
        } else {
            while cal.component(.weekday, from: nextDate) != weekdayOrdinal || (!considerToday && nextDate == self) {
                nextDate = cal.date(byAdding: .day, value: -1, to: nextDate)!
            }
        }
        return nextDate
    }
    
    enum Weekday: Int {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
    
    enum SearchDirection {
        case next, previous
    }
}
