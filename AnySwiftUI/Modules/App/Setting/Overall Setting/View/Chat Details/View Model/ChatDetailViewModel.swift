//
//  ChatDetailViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 11/06/26.
//

import Observation

@MainActor
@Observable
class ChatDetailViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError? = nil
    
    var receiveriD: String = ""
    var requestiD: String = ""
    
    var chatMessage: String = ""
    
    func fetchChatDetail() async throws -> Api_ChatDetailsList {
        
        var paramDict: [String : Any] = [:]
        paramDict["receiver_id"] = AppState.shared.useriD
        paramDict["sender_id"] = receiveriD
        paramDict["request_id"] = requestiD
        paramDict["type"] = "Normal"
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_chat_detail.url(),
            params: paramDict,
            responseType: Api_ChatDetailsList.self
        )
        
        return response
    }
    
    func insertChat() async throws -> Api_InsertChat {
        
        var paramDict: [String : Any] = [:]
        paramDict["sender_id"] = AppState.shared.useriD
        paramDict["receiver_id"] = receiveriD
        paramDict["chat_message"] = chatMessage
        paramDict["timezone"] = ""
        paramDict["type"] = "Normal"
        paramDict["request_id"] = requestiD
        paramDict["date_time"] = Date()
        paramDict["sender_type"] = AppState.shared.userType
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.insert_chat.url(),
            params: paramDict,
            responseType: Api_InsertChat.self
        )
        
        return response
    }
}
