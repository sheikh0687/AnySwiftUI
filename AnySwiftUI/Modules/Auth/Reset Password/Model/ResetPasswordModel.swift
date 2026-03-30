//
//  ResetPasswordModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

import Foundation

struct Api_ResetPassword : Codable {
    let otp : Int?
    let id : String?
    let result : String?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case otp = "otp"
        case id = "id"
        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        otp = try values.decodeIfPresent(Int.self, forKey: .otp)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        result = try values.decodeIfPresent(String.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}
