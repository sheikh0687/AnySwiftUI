//
//  SavedPaymentCardView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 05/06/26.
//

import SwiftUI

struct SavedPaymentCardView: View {
    
    @State var viewModel = SavedPaymentCardViewModel()
    @Environment(\.dismiss) var dismiss
    
    var cloCollectCard: ((String, String)) -> Void?
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                ScrollView(showsIndicators: false) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else if viewModel.arrayOfCard.isEmpty {
                        EmptyView (
                            title: "",
                            subtitle: "No saved cards at the moment",
                            img: ""
                        )
                    } else {
                        ForEach(viewModel.arrayOfCard, id: \.id) { saveCards in
                            CardView (
                                obj: saveCards
                            ) { id, customeriD in
                                print("Navigate with the values")
                                cloCollectCard((id, customeriD))
                                dismiss()
                            } cloDelete: {
                                print("Call Delete Api!!")
                            }
                        }
                    }
                }
                
                Spacer()
                
                IBSubmitButton(buttonText: "Add Card") {
                    print("Navigate to Add Cards")
                    viewModel.navToAddCard = true
                }
            }
            .padding(.all, 24)
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("Saved Cards")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadSaveCards()
        }
        .navigationDestination(isPresented: $viewModel.navToAddCard) {
            CardPaymentView()
        }
    }
    
    func loadSaveCards() async {
        viewModel.isLoading = true
        
        defer {
            viewModel.isLoading = false
        }
        
        do {
            let response = try await viewModel.fetchSavedCards()
            if response.status == "1" {
                viewModel.arrayOfCard = response.result?.data ?? []
            }
        } catch {
            viewModel.customError = .customError(message: error.localizedDescription)
        }
    }
}

struct CardView: View {
    
    let obj: Res_SavedData
    var cloSelect: (String, String) -> Void
    var cloDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            IBLabel (
                text: "\(obj.brand ?? "")  **** **** **** \(obj.last4 ?? "")",
                font: .medium(.toolBarTitle),
                color: .BLACK
            )
            
            HStack(spacing: 6) {
                Spacer()
                
                IBSimpletButton(height: 24, width: 60, fgColor: .black, buttonText: "Select", bg: .clear) {
                    cloSelect(obj.id ?? "", obj.customer ?? "")
                }
                
                IBSimpletButton(height: 24, width: 60, fgColor: .black, buttonText: "Delete", bg: .clear) {
                    cloDelete()
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

//#Preview {
//    SavedPaymentCardView()
//}
