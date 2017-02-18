//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate, UIScrollViewDelegate{
    
    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    
    var locationManager: CLLocationManager!
    
    var isMoreDataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
    
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    func initialFetch() {
                    Business.searchWithTerm(term: "Restaurants") { (businesses: [Business]?, error: Error?) -> Void in
                        self.isMoreDataLoading = false
                        if (self.businesses != nil) {
                            self.businesses! += businesses!
                        }
                        else {
                            self.businesses = businesses
                        }
        
                        self.tableView.reloadData()
        
                    }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil{
            return businesses.count
        }
        else {
            return 0
        }
        
    }
    
    // Get the cell associated with a business from the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! BusinessCell
        cell.business = businesses[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    // Get more results of businesses matching the query to produce an infinite scroll
    func fetchMoreResults() {
        YelpClient.sharedInstance.offset = businesses.count
        Business.searchWithTerm(term: (searchBar.text != nil) ? searchBar.text! : "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.isMoreDataLoading = false
            if (self.businesses != nil) {
                self.businesses! += businesses!
            }
            else {
                self.businesses = businesses
            }
            
            self.tableView.reloadData()
        });

    }
    
    func doSearch() {
        if (searchBar.text?.isEmpty)!{
            Business.searchWithTerm(term: "Restaurants") { (businesses: [Business]?, error: Error?) -> Void in
                self.isMoreDataLoading = false
                if (self.businesses != nil) {
                    self.businesses! = businesses!
                }
                else {
                    self.businesses = businesses
                }
                
                self.tableView.reloadData()

            }  

        }
        else {
            Business.searchWithTerm(term: searchBar.text!, completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.isMoreDataLoading = false
                self.businesses = businesses
                self.tableView.reloadData()
            });
        }

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        doSearch()
    
    }
    
    // Search for restaurants near the user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let myLoc = locations.first {
            YelpClient.sharedInstance.latitude = "\(myLoc.coordinate.latitude)"
            YelpClient.sharedInstance.longitutde = "\(myLoc.coordinate.longitude)"
            print("Location:\(myLoc.coordinate.latitude), \(myLoc.coordinate.longitude)")
            initialFetch()
        }
    }
    
    // Creates an infinite scroll, that fetches new businesses when the user approaches the bottom of the feed
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading){
            // Calculate the position of one screen length before the bottom of the results
            if (!isMoreDataLoading){
                let scrollViewContentHeight = tableView.contentSize.height
                let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
                if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging){
                    isMoreDataLoading = true
                    fetchMoreResults()
                }
                
            }
        }
    }
    
    

     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        let cell = sender as! BusinessCell
        let indexPath = tableView.indexPath(for: cell)
        let business = businesses![(indexPath?.row)!]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.business = business
        
     }

    
}
