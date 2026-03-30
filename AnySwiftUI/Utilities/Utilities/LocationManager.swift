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
    
    private let manager = CLLocationManager()
    
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var currentAddress: String = ""
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    // 📍 GPS result
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        reverseGeocode(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error.localizedDescription)
    }
    
    // Convert lat/long → Address (your UIKit function)
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
