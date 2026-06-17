//
//  AuthorizationVIew.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/06/26.
//

import SwiftUI

struct AuthorizationVIew: View {
    
    @State var viewModel: AuthorizationViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack {
                    if viewModel.isLoading {
                        ProgressView("Loading List...")
                            .frame(maxWidth: .infinity)
                    } else if viewModel.arrayAuthoriseList.isEmpty {
                        EmptyView(title: "", subtitle: "No Authrisers At The Moment", img: "")
                    } else {
                        ForEach(viewModel.arrayAuthoriseList, id: \.id) { list in
                            AdminListCard(obj: list) {
                                Task {
                                    await callDeleteAdmin(striD: list.id ?? "")
                                }
                            }
                        }
                    }
                }
//                .padding(.all, 16)
            }
        }
        .task {
            await loadAdminList()
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                viewModel.navToAddAdmin = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.BLACK)
                    .clipShape(.circle)
                    .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
            }
        }
        .padding(24)
        .navigationTitle(viewModel.strType == "OutletAdmin" ? "Outlet Admin" : "Authorise Approval")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .navigationDestination(isPresented: $viewModel.navToAddAdmin) {
            AddAdminView(viewModel: .init(strType: viewModel.strType))
        }
    }
    
    func loadAdminList() async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.fetchAuthoriseList()
            if response.status == "1" {
                viewModel.arrayAuthoriseList = response.result ?? []
            } else {
                viewModel.arrayAuthoriseList = []
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    func callDeleteAdmin(striD: String) async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.deleteAdminList(adminiD: striD)
            if response.status == "1" {
                Task {
                    await loadAdminList()
                }
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

struct AdminListCard: View {
    
    let obj: Res_AuthoriseList
    var onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                IBLabel (
                    text: "\(obj.first_name ?? "") \(obj.last_name ?? "")",
                    font: .medium(.title),
                    color: .black
                )
                
                IBLabel (
                    text: obj.type == "OutletAdmin"
                    ? "Outlet Admin"
                    : "Authrised Approver",
                    font: .medium(.description),
                    color: .gray
                )
            }
            
            Spacer()
            
            Menu {
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
        .padding()
        .background (
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .overlay (
            RoundedRectangle(cornerRadius: 16)
                .stroke (
                    Color.black.opacity(0.06),
                    lineWidth: 1
                )
        )
        .shadow (
            color: Color.black.opacity(0.05),
            radius: 6,
            x: 0,
            y: 4
        )
    }
}

#Preview {
    AuthorizationVIew(viewModel: .init(strType: "OutletAdmin"))
}
