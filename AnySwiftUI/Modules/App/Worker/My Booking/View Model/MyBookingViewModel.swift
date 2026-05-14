//
//  MyBookingViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 20/03/26.
//

import Observation

@Observable
class MyBookingViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    
    var selectedSegment = 0
    var pendingCount = 0
    var acceptCount = 0
    var workerBookingDetail: [Res_WorkerBookingDetail] = []
    
    var showWithReq: Bool = false
    var companyDetail: String = ""
    var shiftiD: String = ""
    var showDeletePop: Bool = false
    var conToBookingHour: Bool = false
    
    @MainActor
    func fetchNotificationCount() async throws -> Api_NotificationCount {

        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_notification_count.url(),
            params: paramDict,
            responseType: Api_NotificationCount.self
        )
        
        return response
    }
    
    @MainActor
    func fetchWorkerBookingDetail(strStatus: String) async throws -> Api_WorkerBookingDetail {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["status"] = strStatus
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_set_shift_book.url(),
            params: paramDict,
            responseType: Api_WorkerBookingDetail.self
        )
        
        return response
    }
    
    @MainActor
    func deleteWorkerShift() async throws -> Api_DeleteWorkerShift {
        
        var paramDict: [String : Any] = [:]
        paramDict["cart_id"] = shiftiD
        paramDict["status"] = "Cancel"
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.change_set_shift_status_worker_side.url(),
            params: paramDict,
            responseType: Api_DeleteWorkerShift.self
        )
        
        return response
    }
}
