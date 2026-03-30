//
//  CountryList.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 09/03/26.
//

import Foundation

struct Api_CountryList : Codable {
    let result : [Res_CountryList]?
    let message : String?
    let status : String?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent([Res_CountryList].self, forKey: .result)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}

struct Res_CountryList : Codable {
    let id : String?
    let sortname : String?
    let name : String?
    let currency_code : String?
    let currency_name : String?
    let phone_code : String?
    let capital : String?
    let flag : String?
    let status : String?
    let client_document : String?
    let worker_document : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case sortname = "sortname"
        case name = "name"
        case currency_code = "currency_code"
        case currency_name = "currency_name"
        case phone_code = "phone_code"
        case capital = "capital"
        case flag = "flag"
        case status = "status"
        case client_document = "client_document"
        case worker_document = "worker_document"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        sortname = try values.decodeIfPresent(String.self, forKey: .sortname)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        currency_code = try values.decodeIfPresent(String.self, forKey: .currency_code)
        currency_name = try values.decodeIfPresent(String.self, forKey: .currency_name)
        phone_code = try values.decodeIfPresent(String.self, forKey: .phone_code)
        capital = try values.decodeIfPresent(String.self, forKey: .capital)
        flag = try values.decodeIfPresent(String.self, forKey: .flag)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        client_document = try values.decodeIfPresent(String.self, forKey: .client_document)
        worker_document = try values.decodeIfPresent(String.self, forKey: .worker_document)
    }

}
