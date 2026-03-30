//
//  LoginView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/02/26.
//

import SwiftUI
import CountryPicker

struct LoginView: View {
    
    @StateObject private var viewModel: LoginViewModel
    
    init(userType: String) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(userType: userType))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ZStack(alignment: .top) {
                VStack(alignment: .center, spacing: 40) {
                    
                    headerImg
                    
                    loginSignupState
                    
                    if viewModel.isLogin {
                        loginInputs
                    } else {
                        signupInputs
                    }
                    
                    IBLabel(text: "Forgot your email or password?", font: .semibold(.title), color: .gray)
                        .onTapGesture {
                            viewModel.resetPassword = true
                        }
                }
                .padding(.all, 24)
            }
            .onAppear {
                if !viewModel.isLogin {
                    viewModel.countryObj = Country(phoneCode: "65", isoCode: "SG")
                    
                    Task {
                        do {
                            let response = try await viewModel.countryList()
                            if response.status == "1" {
                                viewModel.selectedCountry = response.result?[0].name ?? ""
                                viewModel.selectedCountryiD = response.result?[0].id ?? ""
                            }
                        } catch {
                            viewModel.customError = .customError(message: error.localizedDescription)
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showCountryPicker) {
                CountryPickerUI(country: $viewModel.countryObj)
            }
            .navigationDestination(isPresented: $viewModel.goToVerify) {
                OtpView (
                    strType: viewModel.userType,
                    contactNumber: viewModel.mobileNumber,
                    mobileCode: viewModel.mobileCode,
                    email: viewModel.email
                )
            }
            .navigationDestination(isPresented: $viewModel.resetPassword) {
                ResetPasswordView()
            }
            .alert(item: $viewModel.customError) { error in
                Alert (
                    title: Text(appName),
                    message: Text(error.localizedDescription),
                    dismissButton: .default(Text("Ok"))
                )
            }
        }
    }
    
    private var headerImg: some View {
        Image(.logo)
            .resizable()
            .scaledToFit()
            .frame(width: 120)
    }
    
    private var loginSignupState: some View {
        HStack(alignment: .center, spacing: 24) {
            VStack(spacing: 4) {
                IBLabel(text: "Login", font: .semibold(.largeTitle), color: viewModel.isLogin ? Color.THEME : Color.LIGHTGRAY)
                Divider()
                    .frame(width: 120, height: 1)
                    .background(viewModel.isLogin ? Color.THEME : Color.LIGHTGRAY)
            }
            .onTapGesture {
                viewModel.isLogin = true
            }
            
            VStack(spacing: 4) {
                IBLabel(text: "Sign Up", font: .semibold(.largeTitle), color: viewModel.isLogin ? Color.LIGHTGRAY : Color.THEME)
                Divider()
                    .frame(width: 120, height: 1)
                    .background(viewModel.isLogin ? Color.LIGHTGRAY : Color.THEME)
            }
            .onTapGesture {
                viewModel.isLogin = false
            }
        }
    }
    
    private var loginInputs: some View {
        VStack(alignment: .leading, spacing: 32) {
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
            
            VStack(spacing: 4) {
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
            
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(0.8)
            } else {
                IBSubmitButton(buttonText: "LOGIN") {
                    if viewModel.validateLoginFields() {
                        Task {
                            do {
                                let response = try await viewModel.login()
                                
                                if response.status == "1",
                                   let user = response.result {
                                    
                                    // ⭐ Save session → app will auto navigate
                                    viewModel.saveCredentials(res: user)
                                }
                            } catch {
                                viewModel.customError = .customError(message: error.localizedDescription)
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var signupInputs: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                    IBTextField(placeholder: "First Name",
                                text: $viewModel.firstName,keyboardType:    UIKeyboardType.default)
                }
                Divider()
                    .frame(height: 0.5)
                    .background(Color.LIGHTGRAY)
            }
            
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                    IBTextField(placeholder: "Last Name",
                                text: $viewModel.lastName,keyboardType:    UIKeyboardType.default)
                }
                Divider()
                    .frame(height: 0.5)
                    .background(Color.LIGHTGRAY)
            }
            
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Image(systemName: "phone.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Button {
                        viewModel.showCountryPicker = true
                    } label: {
                        HStack(spacing: 6) {
                            if let countryObj = viewModel.countryObj {
                                IBLabel(text: "+\(countryObj.phoneCode)", font: .medium(.largeTitle), color: .black)
                            }
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                        }
                    }
                    .background(Color.white)
                    
                    IBTextField(placeholder: "Mobile", text: $viewModel.mobileNumber, keyboardType: .phonePad)
                    //                TextField("123-245-89", text: $viewModel.mobile)
                    //                    .keyboardType(.phonePad)
                    //                    .font(.customfont(.regular, fontSize: 15))
                    //                    .padding(.horizontal, 10)
                    //                    .frame(height: 44)
                }
                Divider()
                    .frame(height: 0.5)
                    .background(Color.LIGHTGRAY)
            }
            
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "envelope.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                    IBTextField(placeholder: "Email",
                                text: $viewModel.email,keyboardType:    UIKeyboardType.emailAddress)
                }
                Divider()
                    .frame(height: 0.5)
                    .background(Color.LIGHTGRAY)
            }
            
            VStack(spacing: 4) {
                Menu {
                    ForEach(viewModel.countryList, id: \.id) { country in
                        Button {
                            viewModel.selectedCountry = country.name ?? ""
                            viewModel.selectedCountryiD = country.id ?? ""
                        } label: {
                            Text(country.name ?? "")
                        }
                    }
                } label: {
                    HStack(spacing: 18) {
                        Image(systemName: "network")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Button {
                            print("Select Country")
                        } label: {
                            IBLabel(text: viewModel.selectedCountry, font: .medium(.title), color: .gray)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                }
                
                Divider()
                    .frame(height: 0.5)
                    .background(Color.LIGHTGRAY)
            }
            
            VStack(spacing: 4) {
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
            
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                    IBSecureTextField(placeholder: "Please Confirm password", text: $viewModel.confirmPassword)
                }
                Divider()
                    .frame(height: 0.5)
                    .background(Color.LIGHTGRAY)
            }
            
            HStack(spacing: 8) {
                // Checkbox
                Button {
                    viewModel.isCheck.toggle()
                } label: {
                    Image(systemName: viewModel.isCheck ? "checkmark.square.fill" : "square")
                        .font(.title3)
                        .foregroundColor(.THEME)
                }
                .buttonStyle(.plain)
                
                // Text + link
                (
                    Text("I have read the ")
                        .foregroundColor(.primary)
                    +
                    Text("Terms & Conditions ")
                        .foregroundColor(.THEME)
                        .fontWeight(.semibold)
                    +
                    Text("and accept them.")
                        .foregroundColor(.primary)
                )
                .font(.system(size: 14))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                //                router.push(to: .aboutApp(strAbout: "Terms and Conditions"))
            }
            
            IBSubmitButton(buttonText: "Sign Up") {
                viewModel.mobileCode = viewModel.countryObj?.phoneCode ?? ""
                if viewModel.validateSignupFields() {
                    viewModel.collectSignupData()
                    viewModel.goToVerify = true
                }
            }
        }
    }
}

#Preview {
    LoginView(userType: "Worker")
}
