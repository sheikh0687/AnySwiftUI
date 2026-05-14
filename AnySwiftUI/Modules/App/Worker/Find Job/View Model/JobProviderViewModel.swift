//
//  JobProviderViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 27/03/26.
//

import Observation

@Observable
class JobProviderViewModel {
    
    var isLoading = false
    var customError: CustomError?
    
    var dayName: String = ""
    var date: String = ""
    var day: String = ""
    
    var availableSlot: [Res_AvailableSlot] = []
    var jobProviderList: [Res_JobProvider] = []
    var objProviderList: Res_JobProvider?
    
    var strClientiD: String = ""
    var addedFavClient: Bool = false
    
    var search: String = ""
    var showJobType: Bool = false
    
    var jobiD: String = ""
    var jobName: String = ""
    
    var userLat: Double = 0.0
    var userLon: Double = 0.0
    var selectedAddress: String = ""
    
    var showLocationResults = false
    var isSelectingSuggestion = false
    
    var navToBooking: Bool = false
    var preselectedDate: Date?
    
    var scrollOffset: CGFloat = 0
    var showTopViews: Bool = true
    
    var filteredList: [Res_JobProvider] {
        if search.isEmpty {
            return jobProviderList
        }
        
        return jobProviderList.filter {
            ($0.business_name ?? "")
                .lowercased()
                .contains(search.lowercased())
        }
    }
    
    @MainActor
    func fetchAvailableSlot() async throws -> Api_JobAvailableSlot {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_next_seven_date_list.url(),
            params: paramDict,
            responseType: Api_JobAvailableSlot.self
        )
        
        return response
    }
    
    @MainActor
    func fetchJobProviderList() async throws -> Api_JobProvider {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["lat"] = userLat
        paramDict["lat"] = userLon
        paramDict["finddate"] = date
        paramDict["day_name"] = dayName
        paramDict["cat_id"] = ""
        paramDict["country_id"] = AppState.shared.countryiD
        paramDict["job_type_id"] = jobiD
        paramDict["job_type_name"] = jobName
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_client_list.url(),
            params: paramDict,
            responseType: Api_JobProvider.self
        )
        
        return response
    }
    
    @MainActor
    func addFavUnFav(clientiD: String) async throws -> Api_CommonModel {
        
        var paramDict: [String : Any] = [:]
        paramDict["worker_id"] = AppState.shared.useriD
        paramDict["client_id"] = clientiD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.like_unlike.url(),
            params: paramDict,
            responseType: Api_CommonModel.self
        )
        
        return response
    }
}
