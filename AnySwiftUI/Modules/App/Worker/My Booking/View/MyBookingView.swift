//
//  MyBookingView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

import SwiftUI

struct MyBookingView: View {
    
    @StateObject var viewModel = MyBookingViewModel()
    @State var showSameDayShift = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 24) {
                
                ClientOfferView()
                
                SegmentButton (
                    item: [
                        SegmentItem(title: "Approved Booking", count: viewModel.acceptCount),
                        SegmentItem(title: "Pending Approval", count: viewModel.pendingCount)
                    ],
                    selectedIndex: $viewModel.selectedSegment
                )
                
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView("Loading booking...")
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if viewModel.workerBookingDetail.isEmpty {
                        EmptyView(title: "", subtitle: viewModel.selectedSegment == 0 ? "No Approved Bookings At The Moment" : "No Pending Bookings At The Moment", img: "")
                    } else {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.workerBookingDetail, id: \.id) { bookingShift in
                                WorkerBookingCardView(viewModel: viewModel, obj: bookingShift)
                                    .onTapGesture {
                                        if bookingShift.status == "Accept" {
                                            print("Booking Shift id: \(bookingShift.id ?? "")")
                                            viewModel.shiftiD = bookingShift.id ?? ""
                                            viewModel.conToBookingHour = true
                                        }
                                    }
                            }
                        }
                    }
                }
                
                IBSimpletButton(height: 36, width: 180, fgColor: .WHITE, buttonText: "See Same Day Job Request", bg: .BUTTON) {
                    print("Check the Same day request")
                    showSameDayShift = true
                }
//                Spacer()
            }
            .padding(.all, 16)
            
            if viewModel.showWithReq {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                viewModel.showWithReq = false
                            }
                        }
                    
                    PopBeforeBooking (
                        cloYes: { bool in
                            if bool {
                                print("Shift id from Closures: \(viewModel.shiftiD)")
                                Task {
                                    do {
                                        let response = try await viewModel.deleteWorkerShift()
                                        if response.status == "1" {
                                            viewModel.showWithReq = false
                                            viewModel.showDeletePop = true
                                        }
                                    } catch {
                                        viewModel.customError = .customError(message: error.localizedDescription)
                                    }
                                }
                            } else {
                                viewModel.showWithReq = false
                            }
                        },
                        companyName: viewModel.companyDetail,
                        shiftDetail: "",
                        instantBooking: "",
                        bookingNote: "",
                        shiftStatus: "",
                        comingFor: "Withdraw"
                    )
                    .transition(.scale)
                    .zIndex(1)
                }
            }
            
            if viewModel.showDeletePop {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                viewModel.showDeletePop = false
                            }
                        }
                    
                    PopUpDelete(companyDetail: viewModel.companyDetail) {
                        Task {
                            await loadBookings()
                        }
                        viewModel.showDeletePop = false
                    }
                    .transition(.scale)
                    .zIndex(1)
                }
            }
        }
        .onAppear {
            Task {
                await loadBookings()
            }
        }
        .onChange(of: viewModel.selectedSegment) { _, newValue in
            Task {
                await loadBookings()
            }
        }
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Ok"))
            )
        }
        .navigationDestination(isPresented: $viewModel.conToBookingHour, destination: {
            BookingHoursView(cartID: viewModel.shiftiD)
        })
        .navigationDestination(isPresented: $showSameDayShift, destination: {
            SameDayShiftView()
        })
        .navigationBarBackButtonHidden(true)
    }
    
    func loadBookings() async {
        print("Call booking Api Second")
        viewModel.isLoading = true
        
        do {
            let response = try await viewModel.fetchWorkerBookingDetail (
                strStatus: viewModel.selectedSegment == 0 ? "Accept" : "Pending"
            )
            
            if response.status == "1" {
                viewModel.workerBookingDetail = response.result ?? []
                viewModel.acceptCount = response.accept_shift_count ?? 0
                viewModel.pendingCount = response.pending_shift_count ?? 0
            } else {
                viewModel.workerBookingDetail = []
                viewModel.acceptCount = response.accept_shift_count ?? 0
                viewModel.pendingCount = response.pending_shift_count ?? 0
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
        
        viewModel.isLoading = false
    }
}

struct WorkerBookingCardView: View {
    
    let viewModel: MyBookingViewModel
    let obj: Res_WorkerBookingDetail
    
    var body: some View {
        VStack(spacing: 16) {
            // Header Business Name & Logo
            HStack {
                if let urlString = obj.client_details?.business_logo {
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
                        text: obj.client_details?.business_name ?? "",
                        font: .semibold(.title),
                        color: .black
                    )
                    
                    VStack(alignment: .leading,spacing: 2) {
                        IBLabel (
                            text: obj.format_date ?? "",
                            font: .medium(.subtitle),
                            color: .gray
                        )
                        if obj.status == "Accept" {
                            IBLabel (
                                text: "Confirmed",
                                font: .semibold(.caption),
                                color: .GREEN
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            // Job Rate & Time
            VStack(alignment: .leading, spacing: 8) {
                IBLabel (
                    text: "Rate: \(obj.set_shift_details?.currency_symbol ?? "")\(obj.shift_rate ?? "")/Hour",
                    font: .semibold(.subtitle),
                    color: .gray
                )
                IBLabel (
                    text: "Shift: \(obj.set_shift_details?.start_time ?? "") to \(obj.set_shift_details?.end_time ?? "")",
                    font: .semibold(.subtitle),
                    color: .gray
                )
                IBLabel (
                    text: "Address: \(obj.client_details?.business_address ?? "")",
                    font: .semibold(.subtitle),
                    color: .gray
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // More Actions
            HStack(spacing: 8) {
                Spacer()
                if obj.status == "Accept" {
                    IBLabel (
                        text: obj.working_status == "Pending" ? "Clock-in" : "Clock-In : \(obj.clock_in_time ?? "")",
                        font: .semibold(.description),
                        color: .GREEN
                    )
                    .frame(width: 120, height: 36)
                    .overlay (
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.GREEN, lineWidth: 0.5)
                    )
                    
                    IBSimpletButton(height: 36, width: 120, fgColor: .white, buttonText: "Send Message", bg: .BUTTON) {
                        print("Confirmed")
                    }
                } else {
                    
                    IBLabel (
                        text: "Pending",
                        font: .semibold(.description),
                        color: .BUTTON
                    )
                    .frame(width: 120, height: 36)
                    .overlay (
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.BUTTON, lineWidth: 0.5)
                    )
                    
                    IBSimpletButton(height: 36, width: 120, fgColor: .gray, buttonText: "Withdraw", bg: Color.gray.opacity(0.2)) {
                        viewModel.showWithReq = true
                        viewModel.companyDetail = "\(obj.client_details?.business_name ?? "") \(obj.client_details?.business_address ?? "")\n\(obj.format_date ?? "") \(obj.set_shift_details?.start_time ?? "") \(obj.set_shift_details?.end_time ?? "")"
                        viewModel.shiftiD = obj.id ?? ""
                        print("Shift id from Withdraw: \(obj.id ?? "")")
                    }
                }
            }
            //            .frame(maxWidth: .infinity, alignment: .trailing)
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
}

#Preview {
    MyBookingView()
        .environmentObject(TopBarViewModel())
}
