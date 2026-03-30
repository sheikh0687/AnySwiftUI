//
//  Image.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 26/03/26.
//

import SwiftUI
import SDWebImageSwiftUI

struct CustomWebImage: View {
    let imageUrl: String?
    let placeholder: Image
    let width: CGFloat?
    let height: CGFloat?
    
    var body: some View {
        if let urlString = imageUrl,
           let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrlString) {
            if Router.BASE_IMAGE_URL != urlString {
                SDWebImageSwiftUI.WebImage(url: url)
                    .resizable()
                    .indicator(.activity)
                    .frame(width: width, height: height)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .clipped()
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .clipped()
            }
        } else {
            placeholder
                .resizable()
                .scaledToFit()
                .clipped()
        }
    }
}

//#Preview {
//    CustomWebImage()
//}
