
//
//  AddOutletView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 04/06/26.
//

import SwiftUI

struct OutletListView: View {
    
    @State var viewModel = OutletViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                
                IBSubmitButton(buttonText: "Add Outlet") {
                    viewModel.conToAdd = true
                }
                
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else if viewModel.outlets.isEmpty {
                        EmptyView(title: "", subtitle: "No Outlet at the moment", img: "")
                    } else {
                        ForEach(viewModel.outlets, id: \.id) { outlet in
                            OutletCard(obj: outlet) {
                                print("Update the outlet details")
                                viewModel.outletiD = outlet.id ?? ""
                                viewModel.outletName = outlet.business_name ?? ""
                                viewModel.outletAddress = outlet.business_address ?? ""
                                viewModel.outletLatitude = outlet.lat ?? ""
                                viewModel.outletLongitude = outlet.lon ?? ""
                                viewModel.outletLogoUrl = outlet.business_logo ?? ""
                                viewModel.conToUpdate = true
                            } onDelete: {
                                print("Delete the outlet")
                                viewModel.outletiD = outlet.id ?? ""
                                Task {
                                    await callToDeleteOutlet()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.all)
            
            SimpleToastView (
                message: "Outlet deleted successfully",
                isPresented: viewModel.informUser,
                colorss: .red.opacity(0.8)
            )
        }
        .task {
           await loadOutlets()
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("My Outlets")
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Ok"))
            )
        }
        .navigationDestination(isPresented: $viewModel.conToAdd) {
            AddUpdateOutletView (
                viewModel: .init (
                outletiD: "",
                outletName: "",
                outletAddress: "",
                outletLat: 0,
                outletLon: 0,
                outletLogoUrl: "",
                isFor: "Add"
                )
            )
        }
        .navigationDestination(isPresented: $viewModel.conToUpdate) {
            AddUpdateOutletView (
                viewModel: .init (
                    outletiD: viewModel.outletiD,
                    outletName: viewModel.outletName,
                    outletAddress: viewModel.outletAddress,
                    outletLat: Double(viewModel.outletLatitude) ?? 0.0,
                    outletLon: Double(viewModel.outletLongitude) ?? 0.0,
                    outletLogoUrl: viewModel.outletLogoUrl,
                    isFor: "Update"
                )
            )
        }
        .onChange(of: viewModel.gotResponse) {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.informUser = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.informUser = false
                }
                
                Task {
                    await loadOutlets()
                }
            }
        }
    }
    
    func loadOutlets() async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.fetchOutlets()
            if response.status == "1" {
                viewModel.outlets = response.result ?? []
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    func callToDeleteOutlet() async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.deleteOutlet()
            if response.status == "1" {
                viewModel.gotResponse = true
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

struct OutletCard: View {
    
    let obj: Res_ClientOutlet?
    var onUpdate: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            
            // MARK: - ICON
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.systemGray5))
                    .frame(width: 62, height: 62)
                    .clipShape(.circle)
                
                if let imageUrl = URL(string: obj?.business_logo ?? "") {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                }
            }
            
            // MARK: - TEXT
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    
                    IBLabel (
                        text: obj?.business_name ?? "",
                        font: .semibold(.title),
                        color: .BLACK
                    )
                    .lineLimit(1)
                    
                    IBLabel (
                        text: "Address: \(obj?.business_address ?? "")",
                        font: .medium(.description),
                        color: .gray
                    )
                    .lineLimit(2)
                }
                
                Spacer()
                
                Menu {
                    Button { onUpdate() } label: {
                        Label("Update", systemImage: "pencil")
                    }
                    Button(role: .destructive) { onDelete() } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .rotationEffect(.degrees(90)) // ✅ Makes it vertical
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
            }
        }
        .padding()
        .background (
            RoundedRectangle(cornerRadius: 22)
                .fill(Color(.systemGray6))
        )
        .overlay (
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow (
            color: Color.black.opacity(0.06),
            radius: 10,
            x: 0,
            y: 5
        )
        .contentShape(Rectangle())
    }
}

#Preview {
    OutletListView()
}
