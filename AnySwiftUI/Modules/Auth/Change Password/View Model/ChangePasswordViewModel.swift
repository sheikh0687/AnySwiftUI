//
//  ChangePasswordViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

import Observation

@Observable
class ChangePasswordViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    var password = ""
    var oldPassword = ""
    var confirmPassword = ""
    
    @MainActor
    func webChangePassword() async throws -> Api_Basic {
        isLoading = true
        customError = nil
        
        defer {
            isLoading = false
        }
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["password"] = password
        paramDict["old_password"] = oldPassword
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.change_password.url(),
            params: paramDict,
            responseType: Api_Basic.self
        )
        
        return response
    }
}
