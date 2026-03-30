//
//  UpdatePasswordView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

import SwiftUI

struct UpdatePasswordView: View {
    
    @StateObject var viewModel = UpdatePasswordViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                headerText
                newPasswordField
                confirmPasswordField
                
                Spacer()
                
                IBSubmitButton(buttonText: "Finish") {
                    print("Confirm Password")
                }
            }
            .padding(.all, 24)
        }
        .navigationTitle("Set A New Password")
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerText: some View {
        VStack(alignment: .leading, spacing: 8) {
            IBLabel (
                text: "Password Requirements",
                font: .bold(.title),
                color: .black
            )
            
            VStack(alignment: .leading, spacing: 4) {
                IBLabel (
                    text: "1. Must be at least 8 characters long.",
                    font: .semibold(.subtitle),
                    color: .gray
                )
                
                IBLabel (
                    text: "2. Include an uppercase letter, a lowercase letter, a number, and a special character.",
                    font: .semibold(.subtitle),
                    color: .gray
                )
                
                IBLabel (
                    text: "3. Avoid common words and patterns for better security.",
                    font: .semibold(.subtitle),
                    color: .gray
                )
            }
        }
    }
    
    private var newPasswordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            IBLabel (
                text: "New Password",
                font: .bold(.title),
                color: .black
            )
            
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
            IBLabel (
                text: "Confirm Password",
                font: .bold(.title),
                color: .black
            )
            
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
    UpdatePasswordView()
}
