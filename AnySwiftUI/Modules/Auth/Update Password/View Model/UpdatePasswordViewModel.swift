//
//  UpdatePasswordViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

internal import Combine

class UpdatePasswordViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var customError: CustomError?
    
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
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
