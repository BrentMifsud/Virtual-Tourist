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

	var albumPhotosFetchedResultsController: NSFetchedResultsController<Photo>!

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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		collectionView.reloadData()
	}

	fileprivate func setUpFetchedResultsController() {
		guard let album = self.pin.album else { preconditionFailure("\nError: No Album exists for Pin") }

		let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
		let predicate = NSPredicate(format: "photoAlbum == %@", album)
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = [sortDescriptor]

		albumPhotosFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)

		do {
			try albumPhotosFetchedResultsController.performFetch()
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

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let photo = sender as! Photo
		let destinationVC = segue.destination as! PhotoDetailViewController
		destinationVC.image = photo
		destinationVC.dataController = self.dataController
	}
}

extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		//TODO: batch update
	}

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		//TODO: Batch update
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

		switch type {
		case .insert:
			collectionView.insertItems(at: [newIndexPath!])
		case.delete:
			collectionView.deleteItems(at: [indexPath!])
		case.update:
			collectionView.reloadItems(at: [indexPath!])
		case.move:
			collectionView.moveItem(at: indexPath!, to: newIndexPath!)
		@unknown default:
			break
		}
	}

	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

		let indexSet = IndexSet(integer: sectionIndex)

		switch type {
		case .insert: collectionView.insertSections(indexSet)
		case .delete: collectionView.deleteSections(indexSet)
		case .update, .move:
			fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
		@unknown default:
			break
		}
	}
}
