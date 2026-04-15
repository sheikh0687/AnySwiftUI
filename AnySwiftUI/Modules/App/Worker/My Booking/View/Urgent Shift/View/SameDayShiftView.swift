//
//  SameDayShiftView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 14/04/26.
//

import SwiftUI
internal import Combine

struct SameDayShiftView: View {
    
    @StateObject var viewModel = SameDayShiftViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                
                IBLabel (
                    text: "Same Day Request",
                    font: .semibold(.largeTitle),
                    color: .BLACK
                )
                
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView("Loading shift...")
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if viewModel.arrayOfSameDayShift.isEmpty {
                        EmptyView (
                            title: "",
                            subtitle: "No request at the moment",
                            img: ""
                        )
                    } else {
                        LazyVStack(spacing: 18) {
                            ForEach(viewModel.arrayOfSameDayShift, id: \.id) { booking in
                                UrgentBookingRow (
                                    booking: booking) {
                                        viewModel.activeAlert = .confirmAccept(booking)
                                    } onDecline: {
                                        viewModel.activeAlert = .confirmDecline(booking)
                                    }
                            }
                        }
                    }
                }
            }
            .padding(.all, 24)
        }
        .task {
            await loadSameDayShift()
        }
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Urgent Booking")
        .alert(item: $viewModel.activeAlert) { alert in
            buildAlert(for: alert)
        }
    }
    
    private func buildAlert(for alert: SameDayAlert) -> Alert {
        switch alert {
 
        // ── Confirm Accept ──────────────────────────────────────────────
        case .confirmAccept(let booking):
            return Alert (
                title: Text("Same Day Job Request?"),
                message: Text (
                    "\(booking.client_details?.business_name ?? ""), \(booking.address ?? "")\n\n" +
                    "\(booking.currency_symbol ?? "")\(booking.shift_rate ?? "")/Hour\n" +
                    "Break: \(booking.break_type ?? "")\nMeals: \(booking.meals ?? "")\n" +
                    "\(booking.job_type ?? "")\n\(booking.note ?? "")"
                ),
                primaryButton: .default(Text("Accept")) {
                    Task { await handleAccept(booking) }
                },
                secondaryButton: .cancel()
            )
 
        // ── Confirm Decline ─────────────────────────────────────────────
        case .confirmDecline(let booking):
            let shiftTime = "\(booking.start_time ?? "") to \(booking.end_time ?? "")"
            return Alert (
                title: Text("Decline Shift?"),
                message: Text(
                    "\(booking.client_details?.business_name ?? ""), \(booking.address ?? "")\n" +
                    "\(booking.day_name ?? ""), \(shiftTime)"
                ),
                primaryButton: .destructive(Text("Decline")) {
                    Task { await handleDecline(booking) }
                },
                secondaryButton: .cancel()
            )
 
        // ── Accept Success ──────────────────────────────────────────────
        case .acceptSuccess(let booking):
            return Alert (
                title: Text("Shift Confirmed ✓"),
                message: Text(
                    "Your shift will start at (\(booking.start_time ?? "")) today at:\n\n" +
                    "\(booking.client_details?.business_name ?? ""), \(booking.address ?? "")\n" +
                    "\(booking.currency_symbol ?? "")\(booking.shift_rate ?? "")/Hour\n\n" +
                    "\(booking.job_type ?? "")\n\(booking.note ?? "")"
                ),
                dismissButton: .default(Text("OK")) {
                    Task { await loadSameDayShift() }
                }
            )
 
        // ── Decline Success ─────────────────────────────────────────────
        case .declineSuccess(let booking):
            let shiftTime = "\(booking.start_time ?? "") to \(booking.end_time ?? "")"
            return Alert (
                title: Text("Shift Cancelled"),
                message: Text(
                    "Your shift has been successfully cancelled in:\n\n" +
                    "\(booking.client_details?.business_name ?? ""), \(booking.address ?? "")\n" +
                    "\(booking.day_name ?? ""), \(shiftTime)"
                ),
                dismissButton: .default(Text("OK"))
            )
 
        // ── Error ───────────────────────────────────────────────────────
        case .error(let message):
            return Alert (
                title: Text("Error"),
                message: Text(message),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    func loadSameDayShift() async {
        viewModel.isLoading = true
        
        defer { viewModel.isLoading = false }
        
        do {
            let response = try await viewModel.fetchSameDayShift()
            if response.status == "1" {
                viewModel.arrayOfSameDayShift = response.result ?? []
            } else {
                viewModel.arrayOfSameDayShift = []
                
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    func handleAccept(_ booking: Res_UrgentShift) async {
        viewModel.isLoading = true
        
        defer { viewModel.isLoading = false }
        
        do {
            let response = try await viewModel.acceptShift(booking)
            if response.status == "1" {
                viewModel.activeAlert = .acceptSuccess(booking)
                // Note: list refresh happens inside acceptSuccess alert dismiss
            } else {
                viewModel.activeAlert = .error(response.message ?? "Something went wrong.")
            }
        } catch {
            viewModel.activeAlert = .error(error.localizedDescription)
        }
    }
 
    func handleDecline(_ booking: Res_UrgentShift) async {
        viewModel.isLoading = true
        defer { viewModel.isLoading = false }
        do {
            let response = try await viewModel.declineShift(shiftId: booking.id ?? "")
            if response.status == "1" {
                viewModel.arrayOfSameDayShift.removeAll { $0.id == booking.id }
                viewModel.activeAlert = .declineSuccess(booking)
            } else {
                viewModel.activeAlert = .error(response.message ?? "Something went wrong.")
            }
        } catch {
            viewModel.activeAlert = .error(error.localizedDescription)
        }
    }
}

struct UrgentBookingRow: View {
    
    let booking: Res_UrgentShift
    var onAccept: () -> Void
    var onDecline: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            
            HStack {
                
                // LEFT INFO COLUMN
                VStack(alignment: .leading, spacing: 6) {
                    
                    IBLabel (
                        text: "\(booking.client_details?.business_name ?? ""), (\(booking.start_time ?? "") - \(booking.end_time ?? ""))",
                        font: .semibold(.subtitle),
                        color: .BLACK
                    )
                    
                    IBLabel (
                        text: "Today",
                        font: .semibold(.subtitle),
                        color: .BLACK
                    )
                    
                    IBLabel (
                        text: "\(booking.currency_symbol ?? "")\(booking.shift_rate ?? "")/Hour", font: .medium(.subtitle), color: .gray
                    )
                    
                    infoRow("Job Type :", booking.job_type ?? "")
                    infoRow("Break :", booking.break_type ?? "")
                    infoRow("Meals :", booking.meals ?? "")
                    infoRow("Notes :", booking.note ?? "")
                    infoRow("Location :", booking.client_details?.business_address ?? "")
                }
                
                Divider()
                    .frame(height: 160)
                    .padding(.horizontal, 6)
                
                // RIGHT BUTTON COLUMN
                VStack(spacing: 14) {
                    Spacer()
                    Button {
                        onDecline()
                    } label: {
                        Text("Decline")
                            .foregroundColor(.black)
                            .frame(width: 120, height: 44)
                            .overlay (
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(Color.BUTTON, lineWidth: 2)
                            )
                    }
                    
                    Button {
                        onAccept()
                    } label: {
                        Text("Accept")
                            .foregroundColor(.white)
                            .frame(width: 120, height: 44)
                            .background(Color.BUTTON)
                            .clipShape(RoundedRectangle(cornerRadius: 22))
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay (
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.separator), lineWidth: 1)
        )
    }
    
    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack(alignment: .top) {
            IBLabel (
                text: title,
                font: .semibold(.subtitle),
                color: .BLACK
            )
            IBLabel (
                text: value,
                font: .medium(.subtitle),
                color: .gray
            )
        }
        .font(.subheadline)
    }
}

#Preview {
    SameDayShiftView()
}
