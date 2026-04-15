//
//  ClientOfferViewModel.swift
//  Any
//
//  Created by Arbaz  on 01/04/26.
//

import UIKit
import SwiftUI
internal import Combine

@MainActor
class ClientOfferVM: ObservableObject {
    
    @Published var offers: [Res_ClientOffer] = []
    @Published var isLoading = false
    @Published var showOfferDetail = false
    @Published var bookingShift = false
    @Published var infoDetail = false
    @Published var shiftDate = ""
    
    @Published var selectedClientInfo: Res_ClientOffer?
    @Published var selectedProvider: Res_JobProvider?
    
    func getBannerList() async throws -> Api_ClientOffer {
        isLoading = true
        
        defer { isLoading = false }
        
        let paramsDict:[String:Any] = [:]
        
        let response = try await Service.shared.request (
            url: Router.get_banner_list.url(),
            params: paramsDict,
            responseType: Api_ClientOffer.self
        )
        
        if response.status == "1" {
            self.offers = response.result ?? []
        } else {
            self.offers = []
        }
        
        return response
        
        //        do {
        //            let json = try await CommunicationManager.callPostServiceAsync (
        //                apiUrl: Router.get_banner_list.url(),
        //                parameters: paramsDict,
        //                parentViewController: nil
        //            )
        //
        //            // Convert SwiftyJSON -> Data -> Codable model
        //            let data = try json.rawData()
        //            let decoded = try JSONDecoder().decode(Api_ClientOffer.self, from: data)
        //
        //            if decoded.status == "1" {
        //                self.offers = decoded.result ?? []
        //            } else {
        //                self.offers = []
        //            }
        //
        //        } catch {
        //            print("API ERROR:", error.localizedDescription)
        //        }
    }
}
