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
        VStack(spacing: 0) {
            // Banner — always visible, fixed, never reacts to scroll
            ClientOfferView()
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                .padding(.top, 24)

            ScrollView {
                VStack(spacing: 16) {
                    // Outlet selector — collapses (scrolls away) naturally
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
                        selectedIndex: Binding(
                            get: { viewModel.selectedTabIndex },
                            set: { viewModel.selectedTabIndex = $0 }
                        )
                    )
                    .padding(.horizontal, 16)

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
        .onTapGesture {
            if viewModel.showOutletDropDown {
                viewModel.showOutletDropDown = false
            }
        }
        .navigationDestination(item: $viewModel.navigateToRequestByDate) { strDate in
            JobRequestView(viewModel: .init(strDate: strDate, isFor: "DateReq"))
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
                    isLoading: viewModel.isLoading,
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
            ManpowerView(
                todayShiftName: viewModel.todayShiftName,
                todayShiftDescription: viewModel.todayShiftDescription,
                manpowerWorkers: viewModel.manpowerWorkers,
                navigateToRequest: $viewModel.navigateToRequest
            )

            Divider().padding(.horizontal, 16)

            UpcomingView(
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
