//
//  SettingView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 30/03/26.
//

import SwiftUI

struct OverallSettingView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = AppSettingViewModel()
    
    var body: some View {
        VStack {
            Button {
                logout()
            } label: {
                Text("Logout")
            }
        }
    }
    
    func logout() {
        let appState = AppState.shared
        
        appState.isLoggedIn = false
        appState.useriD = ""
        appState.userFirstName = ""
        appState.userLastName = ""
        appState.emailiD = ""
        appState.userMobile = ""
        appState.ios_RegisterediD = ""
        appState.userType = ""
        appState.countryiD = ""
    }
}

#Preview {
    OverallSettingView()
}
