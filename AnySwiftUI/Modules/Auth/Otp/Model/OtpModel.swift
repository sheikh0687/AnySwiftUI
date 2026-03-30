//
//  OtpModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 11/03/26.
//

import Foundation

struct Api_VerifyOtp : Codable {
    let result : Res_Otp?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Res_Otp.self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_Otp : Codable {
    let code : Int?
    let optional_otp : String?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case optional_otp = "optional_otp"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        optional_otp = try values.decodeIfPresent(String.self, forKey: .optional_otp)
    }

}
