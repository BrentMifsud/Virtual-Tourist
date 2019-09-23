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
	@IBOutlet weak var newCollectionButton: UIBarButtonItem!
	
	//MARK:- Controller Properties
	var albumStatusView: AlbumStatusView!

	var fetchedResultsController: NSFetchedResultsController<Photo>!

	var pin: Pin!

	var blockOperations: [BlockOperation] = []

	var totalAlbumPages: Int = 1


	//MARK:- View Lifecycle methods
	fileprivate func setUpAlbumStatusView() {
		albumStatusView = AlbumStatusView(frame: self.collectionView.frame)
		albumStatusView.setState(state: .downloading)
		self.view.addSubview(albumStatusView)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let pin = pin, let album = pin.album else {
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
		configureFlowLayout()
		newCollectionButton.isEnabled = false
		deleteButton.isEnabled = false
		setUpAlbumStatusView()

		if album.isEmpty {
			downloadPhotos()
		} else {
			albumStatusView.setState(state: .displayImages)
			setUpButtons(enabled: true)
		}

		fetchedResultsController = PhotoCoreData.shared.getFetchedResultsController(forAlbum: album, fromContext: DataController.shared.viewContext)
		fetchedResultsController.delegate = self
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		configureFlowLayout() 

		refreshPhotos()

		collectionView.reloadData()
	}

	func downloadPhotos(forPage page: Int = 1){
		albumStatusView.setState(state: .downloading)

		FlickrClient.shared.getFlickrPhotos(forPin: pin, resultsForPage: page) {[weak self] (pin, pages, error) in
			guard let weakSelf = self else { return }
			guard error == nil, let pin = pin, let pages = pages else {
				weakSelf.presentErrorAlert(title: "Unable to download images", message: error!.localizedDescription)
				return
			}
			guard let album = pin.album else { weakSelf.presentErrorAlert(title: "Unable to download images", message: error!.localizedDescription)
				return
			}

			if album.isEmpty {
				weakSelf.albumStatusView.setState(state: .noImagesFound)
			} else {
				weakSelf.totalAlbumPages = pages
				weakSelf.albumStatusView.setState(state: .displayImages)
				weakSelf.refreshPhotos()
			}
			weakSelf.setUpButtons(enabled: true)
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

	fileprivate func setUpButtons(enabled: Bool){
		deleteButton.isEnabled = enabled
		newCollectionButton.isEnabled = enabled
	}

	//MARK:- IBActions
	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}


	@IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
		PinCoreData.shared.deletePin(pin: self.pin, fromContext: DataController.shared.viewContext)
		dismiss(animated: true, completion: nil)
	}

	@IBAction func newCollectionButtonPressed(_ sender: UIBarButtonItem) {
		guard let album = pin.album else { return }
		guard !album.isEmpty else {
			presentErrorAlert(title: "Unable to fetch new photos", message: "There are no additional photos available for the given location.")
			return
		}

		newCollectionButton.isEnabled = false
		albumStatusView.setState(state: .downloading)

		fetchedResultsController.fetchedObjects?.forEach { (photo) in
			DataController.shared.viewContext.delete(photo)
		}
		
		do {
			try DataController.shared.viewContext.save()
		} catch {
			print("Unable to save context after clearing album")
		}

		let nextPage = Int.random(in: 1...totalAlbumPages)

		downloadPhotos(forPage: nextPage)
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
