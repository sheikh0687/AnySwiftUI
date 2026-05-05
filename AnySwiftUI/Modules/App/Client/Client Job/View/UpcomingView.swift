//
//  UpcomingView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 20/04/26.
//

import SwiftUI

struct UpcomingView: View {
    
    let upcomingShifts: [Res_UpcomingShifts]
    
    @Binding var navigateToRequestByDate: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Upcoming Shifts")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
            
            if !upcomingShifts.isEmpty {
                ForEach(upcomingShifts, id: \.date) { item in
                    upcomingSection(item)
                        .padding(.horizontal, 16)
                }
            } else {
                Text("No Upcoming Shift At The Moment")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.darkGray))
                    .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Upcoming Section
    func upcomingSection(_ item: Res_UpcomingShifts) -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text(item.date ?? "")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.18, green: 0.76, blue: 0.90))
                    .cornerRadius(8)
                Spacer()
            }
            .padding(.bottom, 8)
            
            VStack(spacing: 12) {
                ForEach(item.shift_details ?? [], id: \.id) { shift in
                    shiftCard(shift, date: item.date ?? "")
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.07), radius: 6, x: 0, y: 2)
    }
    
    // MARK: - Shift Card
    
    func shiftCard(_ shift: UpcomingShift_details, date: String) -> some View {
        let workerCount = Int(shift.worker_count ?? "0") ?? 0
        let bookedCount = shift.booked_worker_count ?? 0
        let remainCount = shift.remain_worker_count ?? 0
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(shift.job_type ?? "")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    HStack(spacing: 4) {
                        Image(systemName: "hourglass")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text("\(shift.start_time ?? "") : \(shift.end_time ?? "")")
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Status")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                    ProgressView(value: workerCount > 0 ? Float(bookedCount) / Float(workerCount) : 0)
                        .progressViewStyle(.linear)
                        .accentColor(workerCount == bookedCount ? .GREEN : .orange)
                        .frame(width: 100)
                    Text(workerCount == bookedCount
                         ? "\(bookedCount)/\(workerCount) Fully Booked"
                         : "\(bookedCount)/\(workerCount)  \(remainCount) slot available")
                    .font(.system(size: 11))
                    .foregroundColor(workerCount == bookedCount ? .GREEN : Color(.darkGray))
                }
            }
            
            if shift.break_type != "Not Applicable" {
                Text("Break Time: \(shift.shift_break_time ?? "")")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Text("Break : \(shift.break_type ?? "")")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            Text("Meals : \(shift.meals ?? "")")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            Text("Notes: \(shift.note ?? "")")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
            
            if let workers = shift.worker_details, !workers.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(workers, id: \.id) { worker in
                            VStack(spacing: 4) {
                                AsyncImage(url: URL(string: worker.image ?? "")) { phase in
                                    switch phase {
                                    case .success(let img): img.resizable().scaledToFill()
                                    default: Image(systemName: "person.fill").resizable()
                                            .scaledToFit().foregroundColor(.gray).padding(8)
                                    }
                                }
                                .frame(width: 56, height: 56)
                                .clipShape(Circle())
                                .background(Color(.systemGray5).clipShape(Circle()))
                                
                                Text("\(worker.first_name ?? "")\n\(worker.last_name ?? "")")
                                    .font(.system(size: 10))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .frame(width: 60)
                            }
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onTapGesture { navigateToRequestByDate = date }
    }
}
