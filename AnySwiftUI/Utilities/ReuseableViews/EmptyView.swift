//
//  EmptyView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 26/03/26.
//

import SwiftUI

struct EmptyView: View {
    
    var title: String
    var subtitle: String
    var img: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: img)
                .font(.system(size: 54))
                .foregroundColor(Color(.darkGray))
            
//            Text("No Transaction Yet")
//                .font(.customfont(.medium, fontSize: 18))
//                .foregroundColor(.black)
            IBLabel (
                text: title,
                font: .medium(.largeTitle),
                color: .black
            )
            
//            Text("After your first transaction, you will be able to see here.")
//                .font(.customfont(.regular, fontSize: 14))
//                .foregroundColor(.gray)
//                .multilineTextAlignment(.center)
            
            IBLabel (
                text: subtitle,
                font: .regular(.subtitle),
                color: .gray
            )
            .multilineTextAlignment(.center)

        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    EmptyView(title: "No Data", subtitle: "Please find later!", img: "tray")
}
