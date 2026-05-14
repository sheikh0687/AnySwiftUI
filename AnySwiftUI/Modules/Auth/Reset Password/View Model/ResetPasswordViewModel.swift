//
//  ResetPasswordViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

import Observation

@Observable
class ResetPasswordViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    var email: String = ""
    var navContinue: Bool = false
    
    @MainActor
    func webResetPassword() async throws -> Api_ResetPassword {
        isLoading = true
        customError = nil
        
        defer { isLoading = false }
        
        var paramDict: [String : Any] = [:]
        paramDict["email"] = email
        
        print(paramDict)
         
        let response = try await Service.shared.request (
            url: Router.forgot_password.url(),
            params: paramDict,
            responseType: Api_ResetPassword.self
        )
        
        return response
    }
}
