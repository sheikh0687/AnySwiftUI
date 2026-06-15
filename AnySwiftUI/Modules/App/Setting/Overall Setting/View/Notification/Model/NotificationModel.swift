//
//  NotificationModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 12/06/26.
//

import Foundation

struct Api_NotificationList : Codable {
    let result : [Res_NotificationList]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_NotificationList].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_NotificationList : Codable {
    let id : String?
    let user_id : String?
    let request_id : String?
    let title : String?
    let message : String?
    let type : String?
    let notification_type : String?
    let seen_status : String?
    let code : String?
    let update_field : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case request_id = "request_id"
        case title = "title"
        case message = "message"
        case type = "type"
        case notification_type = "notification_type"
        case seen_status = "seen_status"
        case code = "code"
        case update_field = "update_field"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        request_id = try values.decodeIfPresent(String.self, forKey: .request_id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        notification_type = try values.decodeIfPresent(String.self, forKey: .notification_type)
        seen_status = try values.decodeIfPresent(String.self, forKey: .seen_status)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        update_field = try values.decodeIfPresent(String.self, forKey: .update_field)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }

}
