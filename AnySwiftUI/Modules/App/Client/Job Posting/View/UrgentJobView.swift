//
//  UrgentJobView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/04/26.
//

import SwiftUI

struct UrgentJobView: View {
    
    @State var viewModel = UrgentShiftViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 8) {
                    IBLabel (
                        text: "Urgent Bookings For Today",
                        font: .semibold(.title),
                        color: .black
                    )
                    
                    IBLabel (
                        text: "Accepted shifts are confirmed and cannot be modified",
                        font: .semibold(.subtitle),
                        color: .red
                    )
                }
                
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                            .frame(maxWidth: .infinity)
                    } else if viewModel.urgentShift.isEmpty {
                        EmptyView (
                            title: "",
                            subtitle: "No Urgent Bookings At The Moment",
                            img: ""
                        )
                    } else {
                        ForEach(viewModel.urgentShift, id: \.id) { broadcast in
                            BroadcastView(obj: broadcast)
                        }
                    }
                }
            }
            .padding(.all, 24)
        }
        .task {
            await loadUrgentShift()
        }
    }
    
    func loadUrgentShift() async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let result = try await viewModel.fetchUrgentShift()
            if result.status == "1" {
                viewModel.urgentShift = result.result ?? []
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

#Preview {
    UrgentJobView()
}

struct BroadcastView: View {
    
    let obj: Res_FetchUrgentShift?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                infoItem(title: "Job Type", value: obj?.job_type ?? "-")
                infoItem(title: "Rate",
                         value: "\(obj?.currency_symbol ?? "")\(obj?.shift_rate ?? "") / hr")
            }
            
            HStack(spacing: 16) {
                infoItem(title: "Start Time", value: obj?.start_time ?? "-")
                infoItem(title: "End Time", value: obj?.end_time ?? "-")
            }
            
            HStack(spacing: 16) {
                infoItem(title: "Lunch", value: obj?.meals ?? "-")
                infoItem(title: "Breaks", value: obj?.break_type ?? "-")
            }
        }
        .padding(20)
        .background (
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 10)
        )
        .padding(.horizontal, 16)
    }
    
    private func infoItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        //        .padding(.vertical, 12)
        //        .padding(.horizontal, 14)
        .background (
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.gray.opacity(0.06))
        )
    }
}
