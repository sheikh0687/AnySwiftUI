//
//  BookingCartValue.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/04/26.
//

import Foundation

struct Api_BookingCart : Codable {
    let cart_id : Int?
    let result : String?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case cart_id = "cart_id"
        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cart_id = try values.decodeIfPresent(Int.self, forKey: .cart_id)
        result = try values.decodeIfPresent(String.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}
