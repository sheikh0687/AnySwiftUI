//
//  NotificationView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 12/06/26.
//

import SwiftUI

struct NotificationView: View {
    
    @State var viewModel = NotificationViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 24) {
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView("Loading Notification...")
                            .frame(maxWidth: .infinity)
                    } else if viewModel.arrayNotificationList.isEmpty {
                        EmptyView (
                            title: "",
                            subtitle: "No notification are there",
                            img: ""
                        )
                    } else {
                        ForEach(viewModel.arrayNotificationList, id: \.id) { notification in
                            NotificationCard(obj: notification)
                        }
                    }
                }
            }
            .padding(.all, 24)
        }
        .navigationTitle("Notification")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .task {
            await loadNotification()
        }
        .alert(item: $viewModel.customError) { error in
            Alert (
                title: Text(appName),
                message: Text(error.localizedDescription),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
    
    func loadNotification() async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.fetchNotificationList()
            if response.status == "1" {
                viewModel.arrayNotificationList = response.result ?? []
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

struct NotificationCard: View {
    
    let obj: Res_NotificationList
    
    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                IBLabel (
                    text: obj.message ?? "",
                    font: .medium(.title),
                    color: .primary
                )
                
                HStack {
                    Spacer()
                    IBLabel (
                        text: obj.date_time ?? "",
                        font: .regular(.description),
                        color: .gray
                    )
                }
            }
        }
        .padding()
        .background (
            RoundedRectangle(cornerRadius: 16)
             .fill(Color.white)
        )
        .overlay (
            RoundedRectangle(cornerRadius: 16)
                .stroke (Color.black.opacity(0.06),
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
    NotificationView()
}
