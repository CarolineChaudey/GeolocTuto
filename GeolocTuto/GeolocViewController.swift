//
//  GeolocViewController.swift
//  GeolocTuto
//
//  Created by etudiant on 13/11/2017.
//  Copyright © 2017 etudiant. All rights reserved.
//

import UIKit
import CoreLocation

class GeolocViewController: UIViewController {

    @IBOutlet weak var gpsLocation: UILabel!
    
    public lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    public lazy var geocoder: CLGeocoder = {
        return CLGeocoder()
    }()
    
    @IBAction func touchReloadGPS() {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
        }
    }

}

extension GeolocViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let last = locations.last else {
            return
        }
        self.geocoder.cancelGeocode()
        self.geocoder.reverseGeocodeLocation(last) { (placemarks, err) in
            guard err == nil, let res = placemarks?.first else {
                return
            }
            guard let street = res.name,
                let city = res.subAdministrativeArea,
                let postalCode = res.postalCode,
                let country = res.country else {
                    return
            }
            self.gpsLocation.text = "\(street) \(city) \(postalCode) \(country)"
        }
    }
}
