//
//  OfferDetail.swift
//  Any
//
//  Created by Arbaz  on 01/04/26.
//

import SwiftUI

struct OfferDetail: View {

    // ✅ Flat properties — works for both Worker (Res_ClientOffer)
    // and Client (Res_ClientBannerList) banners
    var image: String?
    var title: String?
    var descriptionText: String?
    var type: String?
    var dateTime: String?

    var body: some View {
        VStack(spacing: 24) {

            // MARK: - Top Image
            AsyncImage(url: URL(string: image ?? "")) { img in
                img
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)

            // MARK: - Card Content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {

                    // Type + Date row (only shown when present, since
                    // Res_ClientBannerList doesn't carry a `type`)
                    if type != nil || dateTime != nil {
                        HStack {
                            if let type {
                                Text(type.uppercased())
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color("BUTTON_COLOR").opacity(0.1))
                                    .foregroundColor(Color("BUTTON_COLOR"))
                                    .cornerRadius(8)
                            }

                            Spacer()

                            if let dateTime {
                                Text(dateTime)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    Text(title ?? "")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Divider()

                    Text(descriptionText ?? "")
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                }
            }
        }
        .padding(.all, 24)
        .navigationBarBackButtonHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Offer Detail")
    }
}

// MARK: - Convenience Initializers

extension OfferDetail {

    // ✅ Worker — Res_ClientOffer
    init(obj: Res_ClientOffer) {
        self.image           = obj.image
        self.title           = obj.title
        self.descriptionText = obj.description
        self.type            = obj.type
        self.dateTime        = obj.exp_date
    }

    // ✅ Client — Res_ClientBannerList
    init(obj: Res_ClientBannerList) {
        self.image           = obj.image
        self.title           = obj.title
        self.descriptionText = obj.description
        self.type            = nil
        self.dateTime        = obj.exp_date
    }
}

//#Preview {
//    OfferDetail()
//}
