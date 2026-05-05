//
//  WeeklyShift.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 20/04/26.
//

import Foundation

struct Api_WeeklyShift : Codable {
    let result : [Res_WeeklyShift]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_WeeklyShift].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_WeeklyShift : Codable {
    let id : String?
    let name : String?
    let document_name : String?
    let document_requied : String?
    let rate_india : String?
    let min_day_rate_india : String?
    let ticked_day_rate_india : String?
    let urgent_rate_india : String?
    let rate_singapore : String?
    let min_day_rate_singapore : String?
    let ticked_day_rate_singapore : String?
    let urgent_rate_singapore : String?
    let rate_philippines : String?
    let min_day_rate_philippines : String?
    let ticked_day_rate_philippines : String?
    let urgent_rate_philippines : String?
    let rate_malaysia : String?
    let min_day_rate_malaysia : String?
    let ticked_day_rate_malaysia : String?
    let urgent_rate_malaysia : String?
    let remove_status : String?
    let dayWiseCount : [DayWiseCount]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case document_name = "document_name"
        case document_requied = "document_requied"
        case rate_india = "rate_india"
        case min_day_rate_india = "min_day_rate_india"
        case ticked_day_rate_india = "ticked_day_rate_india"
        case urgent_rate_india = "urgent_rate_india"
        case rate_singapore = "rate_singapore"
        case min_day_rate_singapore = "min_day_rate_singapore"
        case ticked_day_rate_singapore = "ticked_day_rate_singapore"
        case urgent_rate_singapore = "urgent_rate_singapore"
        case rate_philippines = "rate_philippines"
        case min_day_rate_philippines = "min_day_rate_philippines"
        case ticked_day_rate_philippines = "ticked_day_rate_philippines"
        case urgent_rate_philippines = "urgent_rate_philippines"
        case rate_malaysia = "rate_malaysia"
        case min_day_rate_malaysia = "min_day_rate_malaysia"
        case ticked_day_rate_malaysia = "ticked_day_rate_malaysia"
        case urgent_rate_malaysia = "urgent_rate_malaysia"
        case remove_status = "remove_status"
        case dayWiseCount = "DayWiseCount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        document_name = try values.decodeIfPresent(String.self, forKey: .document_name)
        document_requied = try values.decodeIfPresent(String.self, forKey: .document_requied)
        rate_india = try values.decodeIfPresent(String.self, forKey: .rate_india)
        min_day_rate_india = try values.decodeIfPresent(String.self, forKey: .min_day_rate_india)
        ticked_day_rate_india = try values.decodeIfPresent(String.self, forKey: .ticked_day_rate_india)
        urgent_rate_india = try values.decodeIfPresent(String.self, forKey: .urgent_rate_india)
        rate_singapore = try values.decodeIfPresent(String.self, forKey: .rate_singapore)
        min_day_rate_singapore = try values.decodeIfPresent(String.self, forKey: .min_day_rate_singapore)
        ticked_day_rate_singapore = try values.decodeIfPresent(String.self, forKey: .ticked_day_rate_singapore)
        urgent_rate_singapore = try values.decodeIfPresent(String.self, forKey: .urgent_rate_singapore)
        rate_philippines = try values.decodeIfPresent(String.self, forKey: .rate_philippines)
        min_day_rate_philippines = try values.decodeIfPresent(String.self, forKey: .min_day_rate_philippines)
        ticked_day_rate_philippines = try values.decodeIfPresent(String.self, forKey: .ticked_day_rate_philippines)
        urgent_rate_philippines = try values.decodeIfPresent(String.self, forKey: .urgent_rate_philippines)
        rate_malaysia = try values.decodeIfPresent(String.self, forKey: .rate_malaysia)
        min_day_rate_malaysia = try values.decodeIfPresent(String.self, forKey: .min_day_rate_malaysia)
        ticked_day_rate_malaysia = try values.decodeIfPresent(String.self, forKey: .ticked_day_rate_malaysia)
        urgent_rate_malaysia = try values.decodeIfPresent(String.self, forKey: .urgent_rate_malaysia)
        remove_status = try values.decodeIfPresent(String.self, forKey: .remove_status)
        dayWiseCount = try values.decodeIfPresent([DayWiseCount].self, forKey: .dayWiseCount)
    }
}

struct DayWiseCount : Codable {
    let id : String?
    let name : String?
    let job_type_id : String?
    let total_shift_count : Int?
    let booking_status : String?
    let pending_shift_count : Int?
    let accept_shift_count : Int?
    let week_date : String?
    let format_date : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case job_type_id = "job_type_id"
        case total_shift_count = "total_shift_count"
        case booking_status = "booking_status"
        case pending_shift_count = "pending_shift_count"
        case accept_shift_count = "accept_shift_count"
        case week_date = "week_date"
        case format_date = "format_date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        job_type_id = try values.decodeIfPresent(String.self, forKey: .job_type_id)
        total_shift_count = try values.decodeIfPresent(Int.self, forKey: .total_shift_count)
        booking_status = try values.decodeIfPresent(String.self, forKey: .booking_status)
        pending_shift_count = try values.decodeIfPresent(Int.self, forKey: .pending_shift_count)
        accept_shift_count = try values.decodeIfPresent(Int.self, forKey: .accept_shift_count)
        week_date = try values.decodeIfPresent(String.self, forKey: .week_date)
        format_date = try values.decodeIfPresent(String.self, forKey: .format_date)
    }

}
