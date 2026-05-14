//
//  UpdatePasswordViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

import Observation

@Observable
class UpdatePasswordViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    var password: String = ""
    var confirmPassword: String = ""
    
    @MainActor
    func resetPassword() async throws -> Api_Basic {
        isLoading = false
        customError = nil
        
        defer {
            isLoading = false
        }
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["password"] = password
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.reset_password.url(),
            params: paramDict,
            responseType: Api_Basic.self
        )
        
        return response
    }
}
