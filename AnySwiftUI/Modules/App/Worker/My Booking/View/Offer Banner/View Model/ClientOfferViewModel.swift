//
//  ClientOfferViewModel.swift
//  Any
//
//  Created by Arbaz  on 01/04/26.
//

import Foundation
import Observation

@MainActor
@Observable
class ClientOfferVM {

    // MARK: - Banner Data
    var offers: [Res_ClientOffer] = []
    var clientOffers: [Res_ClientBannerList] = []

    // MARK: - UI State
    var isLoading = false
    var showOfferDetail = false
    var bookingShift = false
    var infoDetail = false
    var shiftDate = ""

    // MARK: - Navigation State
    var selectedOfferInfo: Res_ClientOffer?            // worker non-shift card tap
    var selectedClientBannerInfo: Res_ClientBannerList? // client banner tap
    var selectedProvider: Res_JobProvider?

    // MARK: - Worker Banners
    @discardableResult
    func getBannerList() async throws -> Api_ClientOffer {
        isLoading = true
        defer { isLoading = false }

        let paramsDict: [String: Any] = [:]

        let response = try await Service.shared.request(
            url: Router.get_banner_list.url(),
            params: paramsDict,
            responseType: Api_ClientOffer.self
        )

        offers = response.status == "1" ? (response.result ?? []) : []
        return response
    }

    // MARK: - Client Banners
    @discardableResult
    func getClientBannerList() async throws -> Api_ClientBannerList {
        isLoading = true
        defer { isLoading = false }

        let paramsDict: [String: Any] = [:]

        let response = try await Service.shared.request(
            url: Router.get_client_banner_list.url(),
            params: paramsDict,
            responseType: Api_ClientBannerList.self
        )

        clientOffers = response.status == "1" ? (response.result ?? []) : []
        return response
    }
}
