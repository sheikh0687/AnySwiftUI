//
//  AddAdminViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/06/26.
//

import Observation

@Observable
@MainActor
class AddAdminViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    
    var firstName: String = ""
    var lastName: String = ""
    var strType: String = ""
    
    init(strType: String) {
        self.strType = strType
    }
    
    func addAdmin() async throws -> Api_LoginResponse {
        var paramDict: [String : Any] = [:]
        paramDict["client_id"] = AppState.shared.useriD
        paramDict["first_name"] = firstName
        paramDict["last_name"] = lastName
        paramDict["type"] = strType
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.add_OutletAdmin_AuthrisedApprover.url(),
            params: paramDict,
            responseType: Api_LoginResponse.self
        )
        
        return response
    }
    
    func isValidFeilds() -> Bool {
        if firstName.isEmpty && lastName.isEmpty {
            return true
        }
        
        return false
    }
}
