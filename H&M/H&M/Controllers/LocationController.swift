//
//  LocationController.swift
//  H&M
//
//  Created by katia kutsi on 7/8/20.
//  Copyright © 2020 TBC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapKitView: MKMapView!
    
    let locations = [
        Location(lat: 41.724595, lon: 44.738870),
        Location(lat: 41.694308, lon: 44.800171),
        Location(lat: 41.689516, lon: 44.898777),
        Location(lat: 41.692714, lon: 44.895741)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServiceEnabled()
        
        addAllAnnotations(objects: locations)
        
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func checkLocationServiceEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorizationStatus()
        }
    }
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    private func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapKitView.showsUserLocation = false
        case .authorizedAlways:
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        @unknown default:
            return
        }
    }
    
    private func centerMapView() {
        let mapMeterds: Double = 25_000
        
        guard let location = locationManager.location else {return}
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: mapMeterds, longitudinalMeters: mapMeterds)
        
        mapKitView.setRegion(region, animated: true)
    }
    
    private func addAllAnnotations(objects: [Location]){
        for obj in objects{
            let lat = Double(obj.lat)
            let lng = Double(obj.lon)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly: lat)!, longitude: CLLocationDegrees(exactly: lng)!)
            annotation.title = obj.name
            self.mapKitView.addAnnotation(annotation)
        }
    }
}

extension LocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapView()
        manager.stopUpdatingLocation()
    }
}
