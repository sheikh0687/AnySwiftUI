//
//  JobProviderView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 27/03/26.
//

import SwiftUI
import MapKit

struct JobProviderView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var locationSearchVM = LocationSearchViewModel()
    
    @State var viewModel = JobProviderViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 0) {
                
                if viewModel.showTopViews {
                    VStack(alignment: .leading, spacing: 16) {
                        // Search Location
                        searchLocation
                        
                        // Search Bar
                        searchBarView
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 12)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Available Booking Date
                    slotDateBooking
                        .padding(.horizontal, 24)
                    
                    // Job Provider
                    jobProviderList
                }
                .padding(.top, viewModel.showTopViews ? 0 : 16)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.showTopViews)
        .onAppear {
            Task {
                await loadAvailableSlot()
                await loadJobProviderList()
            }
            
            locationManager.requestLocation()
        }
        .onChange(of: viewModel.addedFavClient) {
            Task {
                await loadJobProviderList()
            }
        }
//        .onChange(of: appState.goToHome) { _, go in
//            if go {
//                viewModel.navToBooking = false  // 👈 pops BookingDetailView
//            }
//        }
        .onChange(of: locationManager.latitude) {
            // Save GPS to VM
            viewModel.userLat = locationManager.latitude
            viewModel.userLon = locationManager.longitude
            
            locationSearchVM.query = locationManager.currentAddress
            // Reload providers near user
            Task {
                await loadJobProviderList()
            }
        }
        .sheet(isPresented: $viewModel.showJobType) {
            ShiftSheetView(viewModel: .init(cloJobType: { jobiD, jobName in
                viewModel.jobiD = jobiD
                viewModel.jobName = jobName
                Task {
                    await loadJobProviderList()
                }
            }))
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .navigationDestination(isPresented: $viewModel.navToBooking, destination: {
            BookingDetailView(viewModel: .init(preselectedDate: viewModel.preselectedDate, obj: viewModel.objProviderList))
        })
        .navigationBarBackButtonHidden(true)
    }
    
    private func loadAvailableSlot() async {
        do {
            let response = try await viewModel.fetchAvailableSlot()
            if response.status == "1" {
                viewModel.availableSlot = response.result ?? []
                viewModel.dayName = response.result?[0].dayname ?? ""
                viewModel.date = response.result?[0].date ?? ""
                viewModel.day = response.result?[0].day ?? ""
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    private func loadJobProviderList() async {
        viewModel.isLoading = true
        viewModel.customError = nil
        
        defer { viewModel.isLoading = false }
        
        do {
            let response = try await viewModel.fetchJobProviderList()
            if response.status == "1" {
                viewModel.jobProviderList = response.result ?? []
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    private var slotDateBooking: some View {
        VStack(alignment: .leading, spacing: 8) {
            IBLabel (
                text: "View available slots:", font: .semibold(.title)
            )
            Menu {
                ForEach(viewModel.availableSlot, id: \.date) { slot in
                    Button {
                        viewModel.dayName = slot.dayname ?? ""
                        viewModel.date = slot.date ?? ""
                        viewModel.day = slot.day ?? ""
                        
                        if let dateString = slot.date,
                           let convertedDate = SGDate.dateFromAPI(dateString) {
                            viewModel.preselectedDate = convertedDate
                        }
                        
                    } label: {
                        Text(slot.day ?? "")
                    }
                }
            } label: {
                HStack(spacing: 18) {
                    Button {
                        print("Select Country")
                    } label: {
                        IBLabel(text: viewModel.day, font: .regular(.title), color: .black)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background (
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray.opacity(0.2))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
            }
        }
    }
    
    private var jobProviderList: some View {
        ScrollView(showsIndicators: false) {
            
            Color.clear
                .frame(height: 0)
                .background (
                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: ScrollOffsetKey.self,
                                value: geo.frame(in: .named("scroll")).minY
                            )
                    }
                )
            
            if viewModel.isLoading {
                ProgressView("Loading Provider...")
                    .frame(maxWidth: .infinity)
                    .padding()
            } else if viewModel.jobProviderList.isEmpty {
                EmptyView (
                    title: "High demand! All shifts for this date are already taken.",
                    subtitle: "Don’t miss out — pick another available date now.",
                    img: ""
                )
            } else {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.filteredList, id: \.id) { jobProvider in
                        JobBookingCardView(viewModel: viewModel, obj: jobProvider)
                            .onTapGesture {
                                viewModel.objProviderList = jobProvider
                                viewModel.navToBooking = true
                            }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            // ✅ value starts at 0, goes negative when scrolling down
            let shouldShow = value > -30
            if shouldShow != viewModel.showTopViews {
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.showTopViews = shouldShow
                }
            }
        }
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .tint(.gray)
            IBTextField(placeholder: "Search outlet name", text: $viewModel.search)
            
            Spacer()
            
            Button {
                viewModel.showJobType = true
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .fontWeight(.bold)
                    .tint(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background (
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.gray.opacity(0.2))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        }
    }
    
    private var searchLocation: some View {
        VStack(spacing: 0) {
            // 📍 Location search bar
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.accentColor)
                
                TextField("Search location", text: $locationSearchVM.query)
                    .onChange(of: locationSearchVM.query) { _, value in
                        
                        if viewModel.isSelectingSuggestion { return }
                        
                        viewModel.showLocationResults = true
                        locationSearchVM.search(value)
                    }
                
                if !locationSearchVM.query.isEmpty {
                    Button {
                        locationSearchVM.query = ""
                        locationSearchVM.results = []
                        viewModel.showLocationResults = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                
                // 📍 Current GPS button
//                Button {
//                    locationSearchVM.query = "Fetching location..."
//                    locationManager.requestLocation()
//                } label: {
//                    Image(systemName: "location.circle.fill")
//                        .foregroundColor(.blue)
//                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background (
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.gray.opacity(0.2))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
            }
            
            // 🔎 Apple autocomplete results
//            if viewModel.showLocationResults && !locationSearchVM.results.isEmpty {
//                ScrollView {
//                    LazyVStack(alignment: .leading) {
//                        ForEach(locationSearchVM.results, id: \.self) { result in
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text(result.title).bold()
//                                Text(result.subtitle).font(.caption)
//                            }
//                            .padding()
//                            .onTapGesture {
//                                selectLocation(result)
//                            }
//                            
//                            Divider()
//                        }
//                    }
//                }
//                .frame(maxHeight: 200)
//                .background(.white)
//                .clipShape(RoundedRectangle(cornerRadius: 16))
//            }
  
            if viewModel.showLocationResults && !locationSearchVM.results.isEmpty {
                VStack(spacing: 0) {
                    ForEach(locationSearchVM.results, id: \.self) { result in
                        Button {
                            selectLocation(result)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.system(size: 18))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(result.title)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    if !result.subtitle.isEmpty {
                                        Text(result.subtitle)
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                        }
                        
                        if result != locationSearchVM.results.last {
                            Divider().padding(.leading, 46)
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .padding(.top, 4)
            }
        }
    }
    
    private func selectLocation(_ result: MKLocalSearchCompletion) {
        
        viewModel.isSelectingSuggestion = true
        
        locationSearchVM.selectLocation(result) { coordinate, address in
            
            // Save address in textfield
            locationSearchVM.query = address
            
            DispatchQueue.main.async {
                viewModel.isSelectingSuggestion = false
            }
            
            viewModel.showLocationResults = false
            
            // Save lat/lon to ViewModel 🔥
            viewModel.userLat = coordinate.latitude
            viewModel.userLon = coordinate.longitude
            viewModel.selectedAddress = address
            
            // Reload providers using new location
            Task {
                await loadJobProviderList()
            }
        }
    }
}

struct JobBookingCardView: View {
    
    let viewModel: JobProviderViewModel
    let obj: Res_JobProvider
    
    var body: some View {
        VStack(spacing: 16) {
            // Header Business Name & Logo
            HStack(spacing: 16) {
                if let urlString = obj.business_logo {
                    CustomWebImage (
                        imageUrl: urlString,
                        placeholder: Image(systemName: "photo.fill"),
                        width: 60,
                        height: 60
                    )
                    .clipShape(.circle)
                    .frame(width: 60, height: 60)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    IBLabel (
                        text: obj.business_name ?? "",
                        font: .semibold(.title),
                        color: .black
                    )
                    
                    VStack(alignment: .leading,spacing: 2) {
                        IBLabel (
                            text: obj.booking_status == "Open" ? "Available" : "Not Available",
                            font: .semibold(.subtitle),
                            color: obj.booking_status == "Open" ? .GREEN : .gray
                        )
                        if obj.shift_autoapproval == "Yes" {
                            IBLabel (
                                text: "Instant Approval",
                                font: .semibold(.subtitle),
                                color: .BUTTON
                            )
                        }
                    }
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(.WHITE)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: obj.fav_status == "Yes" ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.red)
                }
                .onTapGesture {
                    Task {
                        await loadFavUnFav()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            //  Business Address
            HStack(alignment: .top, spacing: 4) {
                IBLabel (
                    text: "Address: ",
                    font: .bold(.subtitle),
                    color: .gray
                )
                .fixedSize()
                
                IBLabel (
                    text: "\(obj.business_address ?? "")",
                    font: .medium(.subtitle),
                    color: .gray
                )
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background (
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
        )
        .overlay (
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        )
    }
    
    func loadFavUnFav() async {
        viewModel.addedFavClient = false
        
        do {
            let response = try await viewModel.addFavUnFav(clientiD: obj.id ?? "")
            if response.status == "1" {
                viewModel.addedFavClient = true
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

// MARK: - Scroll Offset Preference Key
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()  // ✅ take latest value, not accumulate
    }
}

#Preview {
    JobProviderView()
        .environmentObject(AppState())
}

