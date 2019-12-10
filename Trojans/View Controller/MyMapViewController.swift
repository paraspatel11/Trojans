//
//  MapViewController.swift
//  Trojans
//
//  Created by Faiza Jahanzeb on 2019-12-10.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MyMapViewController: UIViewController, MKMapViewDelegate,UITableViewDataSource, UITableViewDelegate  {
    
    
    let locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: 43.655787, longitude: -79.739543)
    
    
    @IBOutlet var myName : UILabel!
    @IBOutlet var myDesc : UILabel!
    @IBOutlet var myDistance : UILabel!
    @IBOutlet var myMapView : MKMapView!
    @IBOutlet var myTableView : UITableView!
    
    var routeSteps = ["see route steps"] as NSMutableArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        self.myName.text = mainDelegate.restName
        self.myDistance.text = mainDelegate.restDist
        self.myDesc.text = mainDelegate.restDesc
        let dbLat = Double(mainDelegate.restLat)
        let dbLong = Double(mainDelegate.restLong)
        let destLocation = CLLocation(latitude: dbLat!, longitude: dbLong!)
        /*
        centerMapOnLocation(location: initialLocation)
 */
        let dropPin1 = MKPointAnnotation()
        dropPin1.coordinate = initialLocation.coordinate
        dropPin1.title = "Starting at Sheridan College"
        myMapView.addAnnotation(dropPin1)
        myMapView.selectAnnotation(dropPin1, animated: true)
 
        
        centerMapOnLocation(location: destLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = destLocation.coordinate
        dropPin.title = mainDelegate.restName
        myMapView.addAnnotation(dropPin)
        myMapView.selectAnnotation(dropPin, animated: true)
        
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark:
            MKPlacemark(coordinate:
                self.initialLocation.coordinate))
        request.destination = MKMapItem(placemark:
            MKPlacemark(coordinate: destLocation.coordinate))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        ////////////////////////////////////////
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler:
            {(response, error) in
                
                for route in response!.routes {
                    
                    let circle = MKCircle(center: self.initialLocation.coordinate, radius: 20000)
                    self.myMapView.addOverlay(circle)
                    self.myMapView.addOverlay(route.polyline, level: .aboveRoads)
                    self.myMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    
                    self.routeSteps.removeAllObjects()
                    
                    for step in route.steps{
                        self.routeSteps.add(step.instructions)
                        
                    }
                    
                    self.myTableView.reloadData()
                }
        })
        
        
        
        
        
        
    }
    

    let regionRadius: CLLocationDistance = 2000
    
    func centerMapOnLocation(location : CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        myMapView.setRegion(coordinateRegion, animated : true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3.0
            
            return renderer
        }
        else if overlay is MKCircle {
            let circleView = MKCircleRenderer(overlay: overlay)
            circleView.fillColor = .lightGray
            circleView.alpha = 0.4
            return circleView
        }
        return MKPolylineRenderer(overlay: overlay)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeSteps.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        tableCell.textLabel?.text = (routeSteps[indexPath.row] as!
            String)
        
        
        return tableCell
        
    }
}
