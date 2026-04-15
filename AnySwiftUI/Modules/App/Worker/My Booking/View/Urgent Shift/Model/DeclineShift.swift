//
//  DeclineShift.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 15/04/26.
//

import Foundation

struct Api_DeclineShift : Codable {
    let result : Res_DeclineShit?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_DeclineShit.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_DeclineShit : Codable {
    let id : String?
    let shift_id : String?
    let worker_id : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case shift_id = "shift_id"
        case worker_id = "worker_id"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        shift_id = try values.decodeIfPresent(String.self, forKey: .shift_id)
        worker_id = try values.decodeIfPresent(String.self, forKey: .worker_id)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }

}
