//
//  UrgentShiftViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 11/05/26.
//

import Observation

@Observable
@MainActor
class UrgentShiftViewModel {
    
    var isLoading = false
    var customError: CustomError?
    
    var urgentShift: [Res_FetchUrgentShift] = []
    
    var addUrgentShift: Bool = false
    var updateShift: Bool = false
    var shiftiD: String = ""
    var outletName: String = ""
    
    func fetchUrgentShift() async throws -> Api_FetchUrgentShift {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["shift_type"] = "Broadcast"
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_my_set_shift.url(),
            params: paramDict,
            responseType: Api_FetchUrgentShift.self
        )
        
        return response
    }
    
    func deleteUrgentShift(shiftiD: String) async throws -> Api_CommonModel {
        
        var paramDict: [String : Any] = [:]
        paramDict["id"] = shiftiD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.delete_my_shifts.url(),
            params: paramDict,
            responseType: Api_CommonModel.self
        )
        
        return response
    }
}
