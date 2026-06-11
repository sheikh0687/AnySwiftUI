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
                        ForEach(viewModel.urgentShift) { broadcast in
                            BroadcastView(obj: broadcast) {
                                viewModel.updateShift = true
                                viewModel.shiftiD = broadcast.id ?? ""
                                viewModel.outletName = broadcast.business_name ?? ""
                            } onDelete: {
                                Task {
                                    await deleteUrgentShift(shiftiD: broadcast.id ?? "")
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button {
                        viewModel.addUrgentShift = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.BLACK)
                            .clipShape(.circle)
                            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                    }
                }
            }
            .padding(.all, 24)
        }
        .task {
            await loadUrgentShift()
        }
        .navigationDestination(isPresented: $viewModel.addUrgentShift) {
            JobPostingView(viewModel: .init(selectedType: .urgent))
        }
        .navigationDestination(isPresented: $viewModel.updateShift) {
            UpdateShiftView(viewModel: .init(shiftiD: viewModel.shiftiD, selectedOutletName: viewModel.outletName))
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
    
    func deleteUrgentShift(shiftiD: String) async {
        viewModel.isLoading = true
        
        do {
            let result = try await viewModel.deleteUrgentShift(shiftiD: shiftiD)
            if result.status == "1" {
                withAnimation {
                    viewModel.urgentShift.removeAll(where: { $0.id == shiftiD })
                }
                await loadUrgentShift()
            } else {
                viewModel.isLoading = false
            }
        } catch {
            viewModel.isLoading = false
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

#Preview {
    UrgentJobView()
}

struct BroadcastView: View {
    
    let obj: Res_FetchUrgentShift?
    var onUpdate: () -> Void = {}
    var onDelete: () -> Void = {}
    
    // MARK: Dynamic Values
    private var jobType: String { obj?.job_type ?? "-" }
    private var startTime: String { obj?.start_time ?? "-" }
    private var endTime: String { obj?.end_time ?? "-" }
    private var meals: String { obj?.meals?.isEmpty == false ? obj!.meals! : "Not Provided" }
    private var breaks: String { obj?.break_type?.isEmpty == false ? obj!.break_type! : "Not Applicable" }
    
    private var rateText: String {
        let currency = obj?.currency_symbol ?? "₹"
        let rate = obj?.shift_rate ?? "0"
        return "\(currency)\(rate) /Hour"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Row 1 (Job + Rate + Menu)
            ZStack(alignment: .topTrailing) {
                twoColumnRow (
                    leftTitle: "Job Type",
                    leftValue: jobType,
                    rightTitle: "Rate",
                    rightValue: rateText
                )
                
                menuButton
                    .offset(x: 8, y: -8)
            }
            
            dividerLine()
            
            // MARK: Row 2 (Start / End)
            twoColumnRow (
                leftTitle: "Start Time",
                leftValue: startTime,
                rightTitle: "End Time",
                rightValue: endTime
            )
            
            dividerLine()
            
            // MARK: Row 3 (Lunch / Breaks)
            twoColumnRow (
                leftTitle: "Lunch",
                leftValue: meals,
                rightTitle: "Breaks",
                rightValue: breaks
            )
        }
        .padding(.all, 16)
        .background(cardBackground)
        //        .padding(.horizontal, 16)
    }
    
    private var menuButton: some View {
        Menu {
            Button { onUpdate() } label: {
                Label("Update", systemImage: "pencil")
            }
            Button(role: .destructive) { onDelete() } label: {
                Label("Delete", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 18, weight: .bold))
                .rotationEffect(.degrees(90))
                .frame(width: 40, height: 40)
                .contentShape(Rectangle())
        }
    }
    
    private func dividerLine() -> some View {
        Divider()
            .padding(.vertical, 14)
    }
    
    private func twoColumnRow (
        leftTitle: String,
        leftValue: String,
        rightTitle: String,
        rightValue: String
    ) -> some View {
        HStack(spacing: 0) {
            column(title: leftTitle, value: leftValue)
            
            Divider()
                .frame(height: 50)
            
            column(title: rightTitle, value: rightValue)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func column(title: String, value: String) -> some View {
        VStack(alignment: .center, spacing: 6) {
            IBLabel (
                text: title,
                font: .semibold(.description),
                color: .gray
            )
            .multilineTextAlignment(.center)
            
            IBLabel (
                text: value,
                font: .semibold(.title),
                color: .BLACK
            )
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)  // ✅ Force center
        //        .padding(.vertical, 8)
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color(.systemGray6))
            .overlay (
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
    }
}
