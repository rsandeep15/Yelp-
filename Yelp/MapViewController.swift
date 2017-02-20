//
//  MapViewController.swift
//  Yelp
//
//  Created by Sandeep Raghunandhan on 2/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    var businesses: [Business]!
    var yelpClient = YelpClient.sharedInstance
    var mapView : GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a map with markers at all business results
        let camera = GMSCameraPosition.camera(withLatitude: Double(yelpClient.latitude)!, longitude: Double(yelpClient.longitutde)!, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        for business in businesses{
            let position = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            let marker = GMSMarker(position: position)
            marker.title = business.name
            marker.map = mapView
        }
        
        // Add my current location to the map 
        mapView.isMyLocationEnabled = true
        view = mapView
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
