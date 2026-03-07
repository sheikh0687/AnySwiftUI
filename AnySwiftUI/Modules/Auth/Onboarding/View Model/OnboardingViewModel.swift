//
//  OnboardingViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/02/26.
//

import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    
    @Published var currentPage = 0
    @Published var goToLogin = false
    
    let onboardingData: [OnboardingItem] = [
        .init(imageName: "logo", title: "Welcome to ANY", description: "Find jobs and get workers\nINSTANTLY"),
        .init(imageName: "location_pin", title: "ANY Place", description: "We will help you find the best available jobs in your location for your convenience"),
        .init(imageName: "slidewatch", title: "ANY Time", description: "You can find jobs while drinking your morning coffee or while sipping your tea before bed"),
        .init(imageName: "slidesearch", title: "ANY WORK", description: "You can find jobs while drinking your morning coffee or while sipping your tea before bed")
    ]
    
    func nextTapped() {
        if currentPage < onboardingData.count - 1 {
            withAnimation(.spring()) {
                currentPage += 1
            }
        } else {
            goToLogin = true
        }
    }

    func skipTapped() {
        goToLogin = true
    }
}
