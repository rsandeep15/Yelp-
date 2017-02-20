//
//  DetailViewController.swift
//  Yelp
//
//  Created by Sandeep Raghunandhan on 2/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var ratingsView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    var business : Business!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = business.name
        if business!.imageURL != nil {
            thumbnail.setImageWith(business!.imageURL!)
        }
        ratingsView.setImageWith(business!.ratingImageURL!)
        addressLabel.text = business.address
        cuisineLabel.text = business.categories
        reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        distanceLabel.text = business.distance
        
        if let coordinateLat = business.latitude! as Double?, let coordinateLong = business.longitude! as Double? {
            // Map View Setup
            let camera = GMSCameraPosition.camera(withLatitude: coordinateLat, longitude: coordinateLong, zoom: 14.0)
            mapView.camera = camera
            let position = CLLocationCoordinate2D(latitude: coordinateLat, longitude: coordinateLong)
            let marker = GMSMarker(position: position)
            marker.title = business.name
            marker.map = mapView
            mapView.isMyLocationEnabled = true
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
