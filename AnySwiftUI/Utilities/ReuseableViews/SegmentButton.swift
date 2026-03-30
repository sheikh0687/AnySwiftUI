//
//  SegmentButton.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 20/03/26.
//

import SwiftUI

struct SegmentItem {
    let title: String
    let count: Int
}

struct SegmentButton: View {
    
    let item: [SegmentItem]
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(item.indices, id: \.self) { index in
                segmentItem(item: item[index], index: index)
            }
        }
        .background(Color.gray.opacity(0.2))
        .clipShape(Capsule())
    }
}

extension SegmentButton {
    
    func segmentItem(item: SegmentItem, index: Int) -> some View {
        
        let isSelected = selectedIndex == index
        
        return Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                selectedIndex = index
            }
        } label: {
            HStack(spacing: 6) {
                
                Text(item.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
                
                if item.count > 0 {
                    Text("\(item.count)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? .BUTTON : Color.clear)
            .clipShape(Capsule())
        }
    }
}


//#Preview {
//    SegmentButton(item: .init(), selectedIndex: <#Binding<Int>#>)
//}
