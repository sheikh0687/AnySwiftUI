//
//  ClientJobView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/04/26.
//

import SwiftUI

struct ClientJobView: View {
    
    @State var viewModel = ClientJobViewModel()
    
    var segmentItems: [SegmentItem] {
        [
            SegmentItem(title: "Daily",  count: viewModel.dailyPendingCount),
            SegmentItem(title: "Weekly", count: viewModel.weeklyPendingCount)
        ]
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                
                VStack(spacing: 0) {
                    OutletSelectorView (
                        selectedOutlet: viewModel.selectedOutlet,
                        outlets: viewModel.outlets,
                        showDropDown: $viewModel.showOutletDropDown,
                        onSelectOutlet: { viewModel.selectOutlet($0) }
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    SegmentButton (
                        item: segmentItems,
                        selectedIndex: Binding (
                            get: { viewModel.selectedTabIndex },
                            set: { viewModel.selectedTabIndex = $0 }
                        )
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    tabContentView
                }
            }
        }
        .task {
            do {
                let outletResponse = try await viewModel.fetchOutlets()
                viewModel.applyOutlets(outletResponse)
                
                await viewModel.refreshData()
            } catch {
                print("Initial load error: \(error)")
            }
        }
//        .overlay {
//            if viewModel.isLoading {
//                ProgressView()
//                    .progressViewStyle(.circular)
//                    .scaleEffect(1.5)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color.black.opacity(0.2))
//            }
//        }
        .onTapGesture {
            if viewModel.showOutletDropDown {
                viewModel.showOutletDropDown = false
            }
        }
    }
    
    @ViewBuilder
    var tabContentView: some View {
        ZStack {
            if viewModel.selectedTab == .daily {
                dailyTabContent
                    .transition(.move(edge: .leading).combined(with: .opacity))
            } else {
                JobWeeklyView(
                    weekDays: viewModel.weekDays,
                    weekDayNames: viewModel.weekDayNames,
                    currentMonthYear: viewModel.currentMonthYear,
                    jobTypes: viewModel.jobTypes,
                    navigateToRequestByDate: $viewModel.navigateToRequestByDate,
                    onPreviousWeek: { viewModel.goToPreviousWeek() },
                    onNextWeek: { viewModel.goToNextWeek() }
                )
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.35), value: viewModel.selectedTab)
    }
    
    var dailyTabContent: some View {
        VStack(spacing: 20) {
            ManpowerView (
                todayShiftName: viewModel.todayShiftName,
                todayShiftDescription: viewModel.todayShiftDescription,
                manpowerWorkers: viewModel.manpowerWorkers,
                navigateToRequest: $viewModel.navigateToRequest
            )

            Divider().padding(.horizontal, 16)

            UpcomingView (
                upcomingShifts: viewModel.upcomingShifts,
                navigateToRequestByDate: $viewModel.navigateToRequestByDate
            )

            Spacer(minLength: 40)
        }
    }
}

#Preview {
    ClientJobView()
}
