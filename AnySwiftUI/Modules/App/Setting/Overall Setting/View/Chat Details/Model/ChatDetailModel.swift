//
//  ChatDetailModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 11/06/26.
//

import Foundation

struct Api_ChatDetailsList : Codable {
    let result : [Res_ChatDetailsList]?
    let status : String?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case status = "status"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_ChatDetailsList].self, forKey: .result)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

struct Res_ChatDetailsList : Codable {
    let id : String?
    let sender_id : String?
    let receiver_id : String?
    let chat_message : String?
    let request_id : String?
    let chat_image : String?
    let clear_chat : String?
    let type : String?
    let timezone : String?
    let date_time : String?
    let status : String?
    let is_read : String?
    let admin_status : String?
    let support_name : String?
    let result : String?
    let sender_detail : Sender_detail?
    let receiver_detail : Receiver_detail?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case sender_id = "sender_id"
        case receiver_id = "receiver_id"
        case chat_message = "chat_message"
        case request_id = "request_id"
        case chat_image = "chat_image"
        case clear_chat = "clear_chat"
        case type = "type"
        case timezone = "timezone"
        case date_time = "date_time"
        case status = "status"
        case is_read = "is_read"
        case admin_status = "admin_status"
        case support_name = "support_name"
        case result = "result"
        case sender_detail = "sender_detail"
        case receiver_detail = "receiver_detail"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        sender_id = try values.decodeIfPresent(String.self, forKey: .sender_id)
        receiver_id = try values.decodeIfPresent(String.self, forKey: .receiver_id)
        chat_message = try values.decodeIfPresent(String.self, forKey: .chat_message)
        request_id = try values.decodeIfPresent(String.self, forKey: .request_id)
        chat_image = try values.decodeIfPresent(String.self, forKey: .chat_image)
        clear_chat = try values.decodeIfPresent(String.self, forKey: .clear_chat)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        is_read = try values.decodeIfPresent(String.self, forKey: .is_read)
        admin_status = try values.decodeIfPresent(String.self, forKey: .admin_status)
        support_name = try values.decodeIfPresent(String.self, forKey: .support_name)
        result = try values.decodeIfPresent(String.self, forKey: .result)
        sender_detail = try values.decodeIfPresent(Sender_detail.self, forKey: .sender_detail)
        receiver_detail = try values.decodeIfPresent(Receiver_detail.self, forKey: .receiver_detail)
    }
}

struct Sender_detail : Codable {
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
    let sender_image : String?

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
        case sender_image = "sender_image"
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
        sender_image = try values.decodeIfPresent(String.self, forKey: .sender_image)
    }
}

struct Receiver_detail : Codable {
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
    let receiver_image : String?

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
        case receiver_image = "receiver_image"
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
        receiver_image = try values.decodeIfPresent(String.self, forKey: .receiver_image)
    }

}

struct ChatMessageUI: Identifiable, Equatable {
    let id: String
    let message: String
    let dateTime: String
    let isCurrentUser: Bool
    let avatarURL: String?
    let isSupport: Bool
    let supportName: String?
    let seenStatus: String   // "Read" or "Sent"
}
