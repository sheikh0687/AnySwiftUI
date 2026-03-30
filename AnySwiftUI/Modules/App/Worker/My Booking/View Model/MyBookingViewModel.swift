//
//  MyBookingViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 20/03/26.
//

internal import Combine

class MyBookingViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var customError: CustomError?
    
    @Published var selectedSegment = 0
    @Published var pendingCount = 0
    @Published var acceptCount = 0
    @Published var workerBookingDetail: [Res_WorkerBookingDetail] = []
    
    @Published var showWithReq: Bool = false
    @Published var companyDetail: String = ""
    @Published var shiftiD: String = ""
    @Published var showDeletePop: Bool = false
    
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
