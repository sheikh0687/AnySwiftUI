//
//  ClientTransactionHistoryView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/06/26.
//

import SwiftUI

struct ClientTransactionHistoryView: View {
    
    @State var viewModel = ClientTransactionHisViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 24) {
                // Header
                headerText
                
                VStack(spacing: 0) {
                    IBLabel (
                        text: "Transaction History",
                        font: .medium(.title),
                        color: .BLACK
                    )
                    
                    Divider()
                }
                // Transaction
                transactionHistory
            }
            .padding(.all, 24)
        }
        .task {
            await loadTransactionHistory()
        }
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Ok"))
            )
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .navigationDestination(isPresented: $viewModel.navToAddRating) {
            AddRatingView(requestID: viewModel.requestiD, toID: viewModel.useriD)
        }
    }
    
    func loadTransactionHistory() async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.fetchClientTransactions()
            if response.status == "1" {
                viewModel.arrayTransactionHistory = response.result ?? []
                viewModel.totalJobs = String(response.total_job ?? 0)
                viewModel.totalSpent = String(response.total_earning ?? 0)
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    private var headerText: some View {
        HStack {
            VStack(alignment: .center, spacing: 8) {
                IBLabel (
                    text: "Total Spent",
                    font: .semibold(.title),
                    color: .black
                )
                
                IBLabel (
                    text: "\(AppState.shared.currencySymbol) \(viewModel.totalSpent)",
                    font: .semibold(.largeTitle),
                    color: .black
                )
            }
            
            Spacer()

            Divider()
                .frame(width: 1 , height: 80)
                .background(Color.white)

            Spacer()
            
            VStack(alignment: .center, spacing: 8) {
                IBLabel (
                    text: "Total Jobs Given",
                    font: .semibold(.title),
                    color: .black
                )
                
                IBLabel (
                    text: viewModel.totalJobs,
                    font: .semibold(.largeTitle),
                    color: .black
                )
            }
        }
        .padding(.all, 24)
        .background (
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
        )
        .overlay (
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        )
    }
    
    private var transactionHistory: some View {
        VStack(alignment: .leading, spacing: 24) {
            ScrollView(showsIndicators: false) {
                if viewModel.isLoading {
                    ProgressView("Loading Transactions...")
                        .frame(maxWidth: .infinity)
                        .padding()
                } else if viewModel.arrayTransactionHistory.isEmpty {
                    EmptyView(title: "", subtitle: "No Transactions At The Moment", img: "")
                } else {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.arrayTransactionHistory, id: \.id) { clientHistory in
                            ClientTransactionHistoryCard(obj: clientHistory, vm: viewModel)
                        }
                    }
                }
            }
        }
    }
}

struct ClientTransactionHistoryCard: View {
    
    let obj: Res_ClientTransactionHistory
    let vm: ClientTransactionHisViewModel
    
    // MARK: - Computed Properties
    private var dateAndName: String {
        "\(obj.format_date ?? "") - \(obj.user_details?.first_name ?? "") \(obj.user_details?.last_name ?? "")"
    }

    private var shiftRate: String {
        "\(obj.total_working_hr_time ?? "") Hour/Rate \(obj.set_shift_details?.currency_symbol ?? "")\(obj.shift_rate ?? "") = \(obj.set_shift_details?.currency_symbol ?? "")\(obj.total_amount ?? "")"
    }

    private var shiftTime: String {
        "Time-In \(obj.clock_in_time ?? "") / Time-Out \(obj.clock_out_time ?? "")"
    }

    private var breakType: String {
        obj.set_shift_details?.break_type == "Not Aplicable"
            ? "Break Type : Not Aplicable"
            : "\(obj.set_shift_details?.break_type ?? "") Break : \(obj.break_time ?? "")"
    }

    private var ratingValue: Int {
        Int(Double(obj.rating ?? "0") ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            IBLabel(text: dateAndName, font: .semibold(.title), color: .black)

            VStack(alignment: .leading, spacing: 2) {
                IBLabel(text: shiftRate, font: .regular(.subtitle), color: .black)
                IBLabel(text: shiftTime, font: .regular(.subtitle), color: .black)
                IBLabel(text: breakType, font: .regular(.subtitle), color: .black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if obj.rating_review_status == "Yes" {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= ratingValue ? "star.fill" : "star")
                                .foregroundStyle(.yellow)
                                .font(.system(size: 14))
                        }
                    }
                    IBLabel(text: obj.review ?? "", font: .regular(.subtitle), color: .gray) 
                }
            } else {
                HStack {
                    Spacer()
                    IBSimpletButton(height: 32, width: 100, fgColor: .white, buttonText: "Give Rating", bg: .BUTTON) {
                        vm.requestiD = obj.id ?? ""
                        vm.useriD = obj.user_id ?? ""
                        vm.navToAddRating = true
                    }
                }
            }
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
}

#Preview {
    ClientTransactionHistoryView()
}
