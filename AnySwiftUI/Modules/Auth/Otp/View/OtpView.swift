//
//  OtpView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/03/26.
//

import SwiftUI
internal import Combine

struct OtpView: View {
    
    @StateObject private var viewModel: OtpViewModel
    
    init(strType: String, contactNumber: String, mobileCode: String, email: String) {
        _viewModel = StateObject(wrappedValue: OtpViewModel (
            contactNumber: contactNumber,
            email: email,
            strType: strType,
            mobileCode: mobileCode)
        )
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 24) {
                Image(.otp)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                
                IBLabel ( text: "Please enter the verification code sent to\n \(viewModel.contactNumber)", font: .medium(.title))
                    .multilineTextAlignment(.center)
                
                OTPFieldView (
                    viewModel: viewModel,
                    digits: $viewModel.digits
                )
                
                if viewModel.showErrorMessgae {
                    IBLabel (
                        text: "Please enter the correct code",
                        font: .medium(.subtitle),
                        color: .red
                    )
                    .multilineTextAlignment(.center)
                }
                
                if !viewModel.isReceivedOTP {
                    HStack {
                        Text("Didn't receive code?")
                            .font(.body)
                            .foregroundColor(.gray)
                        Button("Resend") {
                            Task {
                                do {
                                    let response = try await viewModel.verifyNumber()
                                    if response.status == "1" {
                                        viewModel.otpCode = response.result?.code ?? 0
                                        viewModel.optionalCode = response.result?.optional_otp ?? ""
                                        print("Recieved Otp Code: \(viewModel.otpCode)")
                                        viewModel.isReceivedOTP = true
                                    }
                                } catch {
                                    viewModel.customError = .customError(message: error.localizedDescription)
                                }
                            }
                        }
                        .font(.body.bold())
                        .foregroundColor(.blue)
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.horizontal)
                }
                
                sendOtp
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
        }
        .onAppear {
            Task {
                do {
                    let response = try await viewModel.verifyNumber()
                    print(response.status ?? "")
                    if response.status == "1" {
                        viewModel.otpCode = response.result?.code ?? 0
                        viewModel.optionalCode = response.result?.optional_otp ?? ""
                        print("Received OTP Code:", viewModel.otpCode)
                        print("Received Optional OTP:", viewModel.optionalCode)
                        viewModel.isReceivedOTP = true
                    }
                } catch {
                    print("Error Catched due to: \(error.localizedDescription)")
                    viewModel.customError = .customError(message: error.localizedDescription)
                }
            }
        }
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("ok"))
            )
        }
        .navigationDestination(isPresented: $viewModel.navContinue) {
            if viewModel.strType == "Worker" {
                WorkerDetailView()
            } else {
                ClientDetailView()
            }
        }
    }
    
    private var sendOtp: some View {
        let enteredCode = viewModel.digits.joined()
        let isValidLength = enteredCode.count == viewModel.numberOfDigits
        print(viewModel.optionalCode)
        print(viewModel.otpCode)
        return Button {
            
            if enteredCode == "\(viewModel.otpCode)" || enteredCode == viewModel.optionalCode {
                print("✅ OTP Verified: \(enteredCode)")
                Task {
                    do {
                        let response = try await viewModel.webRegister()
                        if response.status == "1" {
                            print("Registered Successfully!")
                            
                            viewModel.saveCredentials(res: response.result!)
                            viewModel.navContinue = true
                        }
                    } catch {
                        viewModel.customError = .customError(message: error.localizedDescription)
                    }
                }
            } else {
                print("❌ Invalid OTP. Expected: \(viewModel.otpCode), Got: \(enteredCode)")
                withAnimation {
                    viewModel.digits = Array(repeating: "", count: viewModel.numberOfDigits)
                }
                viewModel.showErrorMessgae = true
            }
        } label: {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.8)
                } else {
                    IBLabel(text: "Submit", font: .regular(.subtitle), color: .white)
                }
            }
            .foregroundColor(.yellow)
            .shadow(radius: 2)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
        }
        .background(isValidLength && !viewModel.isLoading ? .BUTTON : Color.gray.opacity(0.5))
        .cornerRadius(10)
        .disabled(!isValidLength || viewModel.isLoading)
        .padding(.top, 16)
    }
}

struct OTPFieldView: View {
    
    let viewModel: OtpViewModel
    @FocusState private var focusedField: Int?
    @Binding var digits: [String]
    
    var body: some View {
        HStack(spacing: 12) {
            
            ForEach(0..<viewModel.numberOfDigits, id: \.self) { index in
                
                TextField("", text: $digits[index])
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .semibold))
                    .frame(width: 55, height: 60)
                    .background (
                        RoundedRectangle(cornerRadius: 10)
                            .stroke (
                                focusedField == index ? Color.blue : Color.gray.opacity(0.4),
                                lineWidth: 2
                            )
                    )
                    .focused($focusedField, equals: index)
                    .onChange(of: digits[index]) { _, newValue in
                        handleOTPChange(index: index, newValue: newValue)
                    }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
        .onAppear {
            focusedField = 0
        }
    }
    
    private func handleOTPChange(index: Int, newValue: String) {
        
        let filtered = String(newValue.prefix(1)).filter { $0.isNumber }
        digits[index] = filtered
        
        if viewModel.showErrorMessgae && !filtered.isEmpty {
            viewModel.showErrorMessgae = false
        }
        
        if !filtered.isEmpty && index < viewModel.numberOfDigits - 1 {
            focusedField = index + 1
        }
        
        if filtered.isEmpty && index > 0 {
            focusedField = index - 1
        }
        
        if digits.joined().count == viewModel.numberOfDigits {
            focusedField = nil
        }
    }
}

#Preview {
    OtpView(strType: "Worker", contactNumber: "889898", mobileCode: "65", email: "ss@g.com")
}
