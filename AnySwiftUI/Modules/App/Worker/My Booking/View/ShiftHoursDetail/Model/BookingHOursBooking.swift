//
//  BookingHOursBooking.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 13/04/26.
//

import Foundation

struct Api_BookingHours : Codable {
    let result : Res_BookingHours?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_BookingHours.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_BookingHours : Codable {
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
    let set_shift : Set_shift?
    let client_details : Client_details?
    let format_date : String?

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
        case set_shift = "set_shift"
        case client_details = "client_details"
        case format_date = "format_date"
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
        set_shift = try values.decodeIfPresent(Set_shift.self, forKey: .set_shift)
        client_details = try values.decodeIfPresent(Client_details.self, forKey: .client_details)
        format_date = try values.decodeIfPresent(String.self, forKey: .format_date)
    }
}

struct Set_shift : Codable {
    let id : String?
    let user_id : String?
    let outlet_id : String?
    let job_type : String?
    let job_type_id : String?
    let worker_count : String?
    let start_time : String?
    let end_time : String?
    let total_time : String?
    let total_time_in_min : String?
    let day_name : String?
    let shiftStatus : String?
    let date : String?
    let break_type : String?
    let shift_break_time : String?
    let shift_break_time_in_min : String?
    let meals : String?
    let shift_rate : String?
    let note : String?
    let date_time : String?
    let shift_type : String?
    let current_worker_count : String?
    let address : String?
    let lat : String?
    let lon : String?
    let status : String?
    let apply_time_same_for_allworkers : String?
    let single_date : String?
    let shift_autoapproval : String?
    let country_id : String?
    let currency : String?
    let currency_symbol : String?
    let custom_shift_rate_status : String?
    let format_date : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case outlet_id = "outlet_id"
        case job_type = "job_type"
        case job_type_id = "job_type_id"
        case worker_count = "worker_count"
        case start_time = "start_time"
        case end_time = "end_time"
        case total_time = "total_time"
        case total_time_in_min = "total_time_in_min"
        case day_name = "day_name"
        case shiftStatus = "shiftStatus"
        case date = "date"
        case break_type = "break_type"
        case shift_break_time = "shift_break_time"
        case shift_break_time_in_min = "shift_break_time_in_min"
        case meals = "meals"
        case shift_rate = "shift_rate"
        case note = "note"
        case date_time = "date_time"
        case shift_type = "shift_type"
        case current_worker_count = "current_worker_count"
        case address = "address"
        case lat = "lat"
        case lon = "lon"
        case status = "status"
        case apply_time_same_for_allworkers = "apply_time_same_for_allworkers"
        case single_date = "single_date"
        case shift_autoapproval = "shift_autoapproval"
        case country_id = "country_id"
        case currency = "currency"
        case currency_symbol = "currency_symbol"
        case custom_shift_rate_status = "custom_shift_rate_status"
        case format_date = "format_date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        outlet_id = try values.decodeIfPresent(String.self, forKey: .outlet_id)
        job_type = try values.decodeIfPresent(String.self, forKey: .job_type)
        job_type_id = try values.decodeIfPresent(String.self, forKey: .job_type_id)
        worker_count = try values.decodeIfPresent(String.self, forKey: .worker_count)
        start_time = try values.decodeIfPresent(String.self, forKey: .start_time)
        end_time = try values.decodeIfPresent(String.self, forKey: .end_time)
        total_time = try values.decodeIfPresent(String.self, forKey: .total_time)
        total_time_in_min = try values.decodeIfPresent(String.self, forKey: .total_time_in_min)
        day_name = try values.decodeIfPresent(String.self, forKey: .day_name)
        shiftStatus = try values.decodeIfPresent(String.self, forKey: .shiftStatus)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        break_type = try values.decodeIfPresent(String.self, forKey: .break_type)
        shift_break_time = try values.decodeIfPresent(String.self, forKey: .shift_break_time)
        shift_break_time_in_min = try values.decodeIfPresent(String.self, forKey: .shift_break_time_in_min)
        meals = try values.decodeIfPresent(String.self, forKey: .meals)
        shift_rate = try values.decodeIfPresent(String.self, forKey: .shift_rate)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
        shift_type = try values.decodeIfPresent(String.self, forKey: .shift_type)
        current_worker_count = try values.decodeIfPresent(String.self, forKey: .current_worker_count)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lon = try values.decodeIfPresent(String.self, forKey: .lon)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        apply_time_same_for_allworkers = try values.decodeIfPresent(String.self, forKey: .apply_time_same_for_allworkers)
        single_date = try values.decodeIfPresent(String.self, forKey: .single_date)
        shift_autoapproval = try values.decodeIfPresent(String.self, forKey: .shift_autoapproval)
        country_id = try values.decodeIfPresent(String.self, forKey: .country_id)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        currency_symbol = try values.decodeIfPresent(String.self, forKey: .currency_symbol)
        custom_shift_rate_status = try values.decodeIfPresent(String.self, forKey: .custom_shift_rate_status)
        format_date = try values.decodeIfPresent(String.self, forKey: .format_date)
    }

}
