//
//  DashboardView.swift
//  Glisexab
//
//  Created by Arbaz  on 24/12/25.
//

import SwiftUI

struct DashboardView: View {
 
    @State private var selectedTab: Tabs = .myBooking
    @StateObject var topBarVM = TopBarViewModel()

    var body: some View {
        
        NavigationStack {
            VStack(spacing: 0) {
                
                TopBarView(viewModel: topBarVM)
                
                TabView(selection: $selectedTab) {
                    
                    // MARK: My Bookings
                    MyBookingView()
                        .tag(Tabs.myBooking)
                        .tabItem {
                            Label("My Bookings", systemImage: "briefcase.fill")
                        }
                    
                    // MARK: Find Job
                    JobProviderView()
                        .tag(Tabs.findJob)
                        .tabItem {
                            Label("Find a Job", systemImage: "magnifyingglass")
                        }
                    
                    // MARK: Wallet
                    WorkerTransactionView()
                        .tag(Tabs.wallet)
                        .tabItem {
                            Label("Wallet", systemImage: "creditcard.fill")
                        }
                    
                    // MARK: Wishlist
                    JobProviderView()
                        .tag(Tabs.wishList)
                        .tabItem {
                            Label("WishList", systemImage: "heart.fill")
                        }
                    
                    // MARK: Profile
                    ProfileView()
                        .tag(Tabs.profile)
                        .tabItem {
                            Label("Profile", systemImage: "person.crop.circle.fill")
                        }
                }
                .environmentObject(topBarVM)
                .accentColor(.THEME)
                .modifier(ToolbarColorSchemeModifier())
                .environment(\.horizontalSizeClass, .compact)
            }
            
            // 👉 GLOBAL NAVIGATION DESTINATIONS LIVE HERE
            .navigationDestination(isPresented: $topBarVM.navToMenu) {
                OverallSettingView()
            }
        }
        
        // MARK: Lifecycle
        .onAppear {
            setupTabBarAppearance()
            topBarVM.showMenu = false
            topBarVM.showAttendance = true
            
            topBarVM.onMenuTap = {
                topBarVM.navToMenu = true
            }
            
            Task {
                await loadNotificationCount()
            }
        }
        
        // MARK: Tab Change Handling
        .onChange(of: selectedTab) { _, tab in
            switch tab {
                
            case .myBooking:
                topBarVM.showAttendance = true
                topBarVM.showMenu = false
                
            case .findJob:
                topBarVM.showMenu = false
                topBarVM.showAttendance = false
                
            case .wallet:
                topBarVM.showAttendance = true
                topBarVM.showMenu = false
                
            case .profile:
                topBarVM.showAttendance = false
                topBarVM.showMenu = true
                
//                topBarVM.navToMenu = true
            default:
                topBarVM.showAttendance = false
                topBarVM.showMenu = false
            }
        }
    }
    
    func loadNotificationCount() async {
        print("Call notification Api first")
        do {
            let response = try await topBarVM.fetchNotificationCount()
            if response.status == "1" {
                topBarVM.chatCount = response.chat_count ?? 0
                topBarVM.notificationCount = response.request ?? 0
                topBarVM.review = response.average_rating ?? ""
                topBarVM.ratingCount = response.total_rating_count ?? 0
                topBarVM.attendanceRate = response.attandance ?? ""
            }
        } catch {
            print("Something Went Wrong: \(error.localizedDescription)")
        }
    }
    
    func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.shadowColor = .lightGray
        appearance.backgroundColor = UIColor.white
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

/// ViewModifier to conditionally apply toolbarColorScheme on iOS 16+
private struct ToolbarColorSchemeModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.toolbarColorScheme(.light, for: .tabBar)
        } else {
            content
        }
    }
}

/// Custom ViewModifier to handle navigation bar hiding for different iOS versions
private struct NavigationBarHidingModifier: ViewModifier {
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 16.0, *) {
                content.toolbar(.hidden, for: .navigationBar)
            } else {
                content.navigationBarHidden(true)
            }
        }
    }
}

private extension View {
    func applyNavigationBarHiding() -> some View {
        modifier(NavigationBarHidingModifier())
    }
}

#Preview {
    DashboardView()
}
