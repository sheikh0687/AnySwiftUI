//
//  JobProviderViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 27/03/26.
//

internal import Combine

class JobProviderViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var customError: CustomError?

    @Published var dayName: String = ""
    @Published var date: String = ""
    @Published var day: String = ""
    @Published var availableSlot: [Res_AvailableSlot] = []
    @Published var jobProviderList: [Res_JobProvider] = []
    @Published var objProviderList: Res_JobProvider?
    
    @Published var strClientiD: String = ""
    @Published var addedFavClient: Bool = false
    
    @Published var search: String = ""
    @Published var showJobType: Bool = false
    
    @Published var jobiD: String = ""
    @Published var jobName: String = ""
    
    @Published var userLat: Double = 0.0
    @Published var userLon: Double = 0.0
    @Published var selectedAddress: String = ""
    
    @Published var showLocationResults = false
    @Published var isSelectingSuggestion = false
    
    @Published var navToBooking: Bool = false
    @Published var preselectedDate: Date?
    
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
