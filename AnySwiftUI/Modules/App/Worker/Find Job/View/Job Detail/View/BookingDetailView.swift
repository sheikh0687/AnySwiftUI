//
//  BookingDetailView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 31/03/26.
//

import SwiftUI

struct BookingDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: BookingCalendarVM
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Company Info
                    headerView
                    
                    WeeklyCalanderView(vm: viewModel)
                    
                    DayWiseShiftView(vm: viewModel)
                }
                .padding(.all, 24)
            }
            
            if let popup = viewModel.activePopup {
                BookingPopupPresenter (
                    popup: popup,
                    vm: viewModel,
                    state: appState
                ) {
                    withAnimation {
                        viewModel.activePopup = nil
                    }
                }
                .zIndex(5)
            }
//            if viewModel.conToBook {
//                ZStack {
//                    Color.black.opacity(0.4)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation {
//                                viewModel.conToBook = false
//                            }
//                        }
//                                        
//                    PopBeforeBooking (
//                        cloYes: { bool in
//                            if bool {
//                                Task {
//                                    await addShiftToCart()
//                                }
//                            } else {
//                                viewModel.conToBook = false
//                            }
//                        },
//                        companyName: viewModel.companyDetail,
//                        shiftDetail: viewModel.shiftDetail,
//                        instantBooking: viewModel.instantApproved == "Yes" ? "Instant Approval" : "",
//                        bookingNote: viewModel.notes,
//                        shiftStatus: "",
//                        comingFor: "Book"
//                    )
//                    .transition(.scale)
//                    .zIndex(1)
//                }
//            }
//            
//            if viewModel.conToWithdraw {
//                ZStack {
//                    Color.black.opacity(0.4)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation {
//                                viewModel.conToWithdraw = false
//                            }
//                        }
//                                        
//                    PopBeforeBooking (
//                        cloYes: { bool in
//                            if bool {
//                                Task {
//                                    await addShiftWithdrawReq()
//                                }
//                            } else {
//                                viewModel.conToWithdraw = false
//                            }
//                        },
//                        companyName: viewModel.companyDetail,
//                        shiftDetail: "",
//                        instantBooking: "",
//                        bookingNote: "",
//                        shiftStatus: viewModel.shiftStatus,
//                        comingFor: "Withdraw"
//                    )
//                    .transition(.scale)
//                    .zIndex(1)
//                }
//            }
//            
//            if viewModel.shiftBooked {
//                ZStack {
//                    Color.black.opacity(0.4)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation {
//                                viewModel.shiftBooked = false
//                            }
//                        }
//                                        
//                    PopSuccess (
//                        title: viewModel.instantApproved == "Yes"
//                        ? ""
//                        : "Your Booking Request Has Been Sent",
//                        description: viewModel.instantApproved == "Yes"
//                        ? "Your shift booking for \(viewModel.singleDate) has been auto approved. Kindly be on time for your shift."
//                        : "You will receive a notification once the unit manager has approved/declined your shift.",
//                        cloOk: {
//                            withAnimation {
//                                viewModel.shiftBooked = false
//                            }
//                            
//                            appState.switchToTab = .myBooking
//                            appState.goToHome = true
//                            dismiss()
//                        }
//                    )
//                    .transition(.scale)
//                    .zIndex(1)
//                }
//            }
//            
//            if viewModel.shiftLeft {
//                ZStack {
//                    Color.black.opacity(0.4)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation {
//                                viewModel.shiftLeft = false
//                            }
//                        }
//                                        
//                    PopSuccess (
//                        title: "Booking status update",
//                        description: "Bookings for \(viewModel.obj?.business_name ?? "") on \(viewModel.selectedDate) have been switched from Instant Approval to Pending Approval due to the client’s billing issue. Please wait a few hours for the approval notification. No action needed on your side for now.",
//                        cloOk: {
//                            withAnimation {
//                                viewModel.shiftLeft = false
//                            }
//                            
//                            appState.switchToTab = .myBooking
//                            appState.goToHome = true
//                            dismiss()
//                        }
//                    )
//                    .transition(.scale)
//                    .zIndex(1)
//                }
//            }
//            
//            if viewModel.upldNrc {
//                ZStack {
//                    Color.black.opacity(0.4)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation {
//                                viewModel.upldNrc = false
//                            }
//                        }
//                                        
//                    PopDocView (
//                        countryName: viewModel.countryName,
//                        documentRequired: viewModel.documentReq,
//                        cloSubmit: { nrcImg, docImg in
//                            Task {
//                                try? await viewModel.updateWorkerDocuments(nrcImg: nrcImg, docImg: docImg)
//                            }
//                        },
//                        cloBack: {
//                            viewModel.upldNrc = false
//                        }
//                    )
//                    .transition(.scale)
//                    .zIndex(1)
//                }
//            }
        }
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationTitle("Booking Request")
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            // Header Business Name & Logo
            HStack(spacing: 16) {
                if let urlString = viewModel.obj?.business_logo {
                    CustomWebImage (
                        imageUrl: urlString,
                        placeholder: Image(systemName: "photo.fill"),
                        width: 60,
                        height: 60
                    )
                    .clipShape(.circle)
                    .frame(width: 60, height: 60)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    IBLabel (
                        text: viewModel.obj?.business_name ?? "",
                        font: .bold(.title),
                        color: .white
                    )
                    
                    IBLabel (
                        text: viewModel.obj?.business_address ?? "",
                        font: .medium(.subtitle),
                        color: .white
                    )
                    .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .frame(height: 0.5)
                .background(.white)
            
            //  Business Address
            VStack(alignment: .leading, spacing: 4) {
                IBLabel (
                    text: "Job Type: \(viewModel.jobType)",
                    font: .semibold(.subtitle),
                    color: .white
                )
                
                IBLabel (
                    text: "Notes: \(viewModel.notes)",
                    font: .semibold(.subtitle),
                    color: .white
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background (
            RoundedRectangle(cornerRadius: 12)
                .fill(.THEME)
        )
        .overlay (
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.THEME.opacity(0.2), lineWidth: 0.5)
        )
    }
    
//    func addShiftToCart() async {
//        viewModel.isLoading = true
//        
//        do {
//            let response = try await viewModel.bookShiftForCart()
//            if response.status == "1" {
//                Task {
//                    await addFinalBooking(cartiD: response.cart_id ?? 0)
//                }
//            } else {
//                viewModel.customError = .customError(message: response.message ?? "")
//                viewModel.conToBook = false
//            }
//        } catch {
//            viewModel.customError = .customError(message: error.localizedDescription)
//        }
//        
//        viewModel.isLoading = false
//    }
    
//    func addFinalBooking(cartiD: Int) async {
//        viewModel.isLoading = true
//        
//        do {
//            let response = try await viewModel.addBookingShift(cartiD: cartiD)
//            if response.status == "1" {
//                viewModel.shiftBooked = true
//            } else if response.status == "2" {
//                viewModel.shiftLeft = true
//            }
//            viewModel.conToBook = false
//        } catch {
//            viewModel.customError = .customError(message: error.localizedDescription)
//        }
//        
//        viewModel.isLoading = false
//    }
    
//    func addShiftWithdrawReq() async {
//        viewModel.isLoading = true
//        
//        do {
//            let response = try await viewModel.withdrawBookingShift()
//            if response.status == "1" {
//                Task { try? await viewModel.fetchShiftCount() }
//                Task { try? await viewModel.fetchDayWiseShift() }
//                viewModel.conToWithdraw = false
//            }
//        } catch {
//            viewModel.customError = .customError(message: error.localizedDescription)
//        }
//        
//        viewModel.isLoading = false
//    }
}

struct BookingPopupPresenter: View {
    let popup: BookingPopup
    let vm: BookingCalendarVM
    let state: AppState
    let dismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }
            
            content
                .transition(.scale)
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch popup {
            
        // BOOK CONFIRM
        case .confirmBooking:
            PopBeforeBooking (
                cloYes: { yes in
                    if yes {
                        Task { await vm.addShiftToCart() }
                    } else { dismiss() }
                },
                companyName: vm.companyDetail,
                shiftDetail: vm.shiftDetail,
                instantBooking: vm.instantApproved == "Yes" ? "Instant Approval" : "",
                bookingNote: vm.notes,
                shiftStatus: "",
                comingFor: "Book"
            )
            
        // WITHDRAW CONFIRM
        case .confirmWithdraw:
            PopBeforeBooking (
                cloYes: { yes in
                    if yes {
                        Task { await vm.addShiftWithdrawReq() }
                    } else { dismiss() }
                },
                companyName: vm.companyDetail,
                shiftDetail: "",
                instantBooking: "",
                bookingNote: "",
                shiftStatus: vm.shiftStatus,
                comingFor: "Withdraw"
            )
            
        // BOOK SUCCESS
        case .bookingSuccess(let instant):
            PopSuccess (
                title: instant ? "" : "Your Booking Request Has Been Sent",
                description: instant
                ? "Your shift booking for \(vm.singleDate) has been auto approved. Kindly be on time for your shift."
                : "You will receive a notification once approved/declined.",
                cloOk: {
                    vm.bookingSuccessClosed(appState: state)
                }
            )
            
        // BILLING ISSUE
        case .shiftAutoChanged:
            PopSuccess (
                title: "Booking status update",
                description: "Bookings for \(vm.obj?.business_name ?? "") on \(vm.selectedDate) have been switched from Instant Approval to Pending Approval due to the client’s billing issue. Please wait a few hours for the approval notification. No action needed on your side for now.",
                cloOk: {
                    vm.bookingSuccessClosed(appState: state)
                }
            )
            
        // DOCUMENT UPLOAD
        case .uploadDocument:
            PopDocView (
                countryName: vm.countryName,
                documentRequired: vm.documentReq,
                cloSubmit: { nrc, doc in
                    Task { try? await vm.updateWorkerDocuments(nrcImg: nrc, docImg: doc) }
                },
                cloBack: dismiss
            )
        }
    }
}

struct WeeklyCalanderView: View {
    
    @StateObject var vm: BookingCalendarVM
    
    var body: some View {
        VStack(spacing: 16) {
            header
            weekRow
        }
        .padding()
        .background (
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
        )
        .overlay (
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        )
    }
    
    var header: some View {
        HStack {
            Button(action: vm.previousWeek) {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            Text(vm.monthTitle).font(.headline)
            Spacer()
            
            Button(action: vm.nextWeek) {
                Image(systemName: "chevron.right")
            }
        }
    }
    
    var weekRow: some View {
        HStack(spacing: 8) {
            ForEach(vm.currentWeekDays, id: \.self) { date in
                DayCell (
                    date: date,
                    isSelected: SGDate.calendar.isDate(date, inSameDayAs: vm.selectedDate),
                    dayCount: vm.shift(for: date)
                )
                .onTapGesture {
                    vm.select(date: date)
                }
            }
            .id(vm.weekShifts.count)
        }
    }
}

struct DayWiseShiftView: View {
    
    @StateObject var vm: BookingCalendarVM
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            IBLabel (
                text: "Number of shifts Available",
                font: .semibold(.subtitle),
                color: .black
            )
            
            if vm.isLoading {
                ProgressView("Loading Shifts...")
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if vm.dayWiseShift.isEmpty {
                EmptyView(title: "", subtitle: "No Shift Available", img: "")
            } else {
                LazyVStack(spacing: 20) {
                    ForEach(vm.dayWiseShift, id: \.id) { bookingShift in
                        DayWiseShiftCard(obj: bookingShift, vm: vm)
                    }
                }
            }
        }
    }
}

struct DayWiseShiftCard: View {
    
    let obj: Res_DayWiseShift
    let vm: BookingCalendarVM
    
    private var shiftStatus: ShiftCardStatus {
        let shiftCartStatus = obj.set_shift_cart_status_value ?? ""
        let bookingStatus = obj.booking_status ?? ""
        let booking = obj.booking ?? ""
        
        if shiftCartStatus == "Accept" {
            return .accepted
        } else if shiftCartStatus == "Complete" {
            return .complete
        } else if shiftCartStatus == "Pending" {
            return .pending
        } else if bookingStatus == "Close" {
            return .closed
        } else if booking == "Full" {
            return .full
        } else {
            return .available
        }
    }
    
    private var statusConfig: (text: String, color: Color, showBook: Bool, showWithdraw: Bool, showClosed: Bool) {
        
        switch shiftStatus {
            
        case .accepted:
            return ("Booking\nAccepted!", .GREEN, false, true, false)
            
        case .complete:
            return ("Booking\nComplete!", .GREEN, false, false, false)
            
        case .pending:
            return ("Pending\nConfirmation!", .BUTTON, false, true, false)
            
        case .closed:
            return ("Booking\nClosed!", .red, false, false, true)
            
        case .full:
            return ("Booking\nFull!", .red, false, false, true)
            
        case .available:
            return ("Available", .GREEN, true, false, false)
        }
    }
    
    private var borderColor: Color {
        switch shiftStatus {
        case .accepted:
            return .GREEN
            
        case .complete:
            return .GREEN
            
        case .pending:
            return .BUTTON
            
        case .closed:
            return .red
            
        case .full:
            return .red
            
        case .available:
            return Color.gray
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Header Business Name & Logo
            VStack(alignment: .leading, spacing: 8) {
                IBLabel (
                    text: "\(obj.start_time ?? "") to \(obj.end_time ?? "")",
                    font: .semibold(.title),
                    color: .black
                )
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        IBLabel (
                            text: "\(obj.currency_symbol ?? "")\(obj.shift_rate ?? "")/Hour",
                            font: .regular(.subtitle),
                            color: .black
                        )
                        
                        IBLabel (
                            text: "Job Type: \(obj.job_type ?? "")",
                            font: .medium(.subtitle),
                            color: .black
                        )
                        
                        IBLabel (
                            text: "Break: \(obj.break_type ?? "")",
                            font: .medium(.subtitle),
                            color: .black
                        )
                        
                        IBLabel (
                            text: "Break Time: \(obj.shift_break_time ?? "")",
                            font: .medium(.subtitle),
                            color: .black
                        )
                        
                        IBLabel (
                            text: "Meals: \(obj.meals ?? "")",
                            font: .medium(.subtitle),
                            color: .black
                        )
                        
                        IBLabel (
                            text: "Notes: \(obj.note ?? "")",
                            font: .medium(.subtitle),
                            color: .black
                        )
                    }
                    
                    Spacer()
                    Divider()
                        .frame(width: 0.5, height: 100)
                        .background(.gray)
                    Spacer()
                    
                    VStack(alignment: .center, spacing: 8) {
                        if obj.client_details?.shift_autoapproval == "Yes" {
                            IBLabel (
                                text: "Instant Approval",
                                font: .semibold(.subtitle),
                                color: obj.booking_status == "Close" ? .LIGHTGRAY : .BUTTON
                            )
                        }
                        
                        IBLabel (
                            text: statusConfig.text,
                            font: .semibold(.subtitle),
                            color: statusConfig.color
                        )
                        .multilineTextAlignment(.center)
                        
                        if statusConfig.showBook {
                            IBSimpletButton (
                                height: 36,
                                width: 120,
                                fgColor: .white,
                                buttonText: "Book",
                                bg: .BUTTON
                            ) {
                                vm.companyDetail = "\(obj.client_details?.business_name ?? "")\n\(obj.client_details?.business_address ?? "")\n\(obj.currency_symbol ?? "")\(obj.shift_rate ?? "")/Hour"
                                
                                vm.instantApproved = obj.shift_autoapproval ?? ""
                                
                                vm.shiftDetail = """
                                Job Type : \(obj.job_type ?? "")
                                Break : \(obj.break_type ?? "")
                                Meals : \(obj.meals ?? "")
                                """

                                vm.notes = obj.note ?? ""
                                vm.outletiD = obj.outlet_id ?? ""
                                vm.shiftiD = obj.id ?? ""
                                vm.shiftRate = obj.shift_rate ?? ""
                                vm.singleDate = obj.single_date ?? ""
                                bookingAction()
                            }
                        }
                        
                        if statusConfig.showWithdraw {
                            IBSimpletButton (
                                height: 36,
                                width: 120,
                                fgColor: .white,
                                buttonText: "Withdraw",
                                bg: .gray
                            ) {
                                vm.companyDetail = "\(obj.client_details?.business_name ?? ""),\n\(obj.client_details?.business_address ?? "")\n\(obj.day_name ?? "") \(obj.start_time ?? "") \(obj.end_time ?? "")"
                                
                                vm.shiftStatus = obj.set_shift_cart_status_value ?? ""
                                vm.shiftiD = obj.set_shift_cart_id ?? ""
                                vm.activePopup = .confirmWithdraw
                            }
                        }
                        
                        if statusConfig.showClosed {
                            IBSimpletButton (
                                height: 36,
                                width: 120,
                                fgColor: .white,
                                buttonText: "Closed",
                                bg: .gray
                            ) {
                                vm.customError = .customError(message: "Closed for booking")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background (
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .overlay (
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 0.5)
        )
    }
    
    func bookingAction() {
        if obj.document_requied == "Yes" {
            if AppState.shared.jobTypeiD == obj.job_type_id ?? "" {
                if vm.nrcDocument == "No" {
                    // Upload document screen
                    print("Call the Document Upload Popup")
                    vm.countryName = obj.client_details?.country_name ?? ""
                    vm.documentReq = obj.document_requied ?? ""
                    vm.activePopup = .uploadDocument
                } else {
                    print("Show Booking Popup")
                    vm.activePopup = .confirmBooking
                }
            } else {
                vm.customError = .customError(message: "Please complete your profile to book.\n\n * Go to Profile, select the job type you’re applying for.\n * Some roles (Kitchen Assistant, Chef, Barista) require a one-time upload of NRIC and a valid Food Hygiene Certificate.\n\nOnce approved, you can book shifts for that job type.")
            }
        } else {
            if vm.nrcDocument == "No" {
                // Upload document screen
                print("Call the Document Upload Popup")
                vm.countryName = obj.client_details?.country_name ?? ""
                vm.documentReq = obj.document_requied ?? ""
                vm.activePopup = .uploadDocument
            } else {
                print("Show Booking Popup")
                vm.activePopup = .confirmBooking
            }
        }
    }
}

//#Preview {
//    DayWiseShiftView(vm: .init(clientiD: "1"))
//}
