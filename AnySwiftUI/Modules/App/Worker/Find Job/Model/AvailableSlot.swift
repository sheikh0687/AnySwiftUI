//
//  AvailableSlot.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 27/03/26.
//

import Foundation

struct Api_JobAvailableSlot : Codable {
    let result : [Res_AvailableSlot]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_AvailableSlot].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_AvailableSlot : Codable {
    let date : String?
    let day : String?
    let dayname : String?

    enum CodingKeys: String, CodingKey {

        case date = "date"
        case day = "day"
        case dayname = "dayname"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        day = try values.decodeIfPresent(String.self, forKey: .day)
        dayname = try values.decodeIfPresent(String.self, forKey: .dayname)
    }

}
