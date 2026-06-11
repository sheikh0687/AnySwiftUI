//
//  OutletViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/06/26.
//

import Foundation

@Observable
class OutletViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    
    var outlets: [Res_ClientOutlet] = []
    
    var outletiD: String = ""
    var outletName: String = ""
    var outletAddress: String = ""
    var outletLatitude: String = ""
    var outletLongitude: String = ""
    var outletLogoUrl: String = ""
    
    var conToAdd: Bool = false
    var conToUpdate: Bool = false
    var gotResponse: Bool = false
    var informUser: Bool = false
    
    // MARK: - API Calls
    func fetchOutlets() async throws -> Api_ClientOutlet {
        var paramDict: [String: Any] = [:]
        paramDict["client_id"] = AppState.shared.useriD
        
        print("fetchOutlets params: \(paramDict)")
        
        let response = try await Service.shared.request (
            url: Router.get_Outlet.url(),
            params: paramDict,
            responseType: Api_ClientOutlet.self
        )
        
        return response
    }
    
    func deleteOutlet() async throws -> Api_CommonModel {
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = outletiD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.delete_Outlet.url(),
            params: paramDict,
            responseType: Api_CommonModel.self
        )
        
        return response
    }
}
