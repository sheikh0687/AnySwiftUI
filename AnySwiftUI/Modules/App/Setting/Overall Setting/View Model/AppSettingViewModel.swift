//
//  AppSettingViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 30/03/26.
//

import Observation

@Observable
class AppSettingViewModel {
    
    var navToCurrentShift: Bool = false
    var navToChangePassword: Bool = false
    var navToEditProfile: Bool = false
    var navToOutletList: Bool = false
    var navToPaymentType: Bool = false
    var navToSetHourlyRate: Bool = false
    var navToHistory: Bool = false
}
