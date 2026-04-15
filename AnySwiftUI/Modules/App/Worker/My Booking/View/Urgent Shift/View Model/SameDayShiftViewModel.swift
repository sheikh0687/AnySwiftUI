//
//  SameDayShiftViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 15/04/26.
//

internal import Combine

class SameDayShiftViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var customError: CustomError?
    
    @Published var arrayOfSameDayShift: [Res_UrgentShift] = []
    @Published var sameDayShift: Res_UrgentShift?
    @Published var activeAlert: SameDayAlert?
    
    @MainActor
    func fetchSameDayShift() async throws -> Api_UrgentShift {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_broadcast_shift.url(),
            params: paramDict,
            responseType: Api_UrgentShift.self
        )
        
        return response
    }
    
    @MainActor
    func acceptShift(_ booking: Res_UrgentShift) async throws -> Api_CommonModel {
        
        var paramDict: [String: Any] = [:]
        paramDict["user_id"]   = AppState.shared.useriD
        paramDict["client_id"] = booking.outlet_id ?? ""
        paramDict["shift_id"]  = booking.id ?? ""
        paramDict["day_name"]  = booking.day_name ?? ""
        paramDict["date"]      = booking.date ?? ""
        
        print(paramDict)
       
        return try await Service.shared.request (
            url: Router.add_to_set_shift_cart_broadcast.url(),
            params: paramDict,
            responseType: Api_CommonModel.self
        )
    }
 
    // MARK: Decline (reject by worker)
 
    @MainActor
    func declineShift(shiftId: String) async throws -> Api_DeclineShift {
       
        var paramDict: [String: Any] = [:]
        paramDict["worker_id"] = AppState.shared.useriD
        paramDict["shift_id"]  = shiftId
        
        print(paramDict)
     
        return try await Service.shared.request (
            url: Router.shift_rejected_by_worker.url(),
            params: paramDict,
            responseType: Api_DeclineShift.self
        )
    }
}

