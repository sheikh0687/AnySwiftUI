//
//  AddRatingView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 10/06/26.
//

import SwiftUI

struct AddRatingView: View {
    
    @State var viewModel = AddRatingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var requestID: String = ""
    var toID: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            contentSection
        }
        .navigationTitle("Add Review")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .alert("Error", isPresented: Binding(
            get: { viewModel.customError != nil },
            set: { if !$0 { viewModel.customError = nil } }
        )) {
            Button("OK") { viewModel.customError = nil }
        } message: {
            Text(viewModel.customError?.errorDescription ?? "")
        }
        .onAppear {
            viewModel.requestiD = requestID
            viewModel.ratingTo = toID
        }
    }
    
    private var contentSection: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                starRatingSection
                feedbackSection
                submitButton
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
        }
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("How would you rate this\nworker's performance")
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Text("Please give your rating & your review..")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Star Rating
    
    private var starRatingSection: some View {
        HStack(spacing: 12) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: index <= viewModel.selectedRating ? "star.fill" : "star.fill")
                    .font(.system(size: 36))
                    .foregroundColor(index <= viewModel.selectedRating ? Color(.BUTTON) : Color(.systemGray3))
                    .onTapGesture {
                        viewModel.selectedRating = index
                    }
            }
        }
    }
    
    // MARK: - Feedback
    
    private var feedbackSection: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
            
            if viewModel.feedback.isEmpty {
                Text("Enter your feedback here...")
                    .foregroundColor(Color(.systemGray3))
                    .font(.system(size: 15))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
            }
            
            TextEditor(text: $viewModel.feedback)
                .font(.system(size: 15))
                .foregroundColor(.black)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(minHeight: 160)
        }
        .frame(minHeight: 160)
    }
    
    // MARK: - Submit Button
    
    private var submitButton: some View {
        Button {
            handleSubmit()
        } label: {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Submit")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color(.BUTTON))
            .clipShape(Capsule())   
        }
        .disabled(viewModel.isLoading)
    }
    
    // MARK: - Actions
    
    private func handleSubmit() {
        if viewModel.selectedRating == 0 {
            viewModel.customError = .customError(message: "Please select the rating")
        } else if viewModel.feedback.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            viewModel.customError = .customError(message: "Please enter the feedback")
        } else {
            Task {
                await viewModel.submitReview {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddRatingView()
}
