//
//  WeeklyDayName.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/05/26.
//

import Foundation

struct Api_WeeklyDayRate : Codable {
    let min_day_rate : String?
    let ticked_day_rate : String?
    let urgent_rate : String?
    let result : [Res_WeeklyDayRate]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case min_day_rate = "min_day_rate"
        case ticked_day_rate = "ticked_day_rate"
        case urgent_rate = "urgent_rate"
        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        min_day_rate = try values.decodeIfPresent(String.self, forKey: .min_day_rate)
        ticked_day_rate = try values.decodeIfPresent(String.self, forKey: .ticked_day_rate)
        urgent_rate = try values.decodeIfPresent(String.self, forKey: .urgent_rate)
        result = try values.decodeIfPresent([Res_WeeklyDayRate].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_WeeklyDayRate : Codable {
    let id : String?
    let user_id : String?
    let day_name : String?
    let rate : String?
    let check_status : String?
    let close_status : String?
    let job_type_id : String?
    let min_day_rate : String?
    let ticked_day_rate : String?
    let urgent_rate : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case day_name = "day_name"
        case rate = "rate"
        case check_status = "check_status"
        case close_status = "close_status"
        case job_type_id = "job_type_id"
        case min_day_rate = "min_day_rate"
        case ticked_day_rate = "ticked_day_rate"
        case urgent_rate = "urgent_rate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        day_name = try values.decodeIfPresent(String.self, forKey: .day_name)
        rate = try values.decodeIfPresent(String.self, forKey: .rate)
        check_status = try values.decodeIfPresent(String.self, forKey: .check_status)
        close_status = try values.decodeIfPresent(String.self, forKey: .close_status)
        job_type_id = try values.decodeIfPresent(String.self, forKey: .job_type_id)
        min_day_rate = try values.decodeIfPresent(String.self, forKey: .min_day_rate)
        ticked_day_rate = try values.decodeIfPresent(String.self, forKey: .ticked_day_rate)
        urgent_rate = try values.decodeIfPresent(String.self, forKey: .urgent_rate)
    }

}
