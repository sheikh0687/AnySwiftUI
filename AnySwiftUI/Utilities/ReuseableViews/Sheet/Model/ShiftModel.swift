//
//  ShiftModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 30/03/26.
//

import Foundation

struct Api_JobType : Codable {
    let result : [Res_JobType]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_JobType].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_JobType : Codable {
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
    }

}
