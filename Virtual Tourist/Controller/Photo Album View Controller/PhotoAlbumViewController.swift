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

	//MARK:- Controller Properties
	var albumStatusView: AlbumStatusView!

	var dataController: DataController!

	var fetchedResultsController: NSFetchedResultsController<Photo>!

	var pin: Pin!

	var pinCoreData: PinCoreDataProtocol!

	var photoCoreData: PhotoCoreDataProtocol!

	var flickrClient: FlickrClientProtocol!

	var blockOperations: [BlockOperation] = []

	var currentPage: Int = 1

	var totalAlbumPages: Int = 1



	//MARK:- View Lifecycle methods
	fileprivate func setUpAlbumStatusView() {
		albumStatusView = AlbumStatusView(frame: self.collectionView.frame)
		albumStatusView.setState(state: .downloading)
		self.view.addSubview(albumStatusView)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let pin = pin else {
			presentErrorAlert(title: "Unable to load photo album", message: "Please try again later.")
			fatalError("No pin passed to photo album view controller")
		}

		navBarItem.title = pin.locationName ?? "Album"

		// Set up Map View
		mapView.delegate = self
		setUpMapView()

		// Set up Collection View
		collectionView.dataSource = self
		collectionView.delegate = self
		setUpAlbumStatusView()
		downloadPhotos()

		// Set up fetched results view controller
		guard let album = pin.album else { preconditionFailure("Unable to access album") }

		fetchedResultsController = photoCoreData.getFetchedResultsController(forAlbum: album, fromContext: dataController.viewContext)
		fetchedResultsController.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configureFlowLayout() 

		refreshPhotos()

		collectionView.reloadData()

		setAlbumStatusView()
	}

	func downloadPhotos(forPage page: Int = 1){
		albumStatusView.setState(state: .downloading)

		flickrClient.getFlickrPhotos(forPin: pin, resultsForPage: 1) {[unowned self] (pin, pages, error) in
			guard error == nil, let pin = pin, let pages = pages else {
				self.presentErrorAlert(title: "Unable to download images", message: error!.localizedDescription)
				return
			}
			guard let album = pin.album else { self.presentErrorAlert(title: "Unable to download images", message: error!.localizedDescription)
				return
			}

			if album.isEmpty {
				self.albumStatusView.setState(state: .noImagesFound)
				self.collectionView.isHidden = true
			} else {
				self.totalAlbumPages = pages
				self.configureFlowLayout()
				self.refreshPhotos()
				self.albumStatusView.setState(state: .displayImages)
				self.collectionView.isHidden = false
			}
		}
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
		dismiss(animated: true, completion: nil)
	}


	@IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
		pinCoreData.deletePin(pin: self.pin, fromContext: self.dataController.viewContext)
		dismiss(animated: true, completion: nil)
	}

	@IBAction func newCollectionButtonPressed(_ sender: UIBarButtonItem) {
		albumStatusView.setState(state: .downloading)

		fetchedResultsController.fetchedObjects?.forEach({ (photo) in
			dataController.viewContext.delete(photo)
		})

		do {
			try dataController.viewContext.save()
		} catch {
			print("Unable to save context after clearing album")
		}

//		var nextPage = 1
//
//		while nextPage == currentPage {
//			nextPage = Int.random(in: 1...totalAlbumPages)
//		}
//
//		downloadPhotos(forPage: nextPage)
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
