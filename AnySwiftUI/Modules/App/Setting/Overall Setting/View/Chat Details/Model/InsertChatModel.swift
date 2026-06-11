//
//  InsertChatModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 11/06/26.
//

import Foundation

struct Api_InsertChat : Codable {
    let result : Res_InsertChatList?
    let status : String?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_InsertChatList.self, forKey: .result)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}

struct Res_InsertChatList : Codable {
    let id : String?
    let sender_id : String?
    let receiver_id : String?
    let chat_message : String?
    let request_id : String?
    let chat_image : String?
    let clear_chat : String?
    let type : String?
    let timezone : String?
    let date_time : String?
    let status : String?
    let is_read : String?
    let admin_status : String?
    let support_name : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case sender_id = "sender_id"
        case receiver_id = "receiver_id"
        case chat_message = "chat_message"
        case request_id = "request_id"
        case chat_image = "chat_image"
        case clear_chat = "clear_chat"
        case type = "type"
        case timezone = "timezone"
        case date_time = "date_time"
        case status = "status"
        case is_read = "is_read"
        case admin_status = "admin_status"
        case support_name = "support_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        sender_id = try values.decodeIfPresent(String.self, forKey: .sender_id)
        receiver_id = try values.decodeIfPresent(String.self, forKey: .receiver_id)
        chat_message = try values.decodeIfPresent(String.self, forKey: .chat_message)
        request_id = try values.decodeIfPresent(String.self, forKey: .request_id)
        chat_image = try values.decodeIfPresent(String.self, forKey: .chat_image)
        clear_chat = try values.decodeIfPresent(String.self, forKey: .clear_chat)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        is_read = try values.decodeIfPresent(String.self, forKey: .is_read)
        admin_status = try values.decodeIfPresent(String.self, forKey: .admin_status)
        support_name = try values.decodeIfPresent(String.self, forKey: .support_name)
    }

}
