//
//  ResetPasswordView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @StateObject var viewModel = ResetPasswordViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    IBLabel (
                        text: "Forgot Password",
                        font: .bold(.title),
                        color: .black
                    )
                    
                    IBLabel (
                        text: "No worries! We're here to help you get back into your account.",
                        font: .semibold(.subtitle),
                        color: .gray
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    IBLabel (
                        text: "How it works",
                        font: .bold(.title),
                        color: .black
                    )
                    VStack(alignment: .leading, spacing: 4) {
                        IBLabel (
                            text: "1. Enter your email address: Provide the email associated with your account.",
                            font: .semibold(.subtitle),
                            color: .gray
                        )
                        
                        IBLabel (
                            text: "2. Check your inbox: We’ll send you a link to reset your password.",
                            font: .semibold(.subtitle),
                            color: .gray
                        )
                        
                        IBLabel (
                            text: "3. Reset your password: Follow the instructions in the email to create a new password.",
                            font: .semibold(.subtitle),
                            color: .gray
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    IBLabel (
                        text: "Reset Password",
                        font: .bold(.title),
                        color: .black
                    )
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "envelope.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                            IBTextField(placeholder: "Please enter email",
                                        text: $viewModel.email,keyboardType:    UIKeyboardType.emailAddress)
                        }
                        Divider()
                            .frame(height: 0.5)
                            .background(Color.LIGHTGRAY)
                    }
                }
                
                Spacer()
                
                IBSubmitButton(buttonText: "Next") {
                    viewModel.navContinue = true
                }
            }
            .padding(.all, 24)
        }
        .navigationBarBackButtonHidden(false)
        .navigationDestination(isPresented: $viewModel.navContinue) {
            PasswordOtpView(viewModel: .init(contactNumber: "", email: "", strType: "", mobileCode: ""))
        }
    }
}

#Preview {
    ResetPasswordView()
}
