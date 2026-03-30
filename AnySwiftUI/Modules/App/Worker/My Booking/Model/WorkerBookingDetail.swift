//
//  WorkerBookingDetail.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 26/03/26.
//

import Foundation

struct Api_WorkerBookingDetail : Codable {
    let pending_shift_count : Int?
    let accept_shift_count : Int?
    let result : [Res_WorkerBookingDetail]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case pending_shift_count = "pending_shift_count"
        case accept_shift_count = "accept_shift_count"
        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pending_shift_count = try values.decodeIfPresent(Int.self, forKey: .pending_shift_count)
        accept_shift_count = try values.decodeIfPresent(Int.self, forKey: .accept_shift_count)
        result = try values.decodeIfPresent([Res_WorkerBookingDetail].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_WorkerBookingDetail : Codable {
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
    let set_shift_details : Set_shift_details?
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
        case set_shift_details = "set_shift_details"
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
        set_shift_details = try values.decodeIfPresent(Set_shift_details.self, forKey: .set_shift_details)
        client_details = try values.decodeIfPresent(Client_details.self, forKey: .client_details)
        format_date = try values.decodeIfPresent(String.self, forKey: .format_date)
    }
}

struct Set_shift_details : Codable {
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

struct Client_details : Codable {
    let id : String?
    let customer_id : String?
    let card_id : String?
    let live_customer_id : String?
    let client_id : String?
    let first_name : String?
    let last_name : String?
    let mobile : String?
    let mobile_with_code : String?
    let email : String?
    let password : String?
    let country_id : String?
    let country_name : String?
    let state_id : String?
    let state_name : String?
    let city_id : String?
    let city_name : String?
    let image : String?
    let type : String?
    let social_id : String?
    let lat : String?
    let lon : String?
    let address : String?
    let addresstype : String?
    let address_id : String?
    let gender : String?
    let gender_type : String?
    let wallet : String?
    let register_id : String?
    let ios_register_id : String?
    let status : String?
    let approve_status : String?
    let available_status : String?
    let code : String?
    let new_code : String?
    let date_time : String?
    let remove_status : String?
    let pay_now_number : String?
    let local_bank_number : String?
    let bank_name : String?
    let nrc_document : String?
    let business_logo : String?
    let business_name : String?
    let business_address : String?
    let une_register_number : String?
    let min_day_rate : String?
    let ticked_day_rate : String?
    let urgent_rate : String?
    let booking_status : String?
    let note : String?
    let job_document : String?
    let job_type_id : String?
    let job_type_name : String?
    let request_payment_type : String?
    let shift_autoapproval : String?
    let currency : String?
    let currency_symbol : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case customer_id = "customer_id"
        case card_id = "card_id"
        case live_customer_id = "live_customer_id"
        case client_id = "client_id"
        case first_name = "first_name"
        case last_name = "last_name"
        case mobile = "mobile"
        case mobile_with_code = "mobile_with_code"
        case email = "email"
        case password = "password"
        case country_id = "country_id"
        case country_name = "country_name"
        case state_id = "state_id"
        case state_name = "state_name"
        case city_id = "city_id"
        case city_name = "city_name"
        case image = "image"
        case type = "type"
        case social_id = "social_id"
        case lat = "lat"
        case lon = "lon"
        case address = "address"
        case addresstype = "addresstype"
        case address_id = "address_id"
        case gender = "gender"
        case gender_type = "gender_type"
        case wallet = "wallet"
        case register_id = "register_id"
        case ios_register_id = "ios_register_id"
        case status = "status"
        case approve_status = "approve_status"
        case available_status = "available_status"
        case code = "code"
        case new_code = "new_code"
        case date_time = "date_time"
        case remove_status = "remove_status"
        case pay_now_number = "pay_now_number"
        case local_bank_number = "local_bank_number"
        case bank_name = "bank_name"
        case nrc_document = "nrc_document"
        case business_logo = "business_logo"
        case business_name = "business_name"
        case business_address = "business_address"
        case une_register_number = "une_register_number"
        case min_day_rate = "min_day_rate"
        case ticked_day_rate = "ticked_day_rate"
        case urgent_rate = "urgent_rate"
        case booking_status = "booking_status"
        case note = "note"
        case job_document = "job_document"
        case job_type_id = "job_type_id"
        case job_type_name = "job_type_name"
        case request_payment_type = "request_payment_type"
        case shift_autoapproval = "shift_autoapproval"
        case currency = "currency"
        case currency_symbol = "currency_symbol"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        customer_id = try values.decodeIfPresent(String.self, forKey: .customer_id)
        card_id = try values.decodeIfPresent(String.self, forKey: .card_id)
        live_customer_id = try values.decodeIfPresent(String.self, forKey: .live_customer_id)
        client_id = try values.decodeIfPresent(String.self, forKey: .client_id)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        mobile_with_code = try values.decodeIfPresent(String.self, forKey: .mobile_with_code)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        country_id = try values.decodeIfPresent(String.self, forKey: .country_id)
        country_name = try values.decodeIfPresent(String.self, forKey: .country_name)
        state_id = try values.decodeIfPresent(String.self, forKey: .state_id)
        state_name = try values.decodeIfPresent(String.self, forKey: .state_name)
        city_id = try values.decodeIfPresent(String.self, forKey: .city_id)
        city_name = try values.decodeIfPresent(String.self, forKey: .city_name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        social_id = try values.decodeIfPresent(String.self, forKey: .social_id)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        lon = try values.decodeIfPresent(String.self, forKey: .lon)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        addresstype = try values.decodeIfPresent(String.self, forKey: .addresstype)
        address_id = try values.decodeIfPresent(String.self, forKey: .address_id)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        gender_type = try values.decodeIfPresent(String.self, forKey: .gender_type)
        wallet = try values.decodeIfPresent(String.self, forKey: .wallet)
        register_id = try values.decodeIfPresent(String.self, forKey: .register_id)
        ios_register_id = try values.decodeIfPresent(String.self, forKey: .ios_register_id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        approve_status = try values.decodeIfPresent(String.self, forKey: .approve_status)
        available_status = try values.decodeIfPresent(String.self, forKey: .available_status)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        new_code = try values.decodeIfPresent(String.self, forKey: .new_code)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
        remove_status = try values.decodeIfPresent(String.self, forKey: .remove_status)
        pay_now_number = try values.decodeIfPresent(String.self, forKey: .pay_now_number)
        local_bank_number = try values.decodeIfPresent(String.self, forKey: .local_bank_number)
        bank_name = try values.decodeIfPresent(String.self, forKey: .bank_name)
        nrc_document = try values.decodeIfPresent(String.self, forKey: .nrc_document)
        business_logo = try values.decodeIfPresent(String.self, forKey: .business_logo)
        business_name = try values.decodeIfPresent(String.self, forKey: .business_name)
        business_address = try values.decodeIfPresent(String.self, forKey: .business_address)
        une_register_number = try values.decodeIfPresent(String.self, forKey: .une_register_number)
        min_day_rate = try values.decodeIfPresent(String.self, forKey: .min_day_rate)
        ticked_day_rate = try values.decodeIfPresent(String.self, forKey: .ticked_day_rate)
        urgent_rate = try values.decodeIfPresent(String.self, forKey: .urgent_rate)
        booking_status = try values.decodeIfPresent(String.self, forKey: .booking_status)
        note = try values.decodeIfPresent(String.self, forKey: .note)
        job_document = try values.decodeIfPresent(String.self, forKey: .job_document)
        job_type_id = try values.decodeIfPresent(String.self, forKey: .job_type_id)
        job_type_name = try values.decodeIfPresent(String.self, forKey: .job_type_name)
        request_payment_type = try values.decodeIfPresent(String.self, forKey: .request_payment_type)
        shift_autoapproval = try values.decodeIfPresent(String.self, forKey: .shift_autoapproval)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        currency_symbol = try values.decodeIfPresent(String.self, forKey: .currency_symbol)
    }

}
