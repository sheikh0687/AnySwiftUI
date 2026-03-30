//
//  NotificationCountModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 20/03/26.
//

import Foundation

struct Api_NotificationCount : Codable {
    let average_rating : String?
    let total_rating_count : Int?
    let completed_shift : Int?
    let worker_experience : String?
    let attandance : String?
    let total_count : Int?
    let chat_count : Int?
    let request : Int?
    let booking_approved : Int?
    let broadcast_booking : Int?
    let result : String?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case average_rating = "average_rating"
        case total_rating_count = "total_rating_count"
        case completed_shift = "completed_shift"
        case worker_experience = "worker_experience"
        case attandance = "attandance"
        case total_count = "total_count"
        case chat_count = "chat_count"
        case request = "request"
        case booking_approved = "booking_approved"
        case broadcast_booking = "broadcast_booking"
        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        average_rating = try values.decodeIfPresent(String.self, forKey: .average_rating)
        total_rating_count = try values.decodeIfPresent(Int.self, forKey: .total_rating_count)
        completed_shift = try values.decodeIfPresent(Int.self, forKey: .completed_shift)
        worker_experience = try values.decodeIfPresent(String.self, forKey: .worker_experience)
        attandance = try values.decodeIfPresent(String.self, forKey: .attandance)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
        chat_count = try values.decodeIfPresent(Int.self, forKey: .chat_count)
        request = try values.decodeIfPresent(Int.self, forKey: .request)
        booking_approved = try values.decodeIfPresent(Int.self, forKey: .booking_approved)
        broadcast_booking = try values.decodeIfPresent(Int.self, forKey: .broadcast_booking)
        result = try values.decodeIfPresent(String.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}
