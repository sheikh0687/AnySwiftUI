//
//  WorkerTransactionView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 27/03/26.
//

import SwiftUI

struct WorkerTransactionView: View {
    
    @StateObject var viewModel = WorkerTransactionViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 24) {
                // Header
                headerText
                
                // Transaction
                transactionHistory
            }
            .padding(.all, 24)
        }
        .onAppear {
            Task {
                await loadTransactionHistory()
            }
        }
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Ok"))
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerText: some View {
        HStack {
            VStack(alignment: .center, spacing: 8) {
                IBLabel (
                    text: "Total Earning",
                    font: .semibold(.title),
                    color: .black
                )
                
                IBLabel (
                    text: "$ 841",
                    font: .semibold(.largeTitle),
                    color: .black
                )
            }
            
            Spacer()
            
            VStack(alignment: .center, spacing: 8) {
                IBLabel (
                    text: "Total Jobs Taken",
                    font: .semibold(.title),
                    color: .black
                )
                
                IBLabel (
                    text: "8",
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
            IBLabel (
                text: "Transaction History",
                font: .semibold(.title)
            )
            
            ScrollView(showsIndicators: false) {
                if viewModel.isLoading {
                    ProgressView("Loading Transactions...")
                        .frame(maxWidth: .infinity)
                        .padding()
                } else if viewModel.workerTransaction.isEmpty {
                    EmptyView(title: "", subtitle: "No Transactions At The Moment", img: "")
                } else {
                    LazyVStack(spacing: 20) {
                        ForEach(viewModel.workerTransaction, id: \.id) { workerHistory in
                            WorkerTransactionHistoryCard(obj: workerHistory)
                        }
                    }
                }
            }
        }
    }
    
    func loadTransactionHistory() async {
        viewModel.isLoading = true
        viewModel.customError = nil
        
        defer { viewModel.isLoading = false }
        
        do {
            let response = try await viewModel.fetchWorkerTransactionHistory()
            if response.status == "1" {
                viewModel.workerTransaction = response.result ?? []
                viewModel.totalEarning = response.total_earning ?? 0
                viewModel.totalJob = response.total_job ?? 0
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

struct WorkerTransactionHistoryCard: View {
    
    let obj: Res_WorkerTransactionHistory
    
    var body: some View {
        VStack(spacing: 16) {
            // Date And Address
            VStack(alignment: .leading, spacing: 2) {
                IBLabel (
                    text: "\(obj.format_date ?? "") - ",
                    font: .semibold(.title),
                    color: .black
                )
                
                IBLabel (
                    text: obj.address ?? "",
                    font: .semibold(.title),
                    color: .black
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Other Details
            VStack(alignment: .leading, spacing: 2) {
                
                // Shift Rate
                IBLabel (
                    text: "\(obj.total_working_hr_time ?? "") Hour/Rate \(obj.set_shift_details?.currency_symbol ?? "")\(obj.shift_rate ?? "") = \(obj.set_shift_details?.currency_symbol ?? "")\(obj.total_amount ?? "")",
                    font: .regular(.subtitle),
                    color: .black
                )
                
                // Shift Time
                IBLabel (
                    text: "Time-In \(obj.clock_in_time ?? "") / Time-Out \(obj.clock_out_time ?? "")",
                    font: .regular(.subtitle),
                    color: .black
                )
                
                // Break Type
                IBLabel (
                    text: obj.set_shift_details?.break_type == "Not Aplicable" ? "Break Type : Not Aplicable" : "\(obj.set_shift_details?.break_type ?? "") Break : \(obj.break_time ?? "")",
                    font: .regular(.subtitle),
                    color: .black
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
    WorkerTransactionView()
}
