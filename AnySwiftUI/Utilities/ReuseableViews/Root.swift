//
//  Root.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 30/03/26.
//

import SwiftUI

struct Root: View {
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.isLoggedIn {
                DashboardView()
            } else {
                OnboardingView()
            }
        }
    }
}

#Preview {
    Root()
}
