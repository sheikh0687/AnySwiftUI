//
//  LocationPickerViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 02/06/26.
//

import SwiftUI
internal import Combine
import MapKit
import CoreLocation

@MainActor
final class LocationPickerViewModel: NSObject, ObservableObject {

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 22.9734, longitude: 78.6569),
        span:   MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @Published var address      = ""
    @Published var searchText   = ""
    @Published var predictions  = [MKLocalSearchCompletion]()
    @Published var isGeocoding  = false
    @Published var isSearching  = false
    @Published var isDragging   = false

    // ── NEW: only true when the user is physically typing in the search bar
    @Published var isUserTyping = false

    private let locationManager = CLLocationManager()
    private let completer       = MKLocalSearchCompleter()
    private var geocodeTask:  Task<Void, Never>?
    private var lastConfirmed = ""
    private var isReverseGeocoding = false

    override init() {
        super.init()
        locationManager.delegate = self
        completer.delegate        = self
        completer.resultTypes     = .address
    }

    // ── Location ──────────────────────────────────────────────────────

    func fetchCurrentLocation() {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }

    // ── Reverse geocode ───────────────────────────────────────────────

    func reverseGeocode(_ coordinate: CLLocationCoordinate2D) {
        geocodeTask?.cancel()
        geocodeTask = Task {
            isGeocoding = true
            defer { isGeocoding = false }

            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude,
                                      longitude: coordinate.longitude)
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(location)
                guard !Task.isCancelled, let pm = placemarks.first else { return }
                let parts: [String?] = [pm.name, pm.thoroughfare,
                                        pm.locality, pm.administrativeArea]
                let formatted = parts
                    .compactMap { $0 }
                    .filter { !$0.isEmpty }
                    .uniqued()
                    .joined(separator: ", ")
                address       = formatted
                lastConfirmed = formatted

                // Update searchText WITHOUT triggering predictions
                isReverseGeocoding = true
                searchText = formatted
                isReverseGeocoding = false
            } catch {
                if !lastConfirmed.isEmpty { address = lastConfirmed }
            }
        }
    }

    // ── Map drag callbacks ────────────────────────────────────────────

    func onDragStart() {
        isDragging  = true
        isUserTyping = false   // ← user stopped typing; hide predictions
        predictions = []
        address     = "Moving…"
    }

    func onDragEnd(_ center: CLLocationCoordinate2D) {
        isDragging   = false
        isUserTyping = false   // ← ensure predictions stay hidden after drag
        predictions  = []
        isReverseGeocoding = true
        searchText = ""
        isReverseGeocoding = false
        reverseGeocode(center)
    }

    // ── Search ────────────────────────────────────────────────────────

    /// Call this ONLY from the TextField's onChange — not internally.
    func onSearchTextChanged(_ text: String) {
        guard !isReverseGeocoding else { return }

        // Only search when the user is actively typing
        guard isUserTyping else { return }

        if text.isEmpty {
            predictions = []
            isSearching = false
            return
        }
        isSearching = true
        completer.queryFragment = text
    }

    /// Call this from TextField's onEditingChanged(true) or .focused binding.
    func userDidBeginTyping() {
        isUserTyping = true
    }

    func clearSearch() {
        isUserTyping = false
        searchText   = ""
        predictions  = []
    }

    func selectPrediction(_ item: MKLocalSearchCompletion) {
        predictions  = []
        isUserTyping = false   // ← done typing; hide predictions after selection

        isReverseGeocoding = true
        searchText = item.title + (item.subtitle.isEmpty ? "" : ", " + item.subtitle)
        address    = searchText
        isReverseGeocoding = false

        let request = MKLocalSearch.Request(completion: item)
        Task {
            let search = MKLocalSearch(request: request)
            if let response = try? await search.start(),
               let mapItem  = response.mapItems.first {
                let coord = mapItem.placemark.coordinate
                withAnimation(.easeInOut(duration: 0.5)) {
                    region = MKCoordinateRegion(
                        center: coord,
                        span:   MKCoordinateSpan(latitudeDelta: 0.005,
                                                 longitudeDelta: 0.005)
                    )
                }
                reverseGeocode(coord)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationPickerViewModel: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager,
                                     didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        Task { @MainActor in
            let coord = loc.coordinate
            withAnimation(.easeInOut(duration: 0.5)) {
                region = MKCoordinateRegion(
                    center: coord,
                    span: MKCoordinateSpan(latitudeDelta: 0.005,
                                           longitudeDelta: 0.005)
                )
            }
            reverseGeocode(coord)
        }
    }
    nonisolated func locationManager(_ manager: CLLocationManager,
                                     didFailWithError error: Error) {
        print("Location error: \(error)")
    }
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            let s = manager.authorizationStatus
            if s == .authorizedWhenInUse || s == .authorizedAlways {
                manager.requestLocation()
            }
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationPickerViewModel: MKLocalSearchCompleterDelegate {
    nonisolated func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { @MainActor in
            // Only publish results if the user is actively typing
            guard isUserTyping else { return }
            predictions = Array(completer.results.prefix(6))
            isSearching = false
        }
    }
    nonisolated func completer(_ completer: MKLocalSearchCompleter,
                               didFailWithError error: Error) {
        Task { @MainActor in isSearching = false }
    }
}
