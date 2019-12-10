//
//  MapViewController.swift
//  Trojans
//
//  Created by Xcode User on 2019-12-10.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate  {
    
    let locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: 43.655787, longitude: -79739534)

    
    @IBOutlet var myName : UILabel!
    @IBOutlet var myDesc : UILabel!
    @IBOutlet var myDistance : UILabel!
    @IBOutlet var myMapView : MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        self.myName.text = mainDelegate.restName
        self.myDistance.text = mainDelegate.restDist
        self.myDesc.text = mainDelegate.restDesc
        //let dbLat = Double(mainDelegate.restLat)
        //let dbLong = Double(mainDelegate.restLong)
        
        /*
        centerMapOnLocation(location: initialLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = initialLocation.coordinate
        dropPin.title = "Starting at Sheridan College"
        self.myMapView.addAnnotation(dropPin)
        self.myMapView.selectAnnotation(dropPin, animated: true)
      */
    }
    

    let regionRadius : CLLocationDistance = 1000
    func centerMapOnLocation(location : CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        myMapView.setRegion(coordinateRegion, animated: true)
        
    }

}
