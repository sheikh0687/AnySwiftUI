//
//  ChangePasswordViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

internal import Combine

class ChangePasswordViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var customError: CustomError?
    
    @Published var password = ""
    @Published var oldPassword = ""
    @Published var confirmPassword = ""
    
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
