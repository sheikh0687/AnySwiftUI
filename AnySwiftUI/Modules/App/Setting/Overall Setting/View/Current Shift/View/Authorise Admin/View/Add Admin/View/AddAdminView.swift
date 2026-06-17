//
//  AddAdminView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/06/26.
//

import SwiftUI

struct AddAdminView: View {
    
    @State var viewModel: AddAdminViewModel
    @Environment(\.dismiss) var dissmis
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    IBLabel (
                        text: "First Name",
                        font: .medium(.subtitle),
                        color: .BLACK
                    )
                    
                    IBTextField(placeholder: "First Name", text: $viewModel.firstName)
                    
                    Divider()
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    IBLabel (
                        text: "Last Name",
                        font: .medium(.subtitle),
                        color: .BLACK
                    )
                    
                    IBTextField(placeholder: "Last Name", text: $viewModel.lastName)
                    
                    Divider()
                }
                
                Spacer()
                
                IBSubmitButton(buttonText: "Add", isDisabled: viewModel.isValidFeilds(), isLoading: viewModel.isLoading) {
                    print("Call an Api")
                    Task {
                        await callAddAdmin()
                    }
                }
            }
            .padding(.all, 24)
        }
        .navigationTitle(viewModel.strType == "OutletAdmin" ? "Outlet Admin" : "Authorise Approval")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
    
    func callAddAdmin() async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.addAdmin()
            if response.status == "1" {
                dissmis()
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

#Preview {
    AddAdminView(viewModel: .init(strType: "OutletAdmin"))
}
