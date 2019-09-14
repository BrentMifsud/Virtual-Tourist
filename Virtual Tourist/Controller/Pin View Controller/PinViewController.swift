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
	@IBOutlet weak var instructionLabel: InstructionLabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	var dataController: DataController!
	var flickrClient: FlickrClientProtocol!
	var pinStore: PinStoreProtocol!
	var albumStore: PhotoAlbumStoreProtocol!

	


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
			instructionLabel.setInstructionLabel(.release)

		} else if sender.state == .ended {
			// Get the coordinates of the tapped location on the map.
			let locationCoordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)

			activityIndicator.startAnimating()
			mapView.isInteractionEnabled(false)
			instructionLabel.setInstructionLabel(.downloading)

			createGeocodedAnnotation(from: locationCoordinate)			
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

