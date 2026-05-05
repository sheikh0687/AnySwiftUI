//
//  JobWeeklyView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 20/04/26.
//

import SwiftUI

struct JobWeeklyView: View {
    
    let weekDays: [Date]
    let weekDayNames: [String]
    let currentMonthYear: String
    let jobTypes: [Res_WeeklyShift]
    
    @Binding var navigateToRequestByDate: String?
    
    let onPreviousWeek: () -> Void
    let onNextWeek: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Week Navigation
            HStack {
                Button(action: onPreviousWeek) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
                Spacer()
                Text(currentMonthYear)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
                Button(action: onNextWeek) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Week Calendar Strip
            weekCalendarStrip
                .padding(.horizontal, 8)
            
            // Job Types
            VStack(spacing: 12) {
                ForEach(jobTypes, id: \.id) { jobType in
                    jobTypeRow(jobType)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer(minLength: 40)
        }
    }
    
    // MARK: - Calendar Strip
    
    var weekCalendarStrip: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.18, green: 0.76, blue: 0.90))
                .frame(height: 90)
            
            HStack(spacing: 0) {
                ForEach(Array(weekDays.enumerated()), id: \.offset) { index, date in
                    let isToday = Calendar.current.isDateInToday(date)
                    let fmt = DateFormatter()
                    let _ = { fmt.dateFormat = "dd" }()
                    
                    VStack(spacing: 4) {
                        if isToday {
                            Text("Today")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        Text(weekDayNames[index])
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(isToday ? .black : .white)
                        Text(fmt.string(from: date))
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(isToday ? .black : .white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background (
                        isToday
                        ? RoundedRectangle(cornerRadius: 20).fill(Color.white)
                        : nil
                    )
                    .padding(.horizontal, 2)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 6)
        }
    }
    
    // MARK: - Job Type Row
    
    func jobTypeRow(_ jobType: Res_WeeklyShift) -> some View {
        let dayCounts = jobType.dayWiseCount ?? []
        
        return VStack(alignment: .leading, spacing: 8) {
            Text(jobType.name ?? "")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.primary)
            
            HStack(spacing: 0) {
                ForEach(dayCounts, id: \.id) { count in
                    
                    let acceptCount  = count.accept_shift_count ?? 0
                    let pendingCount = count.pending_shift_count ?? 0
                    let isClosed     = count.booking_status == "Close"
                    let isOpen       = count.booking_status == "Open"
                    
                    ZStack {
                        
                        // MARK: - Main Circle / Plus
                        Group {
                            // No shifts
                            if acceptCount == 0 && pendingCount == 0 {
                                if isOpen {
                                    Circle()
                                        .stroke(Color.GREEN, lineWidth: 1.5)
                                        .frame(width: 40, height: 40)
                                        .overlay (
                                            Text("0")
                                                .foregroundColor(Color.GREEN)
                                                .font(.system(size: 15, weight: .semibold))
                                        )
                                } else {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.gray.opacity(0.25))
                                        .font(.system(size: 40))
                                }
                            }
                            // Has shifts
                            else {
                                if isClosed {
                                    Circle()
                                        .fill(Color.GREEN)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Text("\(acceptCount)")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15, weight: .semibold))
                                        )
                                } else {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.gray.opacity(0.25))
                                        .font(.system(size: 40))
                                }
                            }
                        }
                        
                        // MARK: - Pending Badge (Bigger)
                        if pendingCount > 0 {
                            Text("\(pendingCount)")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 5)
                                .background(Color.orange)
                                .clipShape(Capsule())                 // grows for 2+ digits
                                .overlay(
                                    Capsule().stroke(Color.white, lineWidth: 2)
                                )
                                .offset(x: 16, y: -16)               // better position
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let weekDate = count.week_date {
                            navigateToRequestByDate = weekDate
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}
