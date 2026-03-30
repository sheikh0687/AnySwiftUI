//
//  ResetPasswordViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

internal import Combine

class ResetPasswordViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var customError: CustomError?
    
    @Published var email: String = ""
    @Published var navContinue: Bool = false
    
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
