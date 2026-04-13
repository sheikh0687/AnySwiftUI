//
//  BookingHoursView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 13/04/26.
//

import SwiftUI

struct BookingHoursView: View {
    
    @StateObject private var viewModel: BookingHourViewModel
    
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
            } else if let error = viewModel.customError {
                Text(error.localizedDescription)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .background(Color(.systemGroupedBackground))
        .task {
            await loadData()
        }
    }
    
    // MARK: - Load Data
    private func loadData() async {
        viewModel.isLoading = true
        do {
            let result = try await viewModel.fecthShiftDetail()
            viewModel.shiftDetail = result
        } catch {
            viewModel.customError = error as? CustomError
        }
        viewModel.isLoading = false
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
                    breakCell(
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

    private func breakCell(
        title: String,
        index: Int,
        detail: Api_BookingHours,
        isDynamic: Bool
    ) -> some View {
        let currentBreak   = detail.result?.break_time ?? ""
        let shiftBreakTime = detail.result?.set_shift?.shift_break_time ?? ""

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
//            handleBreakTap(index: index, detail: detail, isDynamic: isDynamic)
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(isSelected ? .white : .primary)
                .frame(maxWidth: .infinity)
                .frame(height: 80)
                .background(isSelected ? Color.THEME : Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator), lineWidth: 0.5)
                )
        }
    }
    
    // MARK: - Bottom Bar
    private func bottomBar(detail: Api_BookingHours) -> some View {
        let isClockIn = detail.result?.working_status == "Pending"
        return HStack(spacing: 12) {
            outlineButton(isClockIn ? "Clock-In" : "Clock-out") {
                // trigger clock in/out action
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
    
    private func outlineButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .overlay(Capsule().stroke(.BUTTON, lineWidth: 1.5))
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    BookingHoursView(cartID: "1")
}
