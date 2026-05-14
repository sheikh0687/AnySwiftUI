//
//  BookingHourViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 13/04/26.
//

import Observation

@Observable
class BookingHourViewModel {
    
    var isLoading = false
    
    var cartiD: String = ""
    var clientLat: String = ""
    var clientLon: String = ""
    var workingStatus: String = ""
    
    var locationAlert: LocationAlert?
    var isCheckingLocation = false
    var navigateToComplete  = false

    var shiftDetail: Api_BookingHours?
    var arrayOfBreakTime: [String] = []
    
    var clockOutInResult: Api_ClockOutIn?
    var showClockOutConfirmation = false
    var clockInError: ClockInError?
    
    var activeBreakPopup: BreakPopup?
    
    init(cartiD: String) {
        self.cartiD = cartiD
    }
    
    @MainActor
    func fecthShiftDetail() async throws -> Api_BookingHours {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["cart_id"] = cartiD
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.get_set_shift_cart_details.url(),
            params: paramDict,
            responseType: Api_BookingHours.self
        )
        
        return response
    }
    
    @MainActor
    func addClockOutIn(strType: String) async throws -> Api_ClockOutIn {
        
        var paramDict: [String : Any] = [:]
        paramDict["user_id"] = AppState.shared.useriD
        paramDict["cart_id"] = cartiD
        paramDict["shift_id"] = shiftDetail?.result?.shift_id ?? ""
        paramDict["clock_time"] = SGDate.currentTime()
        paramDict["type"] = strType
        paramDict["date"] = SGDate.currentDate()
        
        let lat = LocationManager.shared.latitude
        let lon = LocationManager.shared.longitude
        
        paramDict["lat"] = lat
        paramDict["lon"] = lon
        
        print(paramDict)
        
        let response = try await Service.shared.request (
            url: Router.add_clock_in_time.url(),
            params: paramDict,
            responseType: Api_ClockOutIn.self
        )
        
        if response.status == "1" {
            self.workingStatus    = response.result?.working_status ?? ""
            self.clockOutInResult = response          // ← triggers navigation in the View
        } else {
            self.clockInError = ClockInError (
                message: response.message ?? "",
                address: shiftDetail?.result?.set_shift?.address ?? ""
            )
        }
        
        return response
    }
}
