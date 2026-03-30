//
//  PasswordOtpView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

import SwiftUI

struct PasswordOtpView: View {
    
    @ObservedObject var viewModel: OtpViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                headerText
                otpField
                moreInstruction
                
                Spacer()
                
                IBSubmitButton(buttonText: "Next") {
                    viewModel.navContinue = true
                }
            }
            .padding(.all, 24)
        }
        .navigationBarBackButtonHidden(false)
        .navigationDestination(isPresented: $viewModel.navContinue) {
            UpdatePasswordView()
        }
    }
    
    private var headerText: some View {
        VStack(alignment: .leading, spacing: 8) {
            IBLabel (
                text: "Password Reset",
                font: .bold(.title),
                color: .black
            )
            
            IBLabel (
                text: "We’ve sent you an email containing a 5-digit verification code. Enter the code below:",
                font: .semibold(.subtitle),
                color: .gray
            )
        }
    }
    
    private var otpField: some View {
        VStack(alignment: .leading, spacing: 8) {
            IBLabel (
                text: "5-Digit Verification Code",
                font: .bold(.title),
                color: .black
            )
            
            OTPFieldView(viewModel: viewModel, digits: $viewModel.digits)
            
            if viewModel.showErrorMessgae {
                IBLabel (
                    text: "Please enter the correct code",
                    font: .medium(.subtitle),
                    color: .red
                )
//                .multilineTextAlignment(.center)
            }
        }
    }
    
    private var moreInstruction: some View {
        VStack(alignment: .leading, spacing: 8) {
            IBLabel (
                text: "Didn't Receive The Email",
                font: .bold(.title),
                color: .black
            )
            
            VStack(alignment: .leading, spacing: 4) {
                IBLabel (
                    text: "1. Check your spam or junk folder.",
                    font: .semibold(.subtitle),
                    color: .gray
                )
                
                IBLabel (
                    text: "2. Make sure you entered the correct email address.",
                    font: .semibold(.subtitle),
                    color: .gray
                )
                
                IBLabel (
                    text: "3. Still need help? Contact Support.",
                    font: .semibold(.subtitle),
                    color: .gray
                )
            }
        }
    }
}

#Preview {
    PasswordOtpView(viewModel: .init(contactNumber: "", email: "", strType: "", mobileCode: ""))
}
