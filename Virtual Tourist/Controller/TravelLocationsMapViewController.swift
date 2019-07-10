//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-07-09.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var mapActivityIndicator: UIActivityIndicatorView!

	var persistedLatitude = {
		return UserDefaults.standard.float(forKey: "latitude")
	}

	var persistedLongitude = {
		return UserDefaults.standard.float(forKey: "longitude")
	}


	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		
		//Fetch Map Pins from coreData model

		//Fetch Saved Photos associated with each mapPin
	}

	func isDownloading(downloading: Bool){
		downloading ? mapActivityIndicator.startAnimating() : mapActivityIndicator.stopAnimating()
	}


}

