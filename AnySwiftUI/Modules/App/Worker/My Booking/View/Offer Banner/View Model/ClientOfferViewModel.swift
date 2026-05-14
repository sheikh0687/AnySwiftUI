//
//  ClientOfferViewModel.swift
//  Any
//
//  Created by Arbaz  on 01/04/26.
//

import Observation
import SwiftUI

@Observable
class ClientOfferVM {
    
    var offers: [Res_ClientOffer] = []
    var isLoading = false
    var showOfferDetail = false
    var bookingShift = false
    var infoDetail = false
    var shiftDate = ""
    
    var selectedClientInfo: Res_ClientOffer?
    var selectedProvider: Res_JobProvider?
    
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
    }
}
