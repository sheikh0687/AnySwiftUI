//
//  TopBarViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

internal import Combine

class TopBarViewModel: ObservableObject {
    
    @Published var notificationCount: Int = 4
    @Published var chatCount: Int = 4
    @Published var attendanceRate: String = "0%"
    @Published var review: String = "0.0"
    @Published var ratingCount: Int = 2
    
    @Published var showMenu: Bool = false
    @Published var showAttendance: Bool = true
    @Published var navToMenu: Bool = false
    
    // Actions (like IBAction replacement)
    var onChatTap: (() -> Void)?
    var onNotificationTap: (() -> Void)?
    var onMenuTap: (() -> Void)?
    var onSeeAllTap: (() -> Void)?
    
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
    
    
}
