//
//  SpecificDateRate.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/06/26.
//

import Foundation

struct Api_SpecificDateRate : Codable {
    let result : [Res_SpecificDateRate]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_SpecificDateRate].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_SpecificDateRate : Codable {
    let id : String?
    let user_id : String?
    let day_name : String?
    let date : String?
    let rate : String?
    let check_status : String?
    let close_status : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case day_name = "day_name"
        case date = "date"
        case rate = "rate"
        case check_status = "check_status"
        case close_status = "close_status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        day_name = try values.decodeIfPresent(String.self, forKey: .day_name)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        rate = try values.decodeIfPresent(String.self, forKey: .rate)
        check_status = try values.decodeIfPresent(String.self, forKey: .check_status)
        close_status = try values.decodeIfPresent(String.self, forKey: .close_status)
    }

}

struct SpecificDateRate: Identifiable {
    let id = UUID()
    let dateRateId: String
    let date: String
    var rate: Int
}
