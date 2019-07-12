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
		let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
		self.view.addGestureRecognizer(recognizer)
		
		//Fetch Map Pins from coreData model

		//Fetch Saved Photos associated with each mapPin
	}

	@objc func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
		if recognizer.state == .began{
			//Hover pin above location
			print("Long Press")
		} else if recognizer.state == .ended {
			//Drop pin at location
			print("Long Press Ended")
		}
	}

	func isDownloading(downloading: Bool){
		downloading ? mapActivityIndicator.startAnimating() : mapActivityIndicator.stopAnimating()
	}


}

