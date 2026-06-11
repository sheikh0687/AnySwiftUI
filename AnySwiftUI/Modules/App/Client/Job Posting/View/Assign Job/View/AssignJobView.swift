//
//  AssignJobView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 06/05/26.
//

import SwiftUI

struct AssignJobView: View {
    
    @EnvironmentObject var appState: AppState
    @State var viewModel: AssignJobViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(spacing: 24) {
                
                IBLabel (
                    text: "Choose amoung your previous workers",
                    font: .semibold(.title),
                    color: .BLACK
                )
                
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView("Loading workers...")
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else if viewModel.previousWorkers.isEmpty {
                        EmptyView (
                            title: "",
                            subtitle: "No previous workers are there!",
                            img: ""
                        )
                    } else {
                        ForEach(viewModel.previousWorkers, id: \.id) { worker in
                            PreviousWorkerList (
                                obj: worker,
                                isSelected: viewModel.selectedWorkerIDs.contains(worker.id ?? ""),
                                onToggle: {
                                    viewModel.toggleSelection(workerID: worker.id ?? "")
                                }
                            )
                        }
                    }
                }
                
                IBSubmitButton(buttonText: "Publish Job Post") {
                    Task {
                        await handleAssignWorkers()
                    }
                }
            }
            .padding(.all, 16)
        }
        .task {
            await loadWorker()
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("Publish Job Post")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showSuccessSheet) {
            JobPostSuccessView(onBackToDashboard: {
                viewModel.showSuccessSheet = false
                appState.isLoggedIn = true
            }, onViewPostedJob: {
                // Action blank as requested
                viewModel.showSuccessSheet = false
                viewModel.viewJobPost = true
            })
        }
        .navigationDestination(isPresented: $viewModel.viewJobPost) {
            CurrentShiftView()
        }
    }
    
    func handleAssignWorkers() async {
        viewModel.isLoading = true
        defer { viewModel.isLoading = false }
        
        do {
            let response = try await viewModel.assignWorkers()
            if response.status == "1" {
                viewModel.showSuccessSheet = true
            } else {
                viewModel.customError = .customError(message: response.message ?? "Failed to assign workers")
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
    
    func loadWorker() async {
        
        viewModel.isLoading = true
        
        defer { viewModel.isLoading = false }
        
        do {
            let response = try await viewModel.fetchPreviousWorkers()
            if response.status == "1" {
                viewModel.previousWorkers = response.result ?? []
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

struct PreviousWorkerList: View {
    
    var obj: Res_PreviousWorkers
    var isSelected: Bool
    var onToggle: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                onToggle()
            }
        }) {
             HStack(spacing: 14) {
                
                // MARK: Profile Image
                AsyncImage(url: URL(string: obj.image ?? "")) { phase in
                    switch phase {
                    case .success(let img):
                        img.resizable().scaledToFill()
                    default:
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(width: 56, height: 56)
                .clipShape(Circle())
                .overlay (
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(radius: 2)
                
                // MARK: Name + Job
                VStack(alignment: .leading, spacing: 6) {
                    Text("\(obj.first_name ?? "") \(obj.last_name ?? "")")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)

                    HStack(spacing: 6) {
                        Image(systemName: "briefcase.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)

                        Text(obj.job_type_name ?? "")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                
                // MARK: Selection Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.THEME.opacity(0.15) : Color.gray.opacity(0.12))
                        .frame(width: 34, height: 34)

                    Image(systemName: isSelected ? "checkmark" : "")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.THEME)
                }
            }
            .padding()
            .background (
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.THEME.opacity(0.08) : Color.white)
            )
            .overlay (
                RoundedRectangle(cornerRadius: 16)
                    .stroke (
                        isSelected ? Color.THEME.opacity(0.4) : Color.black.opacity(0.06),
                        lineWidth: 1
                    )
            )
            .shadow (
                color: Color.black.opacity(isSelected ? 0.08 : 0.05),
                radius: isSelected ? 10 : 6,
                x: 0,
                y: 4
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

struct JobPostSuccessView: View {
    
    @Environment(\.dismiss) var dismiss
    var onBackToDashboard: () -> Void
    var onViewPostedJob: () -> Void
    
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient (
                colors: [Color.green.opacity(0.08), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // MARK: Success Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.green, Color.green.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 130, height: 130)
                        .shadow(color: .green.opacity(0.4), radius: 25, x: 0, y: 15)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(animate ? 1 : 0.6)
                .opacity(animate ? 1 : 0)
                
                // MARK: Title
                Text("Job Posted")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 28)
                    .opacity(animate ? 1 : 0)
                
                // MARK: Subtitle
                Text("Your job is now live and visible to candidates.\nYou can track applicants anytime.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 6)
                    .opacity(animate ? 1 : 0)
                
                Spacer()
                
                // MARK: Buttons
                VStack(spacing: 14) {
                    
                    // Primary button
                    Button(action: onViewPostedJob) {
                        Text("View Posted Job")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background (
                                LinearGradient (
                                    colors: [Color.BUTTON, Color.BUTTON.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .BUTTON.opacity(0.3), radius: 12, x: 0, y: 8)
                    }
                    
                    // Secondary button
                    Button(action: onBackToDashboard) {
                        Text("Back to Dashboard")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.BUTTON)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.BUTTON.opacity(0.1))
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animate = true
            }
        }
    }
}
