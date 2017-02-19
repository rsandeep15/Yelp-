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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var business = businesses.first
        let camera = GMSCameraPosition.camera(withLatitude: Double(yelpClient.latitude)!, longitude: Double(yelpClient.longitutde)!, zoom: 5.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
