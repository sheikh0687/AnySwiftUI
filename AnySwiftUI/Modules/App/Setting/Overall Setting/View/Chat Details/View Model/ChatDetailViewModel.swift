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
    var isSending: Bool = false
    var errorMessage: String? = nil

    var receiveriD: String = ""
    var requestiD: String = ""
    var chatReason: String = ""

    var chatMessage: String = ""
    var messages: [ChatMessageUI] = []

    var canSend: Bool {
        !chatMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSending
    }

    func fetchChatDetail(showLoader: Bool = true) async {
        if showLoader { isLoading = true }
        defer { isLoading = false }

        var paramDict: [String: Any] = [:]
        paramDict["receiver_id"] = AppState.shared.useriD
        paramDict["sender_id"] = receiveriD
        paramDict["request_id"] = requestiD
        paramDict["type"] = "Normal"

        print(paramDict)
        
        do {
            let response = try await Service.shared.request (
                url: Router.get_chat_detail.url(),
                params: paramDict,
                responseType: Api_ChatDetailsList.self
            )

            if response.status == "1" {
                let currentUserId = AppState.shared.useriD
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                self.messages = (response.result ?? []).enumerated().map { index, dict in

                    let senderId = (dict.sender_id ?? "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)

                    let isCurrentUser = !senderId.isEmpty
                        && !currentUserId.isEmpty
                        && senderId == currentUserId

                    let isSupport = dict.type == "Support"

                    let seen: String
                    if isSupport {
                        seen = dict.admin_status == "SEEN" ? "Read" : "Sent"
                    } else {
                        seen = dict.status == "SEEN" ? "Read" : "Sent"
                    }

                    let avatarURL: String?
                    if isCurrentUser {
                        avatarURL = dict.sender_detail?.sender_image
                    } else {
                        avatarURL = dict.sender_detail?.sender_image
                    }

                    return ChatMessageUI (
                        id: dict.id ?? "\(index)-\(dict.date_time ?? "")",
                        message: dict.chat_message ?? "",
                        dateTime: dict.date_time ?? "",
                        isCurrentUser: isCurrentUser,
                        avatarURL: avatarURL,
                        isSupport: isSupport,
                        supportName: dict.support_name,
                        seenStatus: seen
                    )
                }
            } else {
                errorMessage = response.message ?? "Failed to load chat"
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }

    func sendMessage() async {
        let trimmed = chatMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isSending else { return }

        isSending = true
        defer { isSending = false }

        // Optimistically clear input for a snappier feel
        let messageToSend = trimmed
        chatMessage = ""

        var paramDict: [String: Any] = [:]
        paramDict["sender_id"] = AppState.shared.useriD
        paramDict["receiver_id"] = receiveriD
        paramDict["chat_message"] = messageToSend
        paramDict["timezone"] = TimeZone.current.identifier
        paramDict["type"] = "Normal"
        paramDict["request_id"] = requestiD
        paramDict["date_time"] = Date()
        paramDict["sender_type"] = AppState.shared.userType

        print(paramDict)
        
        do {
            let response = try await Service.shared.request (
                url: Router.insert_chat.url(),
                params: paramDict,
                responseType: Api_InsertChat.self
            )

            if response.status == "1" {
                await fetchChatDetail(showLoader: false)
            } else {
                // Restore input if server rejected it
                chatMessage = messageToSend
                errorMessage = response.message ?? "Failed to send message"
            }
        } catch {
            chatMessage = messageToSend
            errorMessage = error.localizedDescription
        }
    }
}
