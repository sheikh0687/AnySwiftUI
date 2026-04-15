//
//  BreakTime.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 14/04/26.
//

import Foundation

struct Api_AddBreakTime : Codable {
    let result : Res_AddBreakTime?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_AddBreakTime.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_AddBreakTime : Codable {
    let id : String?
    let card_id : String?
    let customer_id : String?
    let shift_id : String?
    let client_id : String?
    let user_id : String?
    let day_name : String?
    let status : String?
    let cart_status : String?
    let date : String?
    let date_time : String?
    let approver_id : String?
    let approver_name : String?
    let approver_type : String?
    let shift_type : String?
    let shift_rate : String?
    let clock_in_time : String?
    let clock_out_time : String?
    let total_working_hr_time : String?
    let total_working_min_time : String?
    let total_amount : String?
    let address : String?
    let lat : String?
    let lon : String?
    let working_status : String?
    let break_time : String?
    let break_approver_id : String?
    let break_approver_name : String?
    let break_type : String?
    let late : String?
    let job_type : String?
    let job_type_id : String?
    let shift_autoapproval : String?
    let country_id : String?
    let shift_start_time : String?
    let shift_end_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case card_id = "card_id"
        case customer_id = "customer_id"
        case shift_id = "shift_id"
        case client_id = "client_id"
        case user_id = "user_id"
        case day_name = "day_name"
        case status = "status"
        case cart_status = "cart_status"
        case date = "date"
        case date_time = "date_time"
        case approver_id = "approver_id"
        case approver_name = "approver_name"
        case approver_type = "approver_type"
        case shift_type = "shift_type"
        case shift_rate = "shift_rate"
        case clock_in_time = "clock_in_time"
        case clock_out_time = "clock_out_time"
        case total_working_hr_time = "total_working_hr_time"
        case total_working_min_time = "total_working_min_time"
        case total_amount = "total_amount"
        case address = "address"
        case lat = "lat"
        case lon = "lon"
        case working_status = "working_status"
        case break_time = "break_time"
        case break_approver_id = "break_approver_id"
        case break_approver_name = "break_approver_name"
        case break_type = "break_type"
        case late = "late"
        case job_type = "job_type"
        case job_type_id = "job_type_id"
        case shift_autoapproval = "shift_autoapproval"
        case country_id = "country_id"
        case shift_start_time = "shift_start_time"
        case shift_end_time = "shift_end_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        card_id = try values.decodeIfPresent(String.self, forKey: .card_id)
        customer_id = try values.decodeIfPresent(String.self, forKey: .customer_id)
        shift_id = try values.decodeIfPresent(String.self, forKey: .shift_id)
        client_id = try values.decodeIfPresent(String.self, forKey: .client_id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        day_name = try values.decodeIfPresent(String.self, forKey: .day_name)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        cart_status = try values.decodeIfPresent(String.self, forKey: .cart_status)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
        approver_id = try values.decodeIfPresent(String.self, forKey: .approver_id)
        approver_name = try values.decodeIfPresent(String.self, forKey: .approver_name)
        approver_type = try values.decodeIfPresent(String.self, forKey: .approver_type)
        shift_type = try values.decodeIfPresent(String.self, forKey: .shift_type)
        shift_rate = try values.decodeIfPresent(String.self, forKey: .shift_rate)
        clock_in_time = try values.decodeIfPresent(String.self, forKey: .clock_in_time)
        clock_out_time = try values.decodeIfPresent(String.self, forKey: .clock_out_time)
        total_working_hr_time = try values.decodeIfPresent(String.self, forKey: .total_working_hr_time)
        total_working_min_time = try values.decodeIfPresent(String.self, forKey: .total_working_min_time)
        total_amount = try values.decodeIfPresent(String.self, forKey: .total_amount)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lon = try values.decodeIfPresent(String.self, forKey: .lon)
        working_status = try values.decodeIfPresent(String.self, forKey: .working_status)
        break_time = try values.decodeIfPresent(String.self, forKey: .break_time)
        break_approver_id = try values.decodeIfPresent(String.self, forKey: .break_approver_id)
        break_approver_name = try values.decodeIfPresent(String.self, forKey: .break_approver_name)
        break_type = try values.decodeIfPresent(String.self, forKey: .break_type)
        late = try values.decodeIfPresent(String.self, forKey: .late)
        job_type = try values.decodeIfPresent(String.self, forKey: .job_type)
        job_type_id = try values.decodeIfPresent(String.self, forKey: .job_type_id)
        shift_autoapproval = try values.decodeIfPresent(String.self, forKey: .shift_autoapproval)
        country_id = try values.decodeIfPresent(String.self, forKey: .country_id)
        shift_start_time = try values.decodeIfPresent(String.self, forKey: .shift_start_time)
        shift_end_time = try values.decodeIfPresent(String.self, forKey: .shift_end_time)
    }

}
