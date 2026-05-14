//
//  ManpowerView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 20/04/26.
//

import SwiftUI

struct ManpowerView: View {
    
    let todayShiftName: String
    let todayShiftDescription: String
    let manpowerWorkers: [Worker_details]
    
    @Binding var navigateToRequest: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Date Header
            VStack(alignment: .leading, spacing: 4) {
                Text(SGDate.dayName(from: Date()))
                    .font(.system(size: 16))
                    .foregroundColor(Color(.systemGray))
                Text(SGDate.currentDateWithMonth())
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            Divider().padding(.horizontal, 16)
            
            // Today's Requirement
            if !todayShiftLabel.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Today's Requirement")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    Text(todayShiftLabel)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.darkGray))
                }
                .padding(.horizontal, 16)
                
                Divider().padding(.horizontal, 16)
            }
            
            // Today's Manpower
            VStack(alignment: .leading, spacing: 12) {
                Text("Today's Manpower")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                
                if !manpowerWorkers.isEmpty {
                    ForEach(manpowerWorkers, id: \.id) { worker in
                        workerCard(worker)
                            .padding(.horizontal, 16)
                    }
                } else {
                    Text("No application yet.")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.darkGray))
                        .padding(.horizontal, 16)
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    var todayShiftLabel: String {
        var text = todayShiftName
        if !todayShiftDescription.isEmpty {
            text += "\n\(todayShiftDescription)"
        }
        return text
    }
    
    // MARK: - Worker Card
    
    func workerCard(_ worker: Worker_details) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: worker.image ?? "")) { phase in
                switch phase {
                case .success(let img):
                    img.resizable().scaledToFill()
                default: Image(systemName: "person.circle.fill").resizable().foregroundColor(.gray)
                }
            }
            .frame(width: 52, height: 52)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(worker.first_name ?? "") \(worker.last_name ?? "")")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "bag.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        Text(worker.shift_details?.job_type ?? "")
                            .font(.system(size: 12))
                            .foregroundColor(.GREEN)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                        Text("\(worker.shift_details?.start_time ?? "") - \(worker.shift_details?.end_time ?? "")")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text("\(worker.currency_symbol ?? "")\(worker.shift_booking_details?.shift_rate ?? "")/Hour")
                        .font(.system(size: 12))
                        .foregroundColor(.GREEN)
                }
                
                Text(displayStatus(worker))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(statusColor(worker))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.system(size: 14))
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onTapGesture { navigateToRequest = true }
    }
    
    func displayStatus(_ worker: Worker_details) -> String {
        let bookingStatus = worker.shift_booking_details?.status ?? ""
        let workingStatus = worker.shift_booking_details?.working_status ?? ""
        let clockIn       = worker.shift_booking_details?.clock_in_time ?? ""
        let clockOut      = worker.shift_booking_details?.clock_out_time ?? ""
        
        if bookingStatus == "Pending" {
            return "Pending Approval"
        }
        
        switch workingStatus {
        case "Pending":   return "Confirmed"
        case "Clock-In":  return "Clock-In : \(clockIn)"
        case "Clock-Out": return "Clock-Out : \(clockOut)"
        default:          return bookingStatus
        }
    }
    
    func statusColor(_ worker: Worker_details) -> Color {
        let bookingStatus = worker.shift_booking_details?.status ?? ""
        let workingStatus = worker.shift_booking_details?.working_status ?? ""
        
        if bookingStatus == "Pending" {
            return .orange
        }
        
        switch workingStatus {
        case "Pending":             return .GREEN   // "Confirmed"
        case "Clock-In", "Clock-Out": return .black
        default:                    return .secondary
        }
    }
}
