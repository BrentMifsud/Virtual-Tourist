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

	let locationKey: String = "persistedMapRegion"
	var currentLocation: [String : CLLocationDegrees]!
	var mapPins: [MapPin] = [] //TODO: replace later. Tie Map Pins to core data model.
	var dataController: DataController!


	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
		self.view.addGestureRecognizer(recognizer)
		retrievePersistedMapLocation()

		//Fetch Map Pins from coreData model
		let fetchRequest: NSFetchRequest<MapPin> = MapPin.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "locationName", ascending: true)
		if let result = try? dataController.viewContext.fetch(fetchRequest) {
			mapPins = result
			//TODO: load all map pins onto map
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}

	@objc func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
		if recognizer.state == .began{
			//TODO: Hover pin above location
			print("Long Press")
		} else if recognizer.state == .ended {
			//TODO: Drop pin at location
			//TODO: Popup prompting to name pin
			//TODO: addMapPin(Name of pin from above, Coordinates from above)
			print("Long Press Ended")
		}
	}

	func addMapPin(locationName: String, coordinates: CLLocationCoordinate2D) {
		let mapPin: MapPin = MapPin(context: dataController.viewContext)
		mapPin.locationName = locationName
		mapPin.latitude = coordinates.latitude
		mapPin.longitude = coordinates.longitude

		do {
			try dataController.viewContext.save()
			mapPins.append(mapPin)
		} catch {
			//TODO: show alert for unable to add location to map
			print(error)
		}
	}

	func isDownloading(downloading: Bool){
		downloading ? mapActivityIndicator.startAnimating() : mapActivityIndicator.stopAnimating()
	}
}

