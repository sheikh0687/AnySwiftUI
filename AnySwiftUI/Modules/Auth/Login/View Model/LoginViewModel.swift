//
//  LoginViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/02/26.
//

import Foundation
internal import Combine
import CountryPicker

class LoginViewModel: ObservableObject {
    
    @Published var userType: String = ""
    
    @Published var isLogin: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var mobileNumber: String = ""
    @Published var mobileCode: String = ""
    
    @Published var showCountryPicker = false
    @Published var countryObj: Country?
    
    @Published var isCheck = false
    @Published var goToVerify: Bool = false
    @Published var resetPassword: Bool = false
    
    @Published var loginResponse: Api_LoginResponse?
    @Published var countryList: [Res_CountryList] = []
    @Published var selectedCountry: String = "Select Country"
    @Published var selectedCountryiD: String = ""
    
    init(userType: String) {
        self.userType = userType
    }
    
    @Published var isLoading: Bool = false
    @Published var customError: CustomError? = nil
    
    @MainActor
    func login() async throws -> Api_LoginResponse {
        
        isLoading = true
        customError = nil
        
        defer { isLoading = false }
        
        var param: [String : Any] = [:]
        param["email"] = email
        param["password"] = password
        param["type"] = userType
        
        print(param)
        
        let response = try await Service.shared.request (
            url: Router.logIn.url(),
            params: param,
            responseType: Api_LoginResponse.self
        )
        
        self.loginResponse = response
        return response
    }
    
    func saveCredentials(res: Res_LoginResponse) {
        AppState.shared.isLoggedIn = true
        AppState.shared.useriD = res.id ?? ""
        AppState.shared.userFirstName = res.first_name ?? ""
        AppState.shared.userLastName = res.last_name ?? ""
        AppState.shared.emailiD = res.email ?? ""
        AppState.shared.userMobile = res.mobile ?? ""
        AppState.shared.ios_RegisterediD = res.ios_register_id ?? ""
        AppState.shared.userType = res.type ?? ""
        AppState.shared.countryiD = res.country_id ?? ""
        AppState.shared.jobTypeiD = res.job_type_id ?? ""
    }
    
    //    func saveCredentials(res: Res_LoginResponse) {
    //        let defaults = UserDefaults.standard
    //        
    //        defaults.set(true, forKey: AppStorageKey.isLoggedIn.rawValue)
    //        defaults.set(res.id ?? "", forKey: AppStorageKey.useriD.rawValue)
    //        defaults.set(res.first_name ?? "", forKey: AppStorageKey.userFirstName.rawValue)
    //        defaults.set(res.last_name ?? "", forKey: AppStorageKey.userLastName.rawValue)
    //        defaults.set(res.email ?? "", forKey: AppStorageKey.userEmail.rawValue)
    //        defaults.set(res.mobile ?? "", forKey: AppStorageKey.userMobile.rawValue)
    //        defaults.set(res.ios_register_id ?? "", forKey: AppStorageKey.ios_RegisterediD.rawValue)
    //        defaults.set(res.type ?? "", forKey: AppStorageKey.userType.rawValue)
    //        defaults.set(res.country_id ?? "", forKey: AppStorageKey.countryiD.rawValue)
    //        
    //        // ⭐ update UI STATE LAST
    //        let appState = AppState.shared
    //        appState.isLoggedIn = true
    //        appState.useriD = res.id ?? ""
    //        appState.userFirstName = res.first_name ?? ""
    //        appState.userLastName = res.last_name ?? ""
    //        appState.emailiD = res.email ?? ""
    //        appState.userMobile = res.mobile ?? ""
    //        appState.ios_RegisterediD = res.ios_register_id ?? ""
    //        appState.userType = res.type ?? ""
    //        appState.countryiD = res.country_id ?? ""
    //    }
    
    @MainActor
    func countryList() async throws -> Api_CountryList {
        
        isLoading = true
        customError = nil
        
        defer { isLoading = false }
        
        let response = try await Service.shared.request (
            url: Router.get_country_list.url(),
            params: [:],
            responseType: Api_CountryList.self
        )
        
        self.countryList = response.result ?? []
        return response
    }
    
    func collectSignupData() {
        paramSigupDetail["email"]     =   email
        paramSigupDetail["first_name"]  =   firstName
        paramSigupDetail["last_name"]  =   lastName
        paramSigupDetail["password"]  =   password
        paramSigupDetail["lat"]   =        ""
        paramSigupDetail["lon"]  =        ""
        paramSigupDetail["type"]     =   userType
        paramSigupDetail["mobile"]     =   mobileNumber
        paramSigupDetail["mobile_witth_country_code"]     =  "\(mobileCode)\(mobileNumber)"
        paramSigupDetail["mobile_with_code"]     =  "\(mobileCode)\(mobileNumber)"
        paramSigupDetail["ios_register_id"]  =   AppState.shared.ios_RegisterediD
        paramSigupDetail["country_name"] = selectedCountry
        paramSigupDetail["country_id"] = selectedCountryiD
        
        paramSigupDetail["register_id"]  =   emptyString
        paramSigupDetail["about_us"]  =   "1"
        paramSigupDetail["pay_now_number"] = emptyString
        paramSigupDetail["local_bank_number"] = emptyString
        paramSigupDetail["bank_name"] = emptyString
        
        print(paramSigupDetail)
    }
    
    func validateSignupFields() -> Bool {
        if firstName.isEmpty {
            customError = .customError(message: "Please enter a first name.")
            return false
        } else if lastName.isEmpty {
            customError = .customError(message: "Please enter a last name.")
            return false
        } else if !Utility.isValidEmail(email) {
            customError = .customError(message: "Please enter your valid email address.")
            return false
        } else if !Utility.isValidMobileNumber(mobileNumber) {
            customError = .customError(message: "Please enter your valid mobile number.")
            return false
        } else if password.isEmpty {
            customError = .customError(message: "Please enter the password.")
            return false
        } else if confirmPassword.isEmpty {
            customError = .customError(message: "Please confirm the valid password.")
            return false
        } else if password != confirmPassword {
            customError = .customError(message: "Password mismatch. Please confirm the same password.")
            return false
        } else if isCheck == false {
            customError = .customError(message: "Please Read The Terms and Condition")
            return false
        }
        return true
    }
    
    func validateLoginFields() -> Bool {
        if !Utility.isValidEmail(email) {
            customError = .customError(message: "Please enter your valid email address.")
            return false
        } else if password.isEmpty {
            customError = .customError(message: "Please enter the password.")
            return false
        }
        return true
    }
}
