//
//  OutletSelectorView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 20/04/26.
//

import SwiftUI

struct OutletSelectorView: View {
    
    let selectedOutlet: Res_ClientOutlet?
    let outlets: [Res_ClientOutlet]
    @Binding var showDropDown: Bool
    let onSelectOutlet: (Res_ClientOutlet) -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            selectorRow
            if showDropDown {
                dropdownList
                    .offset(y: 68)
                    .zIndex(999)
            }
        }
        .zIndex(showDropDown ? 999 : 0)
    }

    // MARK: - Selector Row

    var selectorRow: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                showDropDown.toggle()
            }
        }) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: selectedOutlet?.business_logo ?? "")) { phase in
                    switch phase {
                    case .success(let img): img.resizable().scaledToFill()
                    default: Image(systemName: "building.2").resizable().scaledToFit().foregroundColor(.gray)
                    }
                }
                .frame(width: 44, height: 44)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedOutlet?.business_name ?? "")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(outlets.count > 1
                         ? "Select To Change Outlet"
                         : "Add More Outlet(s) In Settings")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.down")
                    .foregroundColor(.secondary)
                    .rotationEffect(.degrees(showDropDown ? 180 : 0))
                    .animation(.easeInOut, value: showDropDown)
            }
            .padding(12)
            .background (
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
            )
            .overlay (
                RoundedRectangle(cornerRadius: 12)
                    .stroke (
                        Color.black.opacity(0.06),
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
        .buttonStyle(.plain)
    }

    // MARK: - Dropdown List

    var dropdownList: some View {
        VStack(spacing: 0) {
            ForEach(outlets, id: \.id) { outlet in
                Button(action: { onSelectOutlet(outlet) }) {
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: outlet.business_logo ?? "")) { phase in
                            switch phase {
                            case .success(let img): img.resizable().scaledToFill()
                            default: Image(systemName: "building.2").resizable().scaledToFit().foregroundColor(.gray)
                            }
                        }
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text(outlet.business_name ?? "")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.primary)
                            Text("Select to change outlet")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if let count = outlet.complete_shift_count, count > 0 {
                            Text("\(count)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color.orange)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)

                if outlet.id != outlets.last?.id {
                    Divider().padding(.leading, 68)
                }
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}
