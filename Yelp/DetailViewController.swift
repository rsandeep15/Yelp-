//
//  DetailViewController.swift
//  Yelp
//
//  Created by Sandeep Raghunandhan on 2/18/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var businessName: UILabel!
    
    var business: Business!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = business.name! as String? {
            businessName.text = name
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
