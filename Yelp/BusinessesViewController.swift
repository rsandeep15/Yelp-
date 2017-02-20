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
    
    @IBOutlet weak var resultsMap: UIBarButtonItem!
    
    var loadingMoreview:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreview = InfiniteScrollActivityView(frame: frame)
        loadingMoreview!.isHidden = true
        loadingMoreview?.tintColor = UIColor.red
        tableView.addSubview(loadingMoreview!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        // Setup the table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        
        // Add a search bar to the table
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        // Allow the app to get the user's location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLLocationAccuracyHundredMeters
    
        // Update location every time user moves 100 meters
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        
    }

    
    // Get an initial listing of businesses as restaurants near the user
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
    
    // Set the number of rows in the table to be equal to the number of matching businesses
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
        YelpClient.sharedInstance.offset = businesses!.count
        Business.searchWithTerm(term: (searchBar.text != nil) ? searchBar.text! : "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.isMoreDataLoading = false
            if (self.businesses != nil) {
                self.businesses! += businesses!
            }
            else {
                self.businesses = businesses
            }
            // Stop the loading indicator
            self.loadingMoreview!.stopAnimating()
            
            // Refresh the table
            self.tableView.reloadData()
        });

    }
    
    // Get search results based on input to search bar
    func doSearch() {
        // If the search bar is empty, simply return restaurants
        if (searchBar.text?.isEmpty)!{
            Business.searchWithTerm(term: "Restaurants") { (businesses: [Business]?, error: Error?) -> Void in
                self.isMoreDataLoading = false
                self.businesses = businesses
                self.tableView.reloadData()
            }  

        }
            
        // Otherwise, load up businesses
        else {
            Business.searchWithTerm(term: searchBar.text!, completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.isMoreDataLoading = false
                self.businesses = businesses
                self.tableView.reloadData()
            });
        }

    }

    // Perform the search when the search bar's text is changed
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
                    // Update position of the loadingMoreView, and start loading indicator
                    let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                    loadingMoreview?.frame = frame
                    loadingMoreview!.startAnimating()
                    
                    // Code to load more data
                    isMoreDataLoading = true
                    fetchMoreResults()
                }
                
            }
        }
    }
    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if (segue.identifier == "viewMap"){
            let mapViewController = segue.destination as! MapViewController
            mapViewController.businesses = businesses;
        }
        if (segue.identifier == "detailedView"){
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
            let cell = sender as! BusinessCell
            let indexPath = tableView.indexPath(for: cell)
            let business = businesses![(indexPath?.row)!]
            
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.business = business
        }
     }

    
}
