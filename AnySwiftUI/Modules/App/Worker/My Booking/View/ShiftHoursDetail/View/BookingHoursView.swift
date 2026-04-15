//
//  BookingHoursView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 13/04/26.
//

import SwiftUI

struct BookingHoursView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: BookingHourViewModel
    @ObservedObject  private var locationManager = LocationManager.shared
    
    init(cartID: String) {
        _viewModel = StateObject(wrappedValue: BookingHourViewModel(cartiD: cartID))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let detail = viewModel.shiftDetail {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        timeCard(detail: detail)
                        infoSection(detail: detail)
                        noticeBox
                        if let detail = viewModel.shiftDetail, shouldShowBreaks(detail: detail) {
                            breakSection(detail: detail)
                        }
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
                bottomBar(detail: detail)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .background(Color(.systemGroupedBackground))
        .task {
            await loadData()
        }
        // Navigate to BookingCompleteDetailView when working_status == "Clock-Out"
        .navigationDestination(isPresented: $viewModel.navigateToComplete) {
            if let result = viewModel.clockOutInResult {
                ShiftSummaryView (
                    cartDetail: viewModel.shiftDetail!,
                    clientDetail: result
                )
            }
        }
        .alert(item: $viewModel.clockInError) { err in
            Alert (
                title:   Text("Clock-in Unsuccessful"),
                message: Text(err.message),
                primaryButton: .default(Text("Retry, Clock-in")) {
                    Task { try? await viewModel.addClockOutIn(strType: "IN") }
                },
                secondaryButton: .cancel(Text("Message")) {
                    // navigate to chat
                }
            )
        }
        .alert(item: $viewModel.locationAlert) { alert in
            Alert (
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert("Check-out", isPresented: $viewModel.showClockOutConfirmation) {
            Button("Yes, proceed") {
                Task {
                    viewModel.isCheckingLocation = true
                    defer { viewModel.isCheckingLocation = false }
                    do {
                        _ = try await viewModel.addClockOutIn(strType: "OUT")
                    } catch {
                        viewModel.locationAlert = LocationAlert (
                            title:   "Error",
                            message: error.localizedDescription
                        )
                    }
                }
            }
            Button("Back", role: .cancel) { }
        } message: {
            Text("Proceed to check-out?")
        }
        .sheet(item: $viewModel.activeBreakPopup) { popup in
            BreakPopupSheet(popup: popup) { _ in
                viewModel.activeBreakPopup = nil
                Task { await loadData() }   // refresh break_time after success
            } onDismiss: {
                viewModel.activeBreakPopup = nil
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.hidden)
        }
        // React to working_status changes from the API response
        .onChange(of: viewModel.workingStatus) { _, newStatus in
            handleWorkingStatusChange(newStatus)
        }
    }
    
    // MARK: - Working Status → Navigation
    private func handleWorkingStatusChange(_ status: String) {
        switch status {
        case "Clock-Out":
                viewModel.navigateToComplete = true
        case "Clock-In":
            dismiss()
        default:
            Task { await loadData() }
        }
    }
    
    // MARK: - Load Data
    private func loadData() async {
        do {
            let result = try await viewModel.fecthShiftDetail()
            viewModel.shiftDetail = result
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Time Card
    private func timeCard(detail: Api_BookingHours) -> some View {
        let shift = detail.result?.set_shift
        return VStack(spacing: 0) {
            timeRow(label: "",        scheduled: "Scheduled",           actual: "Actual",                        isHeader: true)
            Divider()
            timeRow(label: "In",      scheduled: shift?.start_time ?? "",       actual: detail.result?.clock_in_time ?? "")
            Divider()
            timeRow(label: "Breaks",  scheduled: shift?.break_type ?? "",       actual: detail.result?.break_time ?? "")
            Divider()
            timeRow(label: "Out",     scheduled: shift?.end_time ?? "",         actual: detail.result?.clock_out_time ?? "")
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.separator), lineWidth: 0.5)
        )
    }
    
    private func timeRow (
        label: String,
        scheduled: String,
        actual: String,
        isHeader: Bool = false
    ) -> some View {
        HStack(spacing: 0) {
            IBLabel (
                text: label,
                font: .semibold(isHeader ? .description : .subtitle),
                color: .secondary
            )
            .frame(width: 80, alignment: .leading)
            .padding(.leading, 16)
            
            Divider()
            
            IBLabel (
                text: scheduled,
                font: .semibold(isHeader ? .description : .row),
                color: isHeader ? .secondary : .primary
            )
            .frame(maxWidth: .infinity)
            
            Divider()
            
            IBLabel (
                text: actual.isEmpty ? "—" : actual,
                font: .semibold(isHeader ? .description : .row),
                color: isHeader ? .secondary : .THEME
            )
            .frame(maxWidth: .infinity)
            .padding(.trailing, 16)
        }
        .padding(.vertical, 12)
    }
    
    // MARK: - Info Section
    private func infoSection(detail: Api_BookingHours) -> some View {
        VStack(spacing: 4) {
            Text(detail.result?.set_shift?.job_type ?? "")
                .font(.system(size: 15, weight: .semibold))
            Text("Notes : \(detail.result?.set_shift?.note ?? "")")
                .font(.system(size: 14, weight: .semibold))
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
    }
    
    // MARK: - Notice Box
    private var noticeBox: some View {
        VStack(spacing: 14) {
            Text("If you are late, there is a 5-minute grace period. Arrive within 5 minutes: start time is as scheduled. Arrive after 5 minutes: start time is rounded up to the next 15 minutes.")
                .multilineTextAlignment(.center)
            Text("(e.g. Scheduled at 3:00 pm, arrive 3:04 pm → 3:00 pm. Arrive 3:06 pm → 3:15 pm.)")
                .multilineTextAlignment(.center)
        }
        .font(.system(size: 13, weight: .medium))
        .foregroundColor(.BUTTON)
        .padding(18)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.BUTTON.opacity(0.3), lineWidth: 1.5)
        )
    }
    
    // MARK: - Break Section View
    private func shouldShowBreaks(detail: Api_BookingHours) -> Bool {
        
        guard detail.result?.working_status != "Pending" else { return false }
        
        let breakType = detail.result?.set_shift?.break_type ?? ""
        return breakType != "Not Applicable" && breakType != "Not Aplicable"
    }
    
    private func breakSection(detail: Api_BookingHours) -> some View {
        let shiftBreakTime = detail.result?.set_shift?.shift_break_time ?? ""
        let options: [String] = shiftBreakTime.isEmpty
        ? ["No\nBreak", "Take 30 minutes\nBreak", "Take 1 Hours\nBreak"]
        : [shiftBreakTime]
        
        return GeometryReader { geo in
            let cellWidth  = (geo.size.width / 3) - 10
            let cellHeight = geo.size.height
            
            HStack(spacing: 10) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    breakCell (
                        title: option,
                        index: index,
                        detail: detail,
                        isDynamic: !shiftBreakTime.isEmpty
                    )
                    .frame(width: cellWidth, height: cellHeight)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 80) // fixed height mirrors collectionViewShift.frame.height
    }
    
    private func breakCell (
        title: String,
        index: Int,
        detail: Api_BookingHours,
        isDynamic: Bool
    ) -> some View {
        let currentBreak   = detail.result?.break_time ?? ""
        let _ = detail.result?.set_shift?.shift_break_time ?? ""
        
        let isSelected: Bool = {
            if isDynamic { return !currentBreak.isEmpty }
            switch index {
            case 0: return currentBreak == "No Break Taken"
            case 1: return currentBreak == "30 min"
            case 2: return currentBreak == "1 hour"
            default: return false
            }
        }()
        
        return Button {
            handleBreakTap(index: index, detail: detail, isDynamic: isDynamic)
            print("Call Break Popup")
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(isSelected ? Color.THEME : Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay (
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.THEME, lineWidth: 0.5)
                )
        }
    }
    
    // MARK: - Bottom Bar
    private func bottomBar(detail: Api_BookingHours) -> some View {
        let isClockIn = detail.result?.working_status == "Pending"
        return HStack(spacing: 12) {
            outlineButton(isClockIn ? "Clock-In" : "Clock-out",
                          isLoading: viewModel.isCheckingLocation) {
                handleBookAction(detail: detail)
            }
            outlineButton("Message") {
                // navigate to chat
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 28)
        .background(Color(.systemBackground))
        .overlay (
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator)),
            alignment: .top
        )
    }
        
    private func outlineButton (
        _ title: String,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Group {
                if isLoading {
                    ProgressView().tint(.primary)
                } else {
                    Text(title).font(.system(size: 15, weight: .medium))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .overlay(Capsule().stroke(.BUTTON, lineWidth: 1.5))
        }
        .foregroundColor(.primary)
        .disabled(isLoading)
    }
    
    // MARK: - Break Tap Handler
    private func handleBreakTap (
        index:     Int,
        detail:    Api_BookingHours,
        isDynamic: Bool
    ) {
        let currentBreak   = detail.result?.break_time                  ?? ""
        let cartID         = detail.result?.id                          ?? ""
        let clientID       = detail.result?.client_details?.id          ?? ""
        let breakType      = detail.result?.set_shift?.break_type       ?? ""
        let shiftBreakTime = detail.result?.set_shift?.shift_break_time ?? ""
 
        // mirrors: if dicRequestDetail["break_time"].stringValue != ""
        guard currentBreak.isEmpty else {
            viewModel.locationAlert = LocationAlert(
                title:   "",
                message: "Break has already been selected"
            )
            return
        }
 
        let popup: BreakPopup
 
        if isDynamic {
            // mirrors: strFrom = "Dyanamic"
            popup = BreakPopup (
                head:      "Start \(shiftBreakTime) Break?",
                desc:      "Before you start break, Kindly ensure to notify your relevant suprvior/manager onsite",
                desc2:     "",
                cartID:    cartID,
                clientID:  clientID,
                from:      "Dynamic",
                breakType: breakType,
                breakTime: shiftBreakTime
            )
        } else {
            switch index {
            case 0:
                // mirrors: strFrom = "0" → strBreakTime = "No Break Taken"
                popup = BreakPopup (
                    head:      "No Break Taken?",
                    desc:      "My Shift was more than 6 hours but i got the approval from the manager onsite not to take any break.",
                    desc2:     "Key in name of manage above",
                    cartID:    cartID,
                    clientID:  clientID,
                    from:      "0",
                    breakType: breakType,
                    breakTime: ""
                )
            case 1:
                // mirrors: strFrom = "1" → strBreakTime = "30 min"
                popup = BreakPopup (
                    head:      "You are taking 30 min Break?",
                    desc:      "The break timing requires manager approval first as the standard break time is 1 hour.",
                    desc2:     "Key in name of manage who approved your 30 mins break",
                    cartID:    cartID,
                    clientID:  clientID,
                    from:      "1",
                    breakType: breakType,
                    breakTime: ""
                )
            default:
                // mirrors: strFrom = "2" → strBreakTime = "1 hour"
                popup = BreakPopup (
                    head:      "Start 1 hour Break?",
                    desc:      "Before you start break, Kindly ensure to notify your relevant suprvior/manager onsite",
                    desc2:     "",
                    cartID:    cartID,
                    clientID:  clientID,
                    from:      "2",
                    breakType: breakType,
                    breakTime: ""
                )
            }
        }
 
        viewModel.activeBreakPopup = popup
    }


    // MARK: - Clock In / Out Action
    private func handleBookAction(detail: Api_BookingHours) {
        viewModel.isCheckingLocation = true
        Task {
            defer { viewModel.isCheckingLocation = false }
            
            let result = await LocationManager.shared.isWithinRadius (
                clientLat: Double(viewModel.shiftDetail?.result?.client_details?.lat ?? "") ?? 0.0,
                clientLon: Double(viewModel.shiftDetail?.result?.client_details?.lon ?? "") ?? 0.0
            )
            
            switch result {
            case .withinRange:
                let isPending = detail.result?.working_status == "Pending"
                if isPending {
                   Task {
                      try? await viewModel.addClockOutIn(strType: "IN")
                    }
                } else {
                    viewModel.showClockOutConfirmation = true
                }
                
            case .tooFar(let distance):
                let action = detail.result?.working_status == "Pending" ? "clock-in" : "clock-out"
                viewModel.locationAlert = LocationAlert (
                    title:   "Too Far",
                    message: "Unable to \(action). You are \(Int(distance))m away — outside the 150m allowed radius. Enable location services if they are off, then try again."
                )
                
            case .locationUnavailable:
                viewModel.locationAlert = LocationAlert (
                    title:   "Location Error",
                    message: "Unable to fetch your current location. Please enable GPS and try again."
                )
            }
        }
    }
}

#Preview {
    BookingHoursView(cartID: "1")
}
