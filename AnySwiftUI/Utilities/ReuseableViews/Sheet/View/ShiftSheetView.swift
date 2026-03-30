//
//  ShiftSheetView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 30/03/26.
//

import SwiftUI

struct ShiftSheetView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ShiftViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView("Loading Jobs...")
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if viewModel.jobTypes.isEmpty {
                        EmptyView(title: "", subtitle: "No Jobs At The Moment", img: "")
                    } else {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.jobTypes, id: \.id) { jobTypes in
                                ShiftCardView(vM: viewModel, obj: jobTypes)
                            }
                        }
                    }
                }
            }
            .padding(.all, 24)
        }
        .onAppear {
            Task {
                await loadJobTypes()
            }
            viewModel.dismissJobType = false
        }
        .onChange(of: viewModel.dismissJobType) {
            dismiss()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func loadJobTypes() async {
        viewModel.isLoading = true
        viewModel.customError = nil
        
        defer { viewModel.isLoading = false }
        
        do {
            let response = try await viewModel.fetchJobTypes()
            if response.status == "1" {
                viewModel.jobTypes = response.result ?? []
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

struct ShiftCardView: View {
    
    let vM: ShiftViewModel
    let obj: Res_JobType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            IBLabel (
                text: obj.name ?? "",
                font: .medium(.title),
                color: .black
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            vM.cloJobType?(obj.id ?? "", obj.name ?? "")
            vM.dismissJobType = true
        }
    }
}

#Preview {
    ShiftSheetView(viewModel: .init(cloJobType: { jobid, jobName in
        print(jobid, jobName)
    }))
}
