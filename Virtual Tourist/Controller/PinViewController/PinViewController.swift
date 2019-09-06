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

class PinViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var instructionLabel: UILabel!

	var dataController: DataController!
	var flickrClient: FlickrClient!
	var pinStore: PinStoreProtocol!
	var albumStore: PhotoAlbumStoreProtocol!

	private let instructionLabelLongPress = "Long press to add new travel location"
	private let instructionLabelRelease = "Release finger to add pin"

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

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let vc = segue.destination as? PhotoAlbumViewController else { return }

		let selectedAnnotation = sender as! MKAnnotation

		vc.dataController = self.dataController
		vc.flickrClient = self.flickrClient
		vc.pinStore = self.pinStore
		vc.albumStore = self.albumStore
		vc.selectedAnnotation = selectedAnnotation
	}
}

