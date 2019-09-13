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

	var fetchedResultsController: NSFetchedResultsController<Photo>!

	var pin: Pin!

	var pinStore: PinStoreProtocol!

	var photoStore: PhotoStoreProtocol!

	var flickrClient: FlickrClientProtocol!

	var albumStore: PhotoAlbumStoreProtocol!

	override func viewDidLoad() {
        super.viewDidLoad()

		// Set delegates
		mapView.delegate = self
		collectionView.delegate = self
		collectionView.dataSource = self

		setUpFetchedResultsController()

		navBarItem.title = pin.locationName ?? "Album"

		// Set Map View
		setUpMapView()
    }

	fileprivate func setUpFetchedResultsController() {
		guard let album = self.pin.album else { preconditionFailure("\nError: No Album exists for Pin") }

		let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
		let predicate = NSPredicate(format: "photoAlbum == %@", album)
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = [sortDescriptor]

		fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)

		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError("Unable to fetch photos: \(error.localizedDescription)")
		}
	}


	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}


	@IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
		pinStore.deletePin(pin: self.pin, fromContext: self.dataController.viewContext)
		self.dismiss(animated: true, completion: nil)
	}
}

//TODO:- PhotoCell is broken
extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		let sections = fetchedResultsController.sections ?? []

		return sections.isEmpty ? 0 : 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		let count = fetchedResultsController.sections?[section].numberOfObjects ?? 0

		return count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell

		let currentPhoto = fetchedResultsController.object(at: indexPath)

		if let data = currentPhoto.imageData {
			if let existingImage = currentPhoto.image {
				cell.imageView.image = existingImage
				cell.activityIndicator.stopAnimating()
			} else {
				let image = UIImage(data: data)
				currentPhoto.image = image
				cell.imageView.image = image
				cell.activityIndicator.stopAnimating()
			}
		} else {
			// No photo currently downloaded. Request image from flickr
			cell.activityIndicator.startAnimating()

			flickrClient.downloadImage(fromUrl: currentPhoto.url!) { (image, error) in
				guard let image = image else { preconditionFailure("Unable to download image") }

				currentPhoto.imageData = image.pngData()
				cell.imageView.image = image
				cell.activityIndicator.stopAnimating()
			}
		}

		return cell

	}
}
