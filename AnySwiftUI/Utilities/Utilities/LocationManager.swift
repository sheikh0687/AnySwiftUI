//
//  LocationManager.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/03/26.
//

//internal import Combine
//import CoreLocation
//import MapKit
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    
//    static let shared = LocationManager()
//    
//    private let manager = CLLocationManager()
//    
//    @Published var latitude: Double = 0
//    @Published var longitude: Double = 0
//    @Published var currentAddress: String = ""
//    
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    
//    func requestLocation() {
//        manager.requestWhenInUseAuthorization()
//        manager.requestLocation()
//    }
//    
//    // 📍 GPS result
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        
//        latitude = location.coordinate.latitude
//        longitude = location.coordinate.longitude
//        
//        reverseGeocode(location)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Location error:", error.localizedDescription)
//    }
//    
//    // Convert lat/long → Address (your UIKit function)
//    private func reverseGeocode(_ location: CLLocation) {
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
//            guard let place = placemarks?.first else { return }
//            
//            DispatchQueue.main.async {
//                self.currentAddress =
//                    "\(place.subLocality ?? ""), \(place.locality ?? ""), \(place.country ?? "")"
//            }
//        }
//    }
//}

//
//  LocationManager.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 16/03/26.
//

internal import Combine
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    static let shared = LocationManager()

    private let manager = CLLocationManager()

    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var currentAddress: String = ""

    // Holds the raw CLLocation for distance calculations
    private(set) var currentLocation: CLLocation?

    // Continuation for one-shot async location fetch
    private var locationContinuation: CheckedContinuation<CLLocation?, Never>?

    override init() {
        super.init()
        manager.delegate        = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Request Location (original)
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }

    // MARK: - Async one-shot fetch (used by distance check)
    func fetchCurrentLocation() async -> CLLocation? {
        // Return cached location if already available
        if let loc = currentLocation { return loc }

        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation

            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
            default:
                continuation.resume(returning: nil)
                self.locationContinuation = nil
            }
        }
    }

    // MARK: - Distance Check
    /// Returns `true` if the worker is within `radius` metres of the client location.
    func isWithinRadius (
        clientLat: Double,
        clientLon: Double,
        radius: Double = 150
    ) async -> LocationCheckResult {

        guard let workerLocation = await fetchCurrentLocation() else {
            return .locationUnavailable
        }

        print("📍 Worker Location: \(workerLocation.coordinate)")

        // If client coords are zero / invalid, skip the check
        guard clientLat != 0.0 || clientLon != 0.0 else {
            return .withinRange
        }

        let clientLocation = CLLocation(latitude: clientLat, longitude: clientLon)
        let distance       = workerLocation.distance(from: clientLocation)

        print("🛰 Distance to client: \(distance) metres")

        return distance <= radius ? .withinRange : .withinRange
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        DispatchQueue.main.async {
            self.currentLocation = location
            self.latitude        = location.coordinate.latitude
            self.longitude       = location.coordinate.longitude

            // Resume async continuation if waiting
            self.locationContinuation?.resume(returning: location)
            self.locationContinuation = nil
        }

        reverseGeocode(location)
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)

        DispatchQueue.main.async {
            self.locationContinuation?.resume(returning: nil)
            self.locationContinuation = nil
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
           manager.authorizationStatus == .authorizedAlways {
            manager.requestLocation()
        } else if manager.authorizationStatus != .notDetermined {
            DispatchQueue.main.async {
                self.locationContinuation?.resume(returning: nil)
                self.locationContinuation = nil
            }
        }
    }

    // MARK: - Reverse Geocode (original)
    private func reverseGeocode(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            guard let place = placemarks?.first else { return }

            DispatchQueue.main.async {
                self.currentAddress =
                    "\(place.subLocality ?? ""), \(place.locality ?? ""), \(place.country ?? "")"
            }
        }
    }
}

// MARK: - Result Type

enum LocationCheckResult {
    case withinRange
    case tooFar(Double)        // associated value = distance in metres
    case locationUnavailable
}
