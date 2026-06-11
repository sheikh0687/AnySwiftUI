//
//  AddRatingModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/06/26.
//

import Foundation

struct Api_AddRating : Codable {
    let result : Res_AddRating?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_AddRating.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_AddRating : Codable {
    let id : String?
    let request_id : String?
    let from_id : String?
    let to_id : String?
    let rating : String?
    let feedback : String?
    let type : String?
    let date_time : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case request_id = "request_id"
        case from_id = "from_id"
        case to_id = "to_id"
        case rating = "rating"
        case feedback = "feedback"
        case type = "type"
        case date_time = "date_time"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        request_id = try values.decodeIfPresent(String.self, forKey: .request_id)
        from_id = try values.decodeIfPresent(String.self, forKey: .from_id)
        to_id = try values.decodeIfPresent(String.self, forKey: .to_id)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        feedback = try values.decodeIfPresent(String.self, forKey: .feedback)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        date_time = try values.decodeIfPresent(String.self, forKey: .date_time)
    }

}
