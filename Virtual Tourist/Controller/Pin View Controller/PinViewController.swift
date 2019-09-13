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
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	var dataController: DataController!
	var flickrClient: FlickrClientProtocol!
	var pinStore: PinStoreProtocol!
	var albumStore: PhotoAlbumStoreProtocol!

	private let instructionLabelLongPress = "Long press to add new travel location"
	private let instructionLabelRelease = "Release finger to add pin"

	let locationKey: String = "persistedMapRegion"
	var currentLocation: [String : CLLocationDegrees]!

	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		retrievePersistedMapLocation()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		refreshPins()
	}

	@IBAction func longPress(_ sender: UILongPressGestureRecognizer) {

		if sender.state == .began{
			// Update Instruction Label
			instructionLabel.text = instructionLabelRelease

		} else if sender.state == .ended {
			// Get the coordinates of the tapped location on the map.
			let locationCoordinate = self.mapView.convert(sender.location(in: self.mapView), toCoordinateFrom: self.mapView)

			createGeocodedAnnotation(from: locationCoordinate)
			
			instructionLabel.text = instructionLabelLongPress
		}
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let vc = segue.destination as? PhotoAlbumViewController else { return }

		let pinAnnotation: AnnotationPinView = sender as! AnnotationPinView

		vc.dataController = self.dataController
		vc.flickrClient = self.flickrClient
		vc.albumStore = self.albumStore
		vc.photoStore = self.albumStore.photoStore
		vc.pinStore = self.pinStore
		vc.pin = pinAnnotation.pin
	}
}

