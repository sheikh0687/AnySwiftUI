//
//  BookingCalendarVM.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 31/03/26.
//

internal import Combine
import SwiftUI

enum BookingPopup: Identifiable, Hashable {
    case confirmBooking
    case confirmWithdraw
    case bookingSuccess(isInstant: Bool)
    case shiftAutoChanged
    case uploadDocument
    
    var id: Self { self }
}

final class BookingCalendarVM: ObservableObject {
    
    @Published var currentWeekIndex: Int = 0
    @Published var selectedDate: Date = Date()
    @Published var currentWeekDays: [Date] = []
    @Published var monthTitle: String = ""
    
    @Published var clientiD: String = ""
    @Published var jobType: String = ""
    @Published var notes: String = ""
    @Published var nrcDocument: String = ""
    @Published var instantApproved: String = ""
    @Published var companyDetail: String = ""
    @Published var shiftDetail: String = ""
    @Published var outletiD: String = ""
    @Published var shiftiD: String = ""
    @Published var shiftRate: String = ""
    @Published var singleDate: String = ""
    @Published var shiftStatus: String = ""
    @Published var countryName: String = ""
    @Published var documentReq: String = ""
    
//    @Published var conToBook: Bool = false
//    @Published var conToWithdraw: Bool = false
//    @Published var upldNrc: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var customError: CustomError?
    @Published var obj: Res_JobProvider?
    @Published var shiftBooked: Bool = false
    @Published var shiftLeft: Bool = false
    
    private var weekStartDates: [Date] = []
    private var weekEndDates: [Date] = []
    
    @Published var weekShifts: [Res_DayShiftCount] = []
    @Published var dayWiseShift: [Res_DayWiseShift] = []
    
    @Published var activePopup: BookingPopup?
    
    private let calendar = SGDate.calendar
    
    private var apiFormatter: DateFormatter {
        SGDate.formatter("yyyy-MM-dd")
    }
    
    init(preselectedDate: Date? = nil, obj: Res_JobProvider? = nil) {
//        self.clientiD = clientiD
        self.obj = obj
        
        generateWeeks()
        
        if let date = preselectedDate {
            let cleanDate = SGDate.stripTime(date)   // ⭐ same as UIKit conversion
            selectedDate = cleanDate
            jumpToWeek(containing: cleanDate) // ⭐ NEW
        }
        
        loadWeek()
    }
    
    @MainActor
    func fetchShiftCount() async throws -> Api_DayShiftCount {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = obj?.id ?? ""
        paramDict["worker_id"] = AppState.shared.useriD
        
        let formatter = SGDate.formatter("yyyy-MM-dd")
        let start = weekStartDates[currentWeekIndex]
        let end = weekEndDates[currentWeekIndex]
        
        paramDict["start_date"] = formatter.string(from: start)
        paramDict["end_date"]   = formatter.string(from: end)

        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_shift_by_day_week_count.url(),
            params: paramDict,
            responseType: Api_DayShiftCount.self
        )
        
        await MainActor.run {
            self.weekShifts = response.result ?? []
        }
        
        return response
    }
    
    @MainActor
    func fetchDayWiseShift() async throws -> Api_DayWiseShift {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["client_id"] = obj?.id ?? ""
        paramDict["sel_date"] = SGDate.formatter("yyyy-MM-dd").string(from: selectedDate)
        paramDict["day_name"] = SGDate.dayName(from: selectedDate)
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_shift_by_day.url(),
            params: paramDict,
            responseType: Api_DayWiseShift.self
        )
        
        await MainActor.run {
            self.dayWiseShift = response.result ?? []
            self.nrcDocument = response.nrc_document_uploaded ?? ""
            
            if let firstShift = dayWiseShift.first {
                self.jobType = firstShift.job_type ?? ""
                self.notes = firstShift.note ?? ""
            } else {
                self.jobType = ""
                self.notes = ""
            }
        }
        
        return response
    }
    
    @MainActor
    func bookShiftForCart() async throws -> Api_BookingCart {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["client_id"] = outletiD
        paramDict["shift_id"] = shiftiD
        paramDict["day_name"] = SGDate.dayName(from: selectedDate)
        paramDict["date"] = SGDate.formatter("yyyy-MM-dd").string(from: selectedDate)
        paramDict["shift_rate"] = shiftRate
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.add_to_set_shift_cart.url(),
            params: paramDict,
            responseType: Api_BookingCart.self
        )
        
        return response
    }
    
    @MainActor
    func addBookingShift(cartiD: Int) async throws -> Api_AddFinalBooking {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["cart_id"] = cartiD
        paramDict["date"] = emptyString
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.add_set_shift_book.url(),
            params: paramDict,
            responseType: Api_AddFinalBooking.self
        )
        
        return response
    }
    
    @MainActor
    func withdrawBookingShift() async throws -> Api_WithdrawShift {
        
        var paramDict: [String : Any] = [:]
        paramDict["cart_id"] = shiftiD
        paramDict["status"] = "Cancel"
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.change_set_shift_status_worker_side.url(),
            params: paramDict,
            responseType: Api_WithdrawShift.self
        )
        
        return response
    }
    
    @MainActor
    func updateWorkerDocuments(nrcImg: UIImage?, docImg: UIImage?) async throws -> Api_LoginResponse {
        
        var paramDict: [String : String] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        
        print(paramDict)
        
        var paramImgDict: [String : UIImage] = [:]
        paramImgDict["nrc_document"] = nrcImg
        paramImgDict["job_document"] = docImg
        
        print(paramImgDict)
        
        let response = try await Service.shared.uploadSingleMedia (
            url: Router.worker_update_document.url(),
            params: paramDict,
            images: paramImgDict,
            responseType: Api_LoginResponse.self
        )
        
        await MainActor.run {
            if response.status == "1" {
                activePopup = nil
                customError = .customError(message: "Your account is pending approval and you will receive notifications once you are authorized to book jobs.")
                Task {
                    try? await fetchDayWiseShift()
                }
            }
        }
        
        return response
    }
    
    @MainActor
    func addShiftToCart() async {
        do {
            let response = try await bookShiftForCart()
            if response.status == "1" {
                await addFinalBooking(cartiD: response.cart_id ?? 0)
            } else {
                customError = .customError(message: response.message ?? "")
            }
        } catch {
            customError = .customError(message: error.localizedDescription)
        }
    }

    @MainActor
    func addFinalBooking(cartiD: Int) async {
        do {
            let response = try await addBookingShift(cartiD: cartiD)
            if response.status == "1" {
                activePopup = .bookingSuccess(isInstant: instantApproved == "Yes")
            } else if response.status == "2" {
                activePopup = .shiftAutoChanged
            }
        } catch {
            customError = .customError(message: error.localizedDescription)
        }
    }

    @MainActor
    func addShiftWithdrawReq() async {
        do {
            let response = try await withdrawBookingShift()
            if response.status == "1" {
                Task { try? await fetchShiftCount() }
                Task { try? await fetchDayWiseShift() }
                activePopup = nil
            }
        } catch {
            customError = .customError(message: error.localizedDescription)
        }
    }
    
    func bookingSuccessClosed(appState: AppState) {
        // 1️⃣ First dismiss popup
        activePopup = nil
        
        // 2️⃣ Navigate AFTER dismissal animation finishes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            appState.switchToTab = .myBooking
            appState.goToHome = true
        }
    }
    
    func shift(for date: Date) -> Res_DayShiftCount? {
        let string = SGDate.formatter("yyyy-MM-dd").string(from: date)
        return weekShifts.first { $0.date == string }
    }
}

extension BookingCalendarVM {
    func jumpToWeek(containing date: Date) {
        
        // ⭐ Convert incoming date to SGT midnight
        let targetDate = SGDate.calendar.startOfDay(for: date)
        
        for (index, start) in weekStartDates.enumerated() {
            
            // ⭐ Ensure start & end are also midnight SGT
            let startDay = SGDate.calendar.startOfDay(for: start)
            let endDay   = SGDate.calendar.startOfDay(for: weekEndDates[index])
            
            if targetDate >= startDay && targetDate <= endDay {
                currentWeekIndex = index
                return
            }
        }
    }
}

extension BookingCalendarVM {

    func generateWeeks() {
        
        var currentDate = SGDate.stripTime(Date())
        let lastDate = calendar.date(byAdding: .day, value: 100, to: currentDate)!
        
        while currentDate < lastDate {
            
            // ⭐ Monday of current week
            let weekday = calendar.component(.weekday, from: currentDate)
            let daysFromMonday = (weekday + 5) % 7
            let startOfWeek = calendar.date(byAdding: .day, value: -daysFromMonday, to: currentDate)!
            
            // ⭐ Sunday of week
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
            
            weekStartDates.append(startOfWeek)
            weekEndDates.append(endOfWeek)
            
            currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate)!
        }
    }
}

extension BookingCalendarVM {
    
    func loadWeek() {
        currentWeekDays.removeAll()
        
        var date = weekStartDates[currentWeekIndex]
        let end = weekEndDates[currentWeekIndex]
        
        while date <= end {
            currentWeekDays.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        updateMonthTitle()
        
        Task { try? await fetchShiftCount() }
        
        Task { try? await fetchDayWiseShift() }
    }
    
    func nextWeek() {
        currentWeekIndex += 1
        loadWeek()
    }
    
    func previousWeek() {
        guard currentWeekIndex > 0 else { return }
        currentWeekIndex -= 1
        loadWeek()
    }
}

extension BookingCalendarVM {
    
    func select(date: Date) {
        let today = SGDate.today()
        
        // prevent past date selection
        if calendar.startOfDay(for: date) < today { return }
        
        selectedDate = date
        Task { try? await fetchDayWiseShift() }
    }
    
    var selectedDateAPI: String {
        SGDate.formatter("yyyy-MM-dd").string(from: selectedDate)
    }
}

extension BookingCalendarVM {
    
    func updateMonthTitle() {
        monthTitle = SGDate.formatter("MMM yyyy")
            .string(from: currentWeekDays.first ?? Date())
    }
}

extension BookingCalendarVM {
    
    var currentWeekStartAPI: String {
        let date = weekStartDates[currentWeekIndex]
        return SGDate.formatter("yyyy-MM-dd").string(from: date)
    }
    
    var currentWeekEndAPI: String {
        let date = weekEndDates[currentWeekIndex]
        return SGDate.formatter("yyyy-MM-dd").string(from: date)
    }
}
