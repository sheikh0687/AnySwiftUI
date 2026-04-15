//
//  OtpViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/03/26.
//

import Foundation
internal import Combine

class OtpViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var customError: CustomError?
    
    @Published var showErrorMessgae = false
    
    @Published var digits: [String] = Array(repeating: "", count: 5)
    @Published var numberOfDigits = 5
    
    @Published var isReceivedOTP: Bool = false
    @Published var otpCode: Int = 0
    @Published var optionalCode: String = ""
    
    @Published var email: String = ""
    @Published var contactNumber: String = "8982484814"
    @Published var strType: String = ""
    @Published var mobileCode: String = ""
    @Published var navContinue: Bool = false
    
    init(contactNumber: String, email: String, strType: String, mobileCode: String) {
        self.contactNumber = contactNumber
        self.email = email
        self.strType = strType
        self.mobileCode = mobileCode
        print("🔥 ViewModel INIT")
    }
    
    @MainActor
    func verifyNumber() async throws -> Api_VerifyOtp {
        isLoading = true
        customError = nil
        
        defer { isLoading = false }
        
        var param: [String : Any] = [:]
        param["email"] = email
        param["mobile"] = contactNumber
        param["type"] = strType
        param["mobile_witth_country_code"] = "\(mobileCode)\(contactNumber)"
        param["mobile_with_code"] = "\(mobileCode)\(contactNumber)"
        
        print(param)
        
        let response = try await Service.shared.request (
            url: Router.verify_number.url(),
            params: param,
            responseType: Api_VerifyOtp.self
        )
        
        return response
    }
    
    @MainActor
    func webRegister() async throws -> Api_LoginResponse {
        
        isLoading = true
        customError = nil
        
        defer { isLoading = false }
        
        let response = try await Service.shared.request (
            url: Router.signUp.url(),
            params: paramSigupDetail,
            responseType: Api_LoginResponse.self
        )

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
        AppState.shared.currencySymbol = res.currency_symbol ?? ""
    }
}
