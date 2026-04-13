//
//  DayCell.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 31/03/26.
//

import SwiftUI

struct DayCell: View {
    
    let date: Date
    let isSelected: Bool
    let dayCount: Res_DayShiftCount?
    
    var body: some View {
        VStack(spacing: 12) {
            
            IBLabel (
                text: dayName,
                font: .medium(.caption),
                color: isSelected ? .BUTTON : .BLACK
            )
                        
            IBLabel (
                text: dayNumber,
                font: .semibold(.subtitle),
                color: isSelected ? .BUTTON : .BLACK
            )
            
            let status = dayCount?.selected_day_my_booking_status
            if status == "Available" {
                IBLabel (
                    text: String(dayCount?.shift_count ?? 0),
                    font: .semibold(.subtitle),
                    color: .BLACK
                )
                .frame(width: 24, height: 24)
                .overlay (
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.GREEN)
                )
            } else if status == "Accepted" {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.GREEN)
                    .padding(4)
            } else if status == "Pending" {
                ZStack {
                    Circle()
                        .stroke(.BUTTON, lineWidth: 1)
                        .frame(width: 24, height: 24)
                    IBLabel(text: "P", font: .semibold(.subtitle), color: .BUTTON)
                }
            } else if status == "Full" {
                ZStack {
                    Circle()
                        .stroke(.red, lineWidth: 1)
                        .frame(width: 24, height: 24)
                    IBLabel(text: "F", font: .semibold(.subtitle), color: .red)
                }
            } else {
                IBLabel (
                    text: String(dayCount?.shift_count ?? 0),
                    font: .semibold(.subtitle),
                    color: .BLACK
                )
                .frame(width: 24, height: 24)
                .overlay (
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.gray)
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(isSelected ? Color.white : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var dayNumber: String {
        SGDate.formatter("dd").string(from: date)
    }
    
    var dayName: String {
        SGDate.formatter("EEE").string(from: date)
    }
}

#Preview {
    DayCell (
        date: Date(),
        isSelected: true,
        dayCount: Res_DayShiftCount (
            date: "2026-03-31",
            selected_day_my_booking_status: "Full",
            shift_count: 1
        )
    )
}
