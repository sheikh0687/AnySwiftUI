//
//  UpdateShiftDetail.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 26/05/26.
//

import Foundation

struct Api_UpdateShiftDetails : Codable {
    let result : Res_UpdateShiftDetails?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_UpdateShiftDetails.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

}

struct Res_UpdateShiftDetails : Codable {
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
    }
}
