//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-03.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	@IBOutlet weak var refreshButton: UIBarButtonItem!
	@IBOutlet weak var navBarItem: UINavigationItem!

	var dataController: DataController!
	var flickrClient: FlickrClient!
	var pinStore: PinStoreProtocol!
	var albumStore: PhotoAlbumStoreProtocol!
	var selectedAnnotation: MKAnnotation!
	

	override func viewDidLoad() {
        super.viewDidLoad()

		navBarItem.title = selectedAnnotation.title ?? "Album"

		let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)

		let region = MKCoordinateRegion(center: selectedAnnotation.coordinate, span: span)

		mapView.setRegion(region, animated: true)

		mapView.isInteractionEnabled(false)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		//TODO:- Connect to core data to load all pins.
		//TODO:- Pass the pin instead of MK annotation to this view controller and use that to fill up the map view

		mapView.addAnnotation(selectedAnnotation)
	}


	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}


	@IBAction func refreshButtonPressed(_ sender: UIBarButtonItem) {
	}
}
