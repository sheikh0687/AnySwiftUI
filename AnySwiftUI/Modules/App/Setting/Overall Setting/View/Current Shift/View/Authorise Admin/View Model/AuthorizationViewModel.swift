//
//  AuthorizationViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/06/26.
//

import Observation

@Observable
@MainActor
class AuthorizationViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    
    var strType: String = ""
    var navToAddAdmin: Bool = false
    
    var arrayAuthoriseList: [Res_AuthoriseList] = []
    
    init(strType: String) {
        self.strType = strType
    }
    
    func fetchAuthoriseList() async throws -> Api_AuthoriseList {
        var paramDict: [String : Any] = [:]
        paramDict["client_id"] = AppState.shared.useriD
        paramDict["type"] = strType
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_OutletAdmin_AuthrisedApprover.url(),
            params: paramDict,
            responseType: Api_AuthoriseList.self
        )
        
        return response
    }
    
    func deleteAdminList(adminiD: String) async throws -> Api_Basic {
        var paramDict: [String : Any] = [:]
        paramDict["id"] = adminiD
        paramDict["user_id"] = adminiD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.delete_OutletAdmin_AuthrisedApprover.url(),
            params: paramDict,
            responseType: Api_Basic.self
        )
        
        return response
    }
}

