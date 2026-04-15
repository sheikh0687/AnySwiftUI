//
//  ShiftSummaryView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 14/04/26.
//

import SwiftUI

struct ShiftSummaryView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    
    let cartDetail: Api_BookingHours      // set_shift data
    let clientDetail: Api_ClockOutIn // clock in/out result
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                thankYouHeader
                
                timeCard
                
                homeButton
            }
            .padding()
        }
        .navigationTitle("Booking Detail")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

private extension ShiftSummaryView {
    
    var thankYouHeader: some View {
        VStack(spacing: 6) {
            Text("Thank You for Working Today")
                .font(.title3.bold())
            
            Text("Today's Work Summary")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

private extension ShiftSummaryView {
    
    var timeCard: some View {
        let shiftDetail = cartDetail.result?.set_shift
        let clientDetail = clientDetail.result
        return VStack(spacing: 0) {
            timeRow(label: "",        scheduled: "Scheduled",           actual: "Actual",                        isHeader: true)
            Divider()
            timeRow(label: "In",      scheduled: shiftDetail?.start_time ?? "",       actual: clientDetail?.clock_in_time ?? "")
            Divider()
            timeRow(label: "Breaks",  scheduled: shiftDetail?.break_type ?? "",       actual: clientDetail?.break_time ?? "")
            Divider()
            timeRow(label: "Out",     scheduled: shiftDetail?.end_time ?? "",         actual: clientDetail?.clock_out_time ?? "")
            Divider()
            timeRow(label: "Total", scheduled: shiftDetail?.total_time ?? "", actual: clientDetail?.total_working_hr_time ?? "")
            Divider()
            timeRow(label: "Rate", scheduled: "", actual: "\(AppState.shared.currencySymbol)\(clientDetail?.shift_rate ?? "")")
            Divider()
            timeRow(label: "Total Pay", scheduled: "", actual: "\(AppState.shared.currencySymbol)\(clientDetail?.total_amount ?? "")")
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
                color: isHeader ? .secondary : .GREEN
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
}

private extension ShiftSummaryView {
    
    var homeButton: some View {
        Button {
            //            Switcher.updateRootVC()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                appState.switchToTab = .myBooking
                appState.goToHome = true
                dismiss()
            }
        } label: {
            Text("Home")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.top, 10)
    }
}

//#Preview {
//    ShiftSummaryView()
//}
