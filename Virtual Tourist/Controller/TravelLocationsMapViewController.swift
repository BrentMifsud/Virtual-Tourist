//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-07-09.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var mapActivityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var instructionLabel: UILabel!

	let instructionLabelLongPress = "Long press to add new travel location"
	let instructionLabelRelease = "Release finger to add pin"
	let instructionLabelDismiss = "Tap map to dismiss photo album"

	let tapView = UIView()
	var collectionView: UICollectionView!

	let locationKey: String = "persistedMapRegion"
	var currentLocation: [String : CLLocationDegrees]!
	var annotations: [MKPointAnnotation] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		retrievePersistedMapLocation()
	}

	@IBAction func longPress(_ sender: UILongPressGestureRecognizer) {

		if sender.state == .began{
			//Update Instruction Label
			instructionLabel.text = instructionLabelRelease

		} else if sender.state == .ended {
			//Get coordinate of touchpoint
			let touchPoint = sender.location(in: self.mapView)

			let locationCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
			let geoCoder = CLGeocoder()
			let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)

			DispatchQueue.main.async {
				geoCoder.reverseGeocodeLocation(location) { [unowned self] (placemarks, error) in
					guard let placemark = placemarks?.first else { return }

					// Location Name
					if let name = placemark.name{
						self.addMapPin(locationName: name, coordinate: locationCoordinate)
					}
				}
			}
			
			instructionLabel.text = instructionLabelLongPress
		}
	}

	func isDownloading(downloading: Bool){
		downloading ? mapActivityIndicator.startAnimating() : mapActivityIndicator.stopAnimating()
	}
}

