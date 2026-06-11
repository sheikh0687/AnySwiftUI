//
//  LocationPickerView.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 02/06/26.
//

import SwiftUI
import MapKit
import CoreLocation

struct LocationPickerView: View {
    /// Called when the user confirms a location, or nil when they dismiss.
    var onResult: ([String: Any]?) -> Void = { _ in }
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = LocationPickerViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            // ── Map ──────────────────────────────────────────────────
            MapView (
                region: $vm.region,
                onDragStart: vm.onDragStart,
                onDragEnd:   vm.onDragEnd
            )
            .ignoresSafeArea()
            
            // ── Animated centre pin ──────────────────────────────────
            CentrePinView(isLifted: vm.isDragging)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            // ── Search bar + predictions ─────────────────────────────
            VStack(spacing: 8) {
                SearchBarView (
                    text: $vm.searchText,
                    isSearching: vm.isSearching,
                    onClear: vm.clearSearch,
                    onBeginEditing: vm.userDidBeginTyping
                )
                .onChange(of: vm.searchText) { _, search in
                    vm.onSearchTextChanged(search)
                }
                
                if !vm.predictions.isEmpty {
                    PredictionListView(predictions: vm.predictions) { p in
                        vm.selectPrediction(p)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 60)
            
            // ── Close button ─────────────────────────────────────────
            HStack {
                Button {
                    dismiss()
                    onResult(nil)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding(10)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.top, 15)
        }
        // ── Bottom address card + my-location FAB ────────────────────
        .overlay(alignment: .bottomTrailing) {
            Button { vm.fetchCurrentLocation() } label: {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 200)
        }
        .overlay(alignment: .bottom) {
            BottomAddressCard (
                address:    vm.address,
                isGeocoding: vm.isGeocoding,
                isDragging:  vm.isDragging,
                onConfirm: {
                    onResult([
                        "lat":     vm.region.center.latitude,
                        "lng":     vm.region.center.longitude,
                        "address": vm.address
                    ])
                    dismiss()
                }
            )
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .onAppear { vm.fetchCurrentLocation() }
        // Present as bottom sheet that covers 95% of screen height
        .presentationDetents([.fraction(0.95)])
        .presentationDragIndicator(.hidden)
        .interactiveDismissDisabled()
    }
}

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var onDragStart: () -> Void
    var onDragEnd:   (CLLocationCoordinate2D) -> Void
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate               = context.coordinator
        map.showsUserLocation      = true
        map.showsCompass           = false
        map.showsScale             = false
        map.pointOfInterestFilter  = .excludingAll
        map.setRegion(region, animated: false)
        
        // Gesture to detect drag start
        let pan = UIPanGestureRecognizer(target: context.coordinator,
                                         action: #selector(Coordinator.handlePan(_:)))
        pan.delegate = context.coordinator
        map.addGestureRecognizer(pan)
        
        let pinch = UIPinchGestureRecognizer(target: context.coordinator,
                                             action: #selector(Coordinator.handlePinch(_:)))
        pinch.delegate = context.coordinator
        map.addGestureRecognizer(pinch)
        
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if !context.coordinator.isDragging {
            uiView.setRegion(region, animated: true)
        }
    }
    
    // ── Coordinator ───────────────────────────────────────────────────
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapView
        var isDragging = false
        
        init(_ parent: MapView) { self.parent = parent }
        
        @objc func handlePan(_ g: UIPanGestureRecognizer) {
            guard let map = g.view as? MKMapView else { return }
            switch g.state {
            case .began:
                isDragging = true
                parent.onDragStart()
            case .ended, .cancelled:
                isDragging = false
                parent.onDragEnd(map.centerCoordinate)
                DispatchQueue.main.async {
                    self.parent.region = map.region
                }
            default: break
            }
        }
        
        @objc func handlePinch(_ g: UIPinchGestureRecognizer) {
            guard let map = g.view as? MKMapView else { return }
            switch g.state {
            case .began:
                isDragging = true
                parent.onDragStart()
            case .ended, .cancelled:
                isDragging = false
                parent.onDragEnd(map.centerCoordinate)
                DispatchQueue.main.async {
                    self.parent.region = map.region
                }
            default: break
            }
        }
        
        // Allow simultaneous gesture recognition
        func gestureRecognizer(_ g: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool { true }
    }
}

// MARK: - Centre pin
struct CentrePinView: View {
    
    var isLifted: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .frame(width: isLifted ? 58 : 52, height: isLifted ? 58 : 52)
                .foregroundStyle(.red, .white)
                .offset(y: isLifted ? -18 : 0)
                .animation(.easeOut(duration: 0.3), value: isLifted)
            
            // Shadow ellipse
            Ellipse()
                .fill(Color.black.opacity(0.18))
                .frame(width: 18, height: 6)
                .scaleEffect(isLifted ? 0.3 : 1.0)
                .animation(.easeOut(duration: 0.3), value: isLifted)
            
            Spacer().frame(height: 28)
        }
    }
}

// MARK: - Search bar
struct SearchBarView: View {
    @Binding var text: String
    var isSearching: Bool
    var onClear: () -> Void
    var onBeginEditing: () -> Void
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search for a location…", text: $text)
                .font(.system(size: 15))
                .autocorrectionDisabled()
                .focused($isFocused)
                .onChange(of: isFocused) { _, focused in
                    if focused { onBeginEditing() }
                }
            
            if isSearching {
                ProgressView()
                    .scaleEffect(0.8)
            } else if !text.isEmpty {
                Button(action: onClear) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 13)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 5)
        )
    }
}

// MARK: - Prediction list
struct PredictionListView: View {
    var predictions: [MKLocalSearchCompletion]
    var onSelect: (MKLocalSearchCompletion) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(predictions.enumerated()), id: \.offset) { i, p in
                Button {
                    onSelect(p)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.secondary)
                            .frame(width: 20)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(p.title)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            if !p.subtitle.isEmpty {
                                Text(p.subtitle)
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                }
                if i < predictions.count - 1 {
                    Divider().padding(.leading, 46)
                }
            }
        }
        .background (
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        )
    }
}

// MARK: - Bottom address card
struct BottomAddressCard: View {
    var address:     String
    var isGeocoding: Bool
    var isDragging:  Bool
    var onConfirm:   () -> Void
    
    private var isDisabled: Bool { isDragging || isGeocoding }
    
    private var buttonLabel: String {
        if isDragging   { return "Move map to pick location" }
        if isGeocoding  { return "Getting address…" }
        return "Confirm Address"
    }
    
    var body: some View {
        VStack(spacing: 24) {
            // Address row
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin")
                    .font(.system(size: 26))
                    .foregroundColor(.red)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("SELECTED LOCATION")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundColor(.secondary)
                        .kerning(0.5)
                    
                    if isGeocoding {
                        ProgressView()
                            .scaleEffect(0.8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text(address.isEmpty ? "Picking location…" : address)
                            .font(.system(size: 15, weight: address == "Moving…" ? .regular : .bold))
                            .foregroundColor(address == "Moving…" ? .secondary : .primary)
                            .lineLimit(2)
                            .animation(.easeInOut(duration: 0.25), value: address)
                    }
                }
                Spacer()
            }
            
            // Confirm button
            Button(action: onConfirm) {
                Text(buttonLabel)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(isDisabled ? Color.gray.opacity(0.5) : Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .disabled(isDisabled)
            .animation(.easeInOut(duration: 0.2), value: isDisabled)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .background (
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: -5)
        )
    }
}

// MARK: - Helpers
extension Array where Element: Equatable {
    func uniqued() -> [Element] {
        var seen = [Element]()
        for e in self where !seen.contains(e) { seen.append(e) }
        return seen
    }
}

#Preview {
    LocationPickerView()
}
