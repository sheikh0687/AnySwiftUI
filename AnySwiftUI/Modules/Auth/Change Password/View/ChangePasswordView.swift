//
//  ChangePasswordView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @StateObject private var viewModel = ChangePasswordViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                currentPasswordField
                
                newPasswordField
                
                confirmPasswordField
                
                IBSubmitButton(buttonText: "Update") {
                    print("")
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Change Password")
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var currentPasswordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
                IBSecureTextField(placeholder: "Please enter password", text: $viewModel.oldPassword)
            }
            Divider()
                .frame(height: 0.5)
                .background(Color.LIGHTGRAY)
        }
    }
    
    private var newPasswordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
                IBSecureTextField(placeholder: "Please enter password", text: $viewModel.password)
            }
            Divider()
                .frame(height: 0.5)
                .background(Color.LIGHTGRAY)
        }
    }
    
    private var confirmPasswordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
                IBSecureTextField(placeholder: "Please confirm password", text: $viewModel.confirmPassword)
            }
            Divider()
                .frame(height: 0.5)
                .background(Color.LIGHTGRAY)
        }
    }
}

#Preview {
    ChangePasswordView()
}
