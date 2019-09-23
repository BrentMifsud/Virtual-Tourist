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

	// MARK:- IBOutlets
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var instructionLabel: InstructionLabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	// MARK:- Controller Properties
	let locationKey: String = "persistedMapRegion"
	var currentLocation: [String : CLLocationDegrees]!

	// MARK:- View lifecycle methods
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		loadPersistedMapLocation()

		if #available(iOS 13.0, *) {
			activityIndicator.style = .large
		} else {
			activityIndicator.style = .whiteLarge
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		refreshPins()
	}

	/// Fetch all persisted pins and add them to the map view.
	func refreshPins() {
		// Clear all existing annotations before trying to refresh them.
		mapView.clearAnnotations()

		// Fetch all the pins from core data.
		let request: NSFetchRequest<Pin> = Pin.fetchRequest()
		request.sortDescriptors = [
			NSSortDescriptor(key: "dateCreated", ascending: false)
		]

		DataController.shared.viewContext.perform {
			do {
				let pins = try DataController.shared.viewContext.fetch(request)
				self.mapView.addAnnotations(pins.map { pin in AnnotationPinView(pin: pin) })
			} catch {
				print("Error fetching Pins: \(error)")
			}
		}
	}

	//MARK:- IBActions
	@IBAction func longPress(_ sender: UILongPressGestureRecognizer) {

		if sender.state == .began{
			// Update Instruction Label
			instructionLabel.setInstructionLabel(.release)

		} else if sender.state == .ended {
			// Get the coordinates of the tapped location on the map.
			let locationCoordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
			instructionLabel.setInstructionLabel(.longPress)
			createGeocodedAnnotation(from: locationCoordinate)			
		}
	}

	//MARK:- Segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let vc = segue.destination as? PhotoAlbumViewController else { return }

		let pinAnnotation: AnnotationPinView = sender as! AnnotationPinView

		vc.pin = pinAnnotation.pin
	}
}

