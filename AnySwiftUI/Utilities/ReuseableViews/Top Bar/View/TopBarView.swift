//
//  TopBarView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 17/03/26.
//

import SwiftUI

struct TopBarView: View {
    
    @ObservedObject var viewModel: TopBarViewModel
    
    var body: some View {
        ZStack {
            
            // MARK: - Center Content (Attendance)
            if viewModel.showAttendance {
                VStack(spacing: 4) {
                    
                    IBLabel (
                        text: "Your attendance rate: \(viewModel.attendanceRate)",
                        font: .medium(.subtitle),
                        color: .black
                    )
                    
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        
                        IBLabel(
                            text: "\(viewModel.review) ( \(viewModel.ratingCount) Reviews )",
                            font: .medium(.description),
                            color: .black
                        )
                        
                        Button {
                            viewModel.onSeeAllTap?()
                        } label: {
                            IBLabel(
                                text: "See All",
                                font: .medium(.description),
                                color: .orange
                            )
                        }
                    }
                }
            }
            
            // MARK: - Left + Right Content
            HStack {
                
                // Left: Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 30)
                
                Spacer()
                
                // Right: Icons
                HStack(spacing: 10) {
                    
                    badgeIcon(
                        image: "bubble.left.fill",
                        count: viewModel.chatCount
                    ) {
                        viewModel.onChatTap?()
                    }
                    
                    badgeIcon (
                        image: "bell.fill",
                        count: viewModel.notificationCount
                    ) {
                        viewModel.onNotificationTap?()
                    }
                    
                    if viewModel.showMenu {
                        Button {
                            viewModel.onMenuTap?()
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.white)
    }
    
    func badgeIcon(image: String, count: Int, action: @escaping () -> Void) -> some View {
        
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                
                Image(systemName: image)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .frame(minWidth: 16, minHeight: 16)
                        .background(Color.red)
                        .cornerRadius(4) // 👈 square badge like screenshot
                        .offset(x: 10, y: -8)
                }
            }
        }
    }
}

#Preview {
    TopBarView(viewModel: .init())
}
