//
//  FinalBooking.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/04/26.
//

import Foundation

struct Api_AddFinalBooking : Codable {
    let result : Res_FinalBooking?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_FinalBooking.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_FinalBooking : Codable {
    let id : String?
    let user_id : String?
    let cart_id : String?
    let date_time : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case cart_id = "cart_id"
        case date_time = "date_time"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        cart_id = try values.decodeIfPresent(String.self, forKey: .cart_id)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}
