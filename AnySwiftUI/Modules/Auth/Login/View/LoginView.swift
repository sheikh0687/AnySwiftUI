//
//  LoginView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/02/26.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject private var viewModel: LoginViewModel
    
    init(userType: String) {
        _viewModel = ObservedObject(wrappedValue: LoginViewModel(userType: userType))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 40) {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120)
                
                HStack(alignment: .center, spacing: 24) {
                    VStack(spacing: 4) {
                        IBLabel(text: "Login", font: .semibold(.largeTitle), color: viewModel.isLogin ? Color.THEME : Color.LIGHTGRAY)
                        Divider()
                            .frame(width: 120, height: 2)
                            .background(viewModel.isLogin ? Color.THEME : Color.LIGHTGRAY)
                    }
                    .onTapGesture {
                        viewModel.isLogin = true
                    }
                    
                    VStack(spacing: 4) {
                        IBLabel(text: "Sign Up", font: .semibold(.largeTitle), color: viewModel.isLogin ? Color.LIGHTGRAY : Color.THEME)
                        Divider()
                            .frame(width: 120, height: 2)
                            .background(viewModel.isLogin ? Color.LIGHTGRAY : Color.THEME)
                    }
                    .onTapGesture {
                        viewModel.isLogin = false
                    }
                }
                
                VStack(alignment: .leading, spacing: 32) {
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "envelope")
                                .font(.title2)
                                .foregroundColor(.gray)
                            IBTextField(placeholder: "Please enter email",
                                        text: $viewModel.email,keyboardType:    UIKeyboardType.emailAddress)
                        }
                        Divider()
                            .frame(height: 0.5)
                            .background(Color.LIGHTGRAY)
                    }
                    
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "lock")
                                .font(.title2)
                                .foregroundColor(.gray)
                            IBSecureTextField(placeholder: "Please enter password", text: $viewModel.password)
                        }
                        Divider()
                            .frame(height: 0.5)
                            .background(Color.LIGHTGRAY)
                    }
                    
                    IBSubmitButton(buttonText: "LOGIN") {
                        print("Login")
                    }
                }
                
                Spacer()
                
                IBLabel(text: "Forgot your email or password?", font: .semibold(.title), color: .gray)
            }
            .padding(.all, 24)
        }
    }
}

#Preview {
    LoginView(userType: "Worker")
}
