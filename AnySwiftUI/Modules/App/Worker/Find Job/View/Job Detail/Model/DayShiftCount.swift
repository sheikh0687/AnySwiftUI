//
//  DayWiseShift.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 31/03/26.
//

import Foundation

struct Api_DayShiftCount : Codable {
    let result : [Res_DayShiftCount]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_DayShiftCount].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_DayShiftCount : Codable {
    let date : String?
    let selected_day_my_booking_status : String?
    let shift_count : Int?

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case selected_day_my_booking_status = "selected_day_my_booking_status"
        case shift_count = "shift_count"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        selected_day_my_booking_status = try values.decodeIfPresent(String.self, forKey: .selected_day_my_booking_status)
        shift_count = try values.decodeIfPresent(Int.self, forKey: .shift_count)
    }
    
    init(date: String?, selected_day_my_booking_status: String?, shift_count: Int?) {
            self.date = date
            self.selected_day_my_booking_status = selected_day_my_booking_status
            self.shift_count = shift_count
    }
}
