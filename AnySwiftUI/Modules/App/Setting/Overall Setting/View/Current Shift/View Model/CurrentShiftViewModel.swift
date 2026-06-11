//
//  CurrentShiftViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 26/05/26.
//

import Observation

@Observable
class CurrentShiftViewModel {
    
    var shiftList: [Res_CurrentShift] = []
    var isLoading = false
    var isCloseAllBookings = false
    var isAutoApproval = false
    var errorMessage: String?
    
    @MainActor
    func getShiftList() async throws -> Api_CurrentShift {
        isLoading = true
        defer { isLoading = false }
 
        var params: [String: Any] = [:]
        params["user_id"]    = AppState.shared.useriD
        params["shift_type"] = "Normal"
 
        print(params)
                
        let response = try await Service.shared.request (
            url: Router.get_my_set_shift.url(),
            params: params,
            responseType: Api_CurrentShift.self
        )
        
        return response
    }
    
    @MainActor
    func getProfile() async throws -> Api_LoginResponse {
        var params: [String: Any] = [:]
        params["user_id"]   = AppState.shared.useriD
        params["device_id"] = AppState.shared.ios_RegisterediD
         
        let response = try await Service.shared.request (
            url: Router.get_profile.url(),
            params: params,
            responseType: Api_LoginResponse.self
        )
        
        return response
    }
    
    @MainActor
    func updateBookingStatus(close: Bool) async throws -> Api_LoginResponse {
        var params: [String: Any] = [:]
        params["user_id"]        = AppState.shared.useriD
        params["booking_status"] = (close ? "Close" : "Open") as AnyObject
 
        print(params)
                
        let response = try await Service.shared.request (
            url: Router.update_booking_status_profile.url(),
            params: params,
            responseType: Api_LoginResponse.self
        )
        
        if response.status == "1" {
            Task {
                try await getProfile()
            }
        }
        
        return response
    }
    
    @MainActor
    func updateAutoApproval(enabled: Bool) async throws -> Api_LoginResponse {
        var params: [String: Any] = [:]
        params["user_id"]            = AppState.shared.useriD
        params["shift_autoapproval"] = (enabled ? "Yes" : "No") as AnyObject
 
        print(params)
                
        let response = try await Service.shared.request (
            url: Router.set_shift_autoapproval_status.url(),
            params: params,
            responseType: Api_LoginResponse.self
        )
        
        if response.status == "1" {
            Task {
                try await getProfile()
            }
        } else {
            errorMessage = response.message ?? ""
        }
        return response
    }

    @MainActor
    func deleteShift(id: String) async throws -> Api_Basic {
        var params: [String: AnyObject] = [:]
        params["id"] = id as AnyObject
 
        print(params)
                
        let response = try await Service.shared.request (
            url: Router.delete_my_shifts.url(),
            params: params,
            responseType: Api_Basic.self
        )
        
        if response.status == "1" {
            Task {
                try await getShiftList()
            }
        }
        return response
    }
}

