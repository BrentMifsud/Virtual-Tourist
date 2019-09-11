//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-03.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	@IBOutlet weak var deleteButton: UIBarButtonItem!
	@IBOutlet weak var navBarItem: UINavigationItem!

	var dataController: DataController!

	var pin: Pin!

	var pinStore: PinStoreProtocol!

	var photoStore: PhotoStoreProtocol!

	var flickrClient: FlickrClientProtocol!

	var photoFetchedResultsController: NSFetchedResultsController<Photo>!

	var albumStore: PhotoAlbumStoreProtocol!

	override func viewDidLoad() {
        super.viewDidLoad()
		mapView.delegate = self

		navBarItem.title = pin.locationName ?? "Album"

		let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)

		let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)

		let region = MKCoordinateRegion(center: coordinate, span: span)

		mapView.setRegion(region, animated: true)

		mapView.isInteractionEnabled(false)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		//TODO:- Connect to core data to load all pins.
		//TODO:- Pass the pin instead of MK annotation to this view controller and use that to fill up the map view

		mapView.addAnnotation(AnnotationPinView(pin: pin))
	}


	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}


	@IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
		pinStore.deletePin(pin: self.pin, fromContext: self.dataController.viewContext)
		self.dismiss(animated: true, completion: nil)
	}
}
