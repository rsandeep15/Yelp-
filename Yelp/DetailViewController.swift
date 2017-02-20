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
    // All UI elements
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
        
        // Set all labels with values in business model object
        nameLabel.text = business.name
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        if business!.imageURL != nil {
            thumbnail.layer.cornerRadius = 4
            thumbnail.clipsToBounds = true
            thumbnail.setImageWith(business!.imageURL!)
        }
        ratingsView.setImageWith(business!.ratingImageURL!)
        addressLabel.text = business.address
        cuisineLabel.text = business.categories
        reviewCountLabel.text = "\(business.reviewCount!) Reviews"
        distanceLabel.text = business.distance
        
        // Create a map with marker at the business
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
}
