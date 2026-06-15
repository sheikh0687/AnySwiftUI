//
//  NotificationViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 12/06/26.
//

import Observation

@MainActor
@Observable
class NotificationViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError?
    
    var arrayNotificationList: [Res_NotificationList] = []
    
    func fetchNotificationList() async throws -> Api_NotificationList {
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_notification_list.url(),
            params: paramDict,
            responseType: Api_NotificationList.self
        )
        
        return response
    }
}


