//
//  ClientTransactionHisViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/06/26.
//

import Observation

@Observable
@MainActor
class ClientTransactionHisViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    
    var totalSpent = ""
    var totalJobs = ""
    
    var useriD: String = ""
    var requestiD: String = ""
    
    var navToAddRating: Bool = false
    var arrayTransactionHistory: [Res_ClientTransactionHistory] = []
    
    func fetchClientTransactions() async throws -> Api_ClientTransactionHistory {
        var paramDict: [String : Any] = [:]
        paramDict["client_id"] = AppState.shared.useriD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_shift_complete_by_client.url(),
            params: paramDict,
            responseType: Api_ClientTransactionHistory.self
        )
        
        return response
    }
}
