//
//  LocationSearchViewModel.swift
//  AnySwiftUI
//
//  Created by Arbaz  on 30/03/26.
//

import Foundation
import MapKit
internal import Combine

class LocationSearchViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    private var completer = MKLocalSearchCompleter()
    
    @Published var query = ""
    @Published var results: [MKLocalSearchCompletion] = []
    
    override init() {
        super.init()
        completer.delegate = self
    }
    
    func search(_ text: String) {
        completer.queryFragment = text
    }
    
    // Autocomplete results update
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
    }
    
    // User taps suggestion → get coordinates
    func selectLocation(_ completion: MKLocalSearchCompletion,
                        completionHandler: @escaping (CLLocationCoordinate2D, String) -> Void) {
        
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let item = response?.mapItems.first else { return }
            
            let coordinate = item.placemark.coordinate
            let address = "\(completion.title) \(completion.subtitle)"
            
            completionHandler(coordinate, address)
        }
    }
}
