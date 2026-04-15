//
//  OfferDetail.swift
//  Any
//
//  Created by Arbaz  on 01/04/26.
//

import SwiftUI

struct OfferDetail: View {
    
    var obj: Res_ClientOffer
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                // MARK: Top Image
                AsyncImage(url: URL(string: obj.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()        // keep full logo visible
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 160)
                .background(Color.orange.opacity(0.08)) // fills empty space nicely
                
                // MARK: Card Content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text(obj.title ?? "")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Divider()
                        
                        Text(obj.description ?? "")
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    .padding(20)
                    .background (
                        RoundedRectangle(cornerRadius: 26)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6)
                    )
                    .padding(.horizontal)
                }
//                .padding(.top, -30) // 👈 pulls card slightly over the image
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle("Offer Detail", displayMode: .inline)
    }
}

//#Preview {
//    OfferDetail()
//}
