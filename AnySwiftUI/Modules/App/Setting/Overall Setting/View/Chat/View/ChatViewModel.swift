//
//  ChatViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 11/06/26.
//

import Observation

@MainActor
@Observable

class ChatViewModel {
    
    var isLoading: Bool = false
    var customError: CustomError? = nil
    
    var arrayChatList: [Res_ChatList] = []
    
    func fetchChatMessage() async throws -> Api_ChatList {
        
        var paramDict: [String : Any] = [:]
        paramDict["receiver_id"] = AppState.shared.useriD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_conversation_detail.url(),
            params: paramDict,
            responseType: Api_ChatList.self
        )
        
        return response
    }
}
