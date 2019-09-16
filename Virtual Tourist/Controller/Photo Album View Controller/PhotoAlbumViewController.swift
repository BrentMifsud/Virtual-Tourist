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

	//MARK:- IBOutlets
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var doneButton: UIBarButtonItem!
	@IBOutlet weak var deleteButton: UIBarButtonItem!
	@IBOutlet weak var navBarItem: UINavigationItem!
	@IBOutlet weak var albumStatusView: UIView!
	
	//MARK:- Controller Properties
	var dataController: DataController!

	var fetchedResultsController: NSFetchedResultsController<Photo>!

	var pin: Pin!

	var pinStore: PinStoreProtocol!

	var photoStore: PhotoStoreProtocol!

	var flickrClient: FlickrClientProtocol!

	var blockOperations: [BlockOperation] = []

	var numberOfPhotos: Int { return collectionView.numberOfItems(inSection: 0) }

	//MARK:- View Lifecycle methods
	override func viewDidLoad() {
		super.viewDidLoad()

		guard let pin = pin else { preconditionFailure("No pin passed to photo album view controller") }
		guard let album = pin.album else { preconditionFailure("pin must have an album") }

		navBarItem.title = pin.locationName ?? "Album"

		fetchedResultsController = photoStore.getFetchedResultsController(forAlbum: album, fromContext: dataController.viewContext)

		// Set delegates
		mapView.delegate = self
		collectionView.delegate = self
		collectionView.dataSource = self
		fetchedResultsController.delegate = self

		setUpMapView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configureFlowLayout()

		refreshPhotos()

		collectionView.reloadData()

		setAlbumStatusView()
	}

	func setAlbumStatusView() {
		albumStatusView.isHidden = numberOfPhotos > 0
		collectionView.isHidden = numberOfPhotos == 0
	}

	fileprivate func refreshPhotos(){

		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError("Unable to fetch photos: \(error.localizedDescription)")
		}

		collectionView.reloadData()
	}

	//MARK:- IBActions
	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}


	@IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
		pinStore.deletePin(pin: self.pin, fromContext: self.dataController.viewContext)
		self.dismiss(animated: true, completion: nil)
	}

	//MARK:- Prepare for Segue
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let photo = sender as! Photo
		let destinationVC = segue.destination as! PhotoDetailViewController
		destinationVC.photo = photo
		destinationVC.fetchedResultsViewController = fetchedResultsController
		destinationVC.fetchedResultsViewControllerDelegate = self
	}
}
