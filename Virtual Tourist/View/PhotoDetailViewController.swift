//
//  PhotoDetailViewController.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-13.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit
import CoreData

class PhotoDetailViewController: UIViewController {

	//MARK:- IBOutlets
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var imageTitle: UILabel!
	@IBOutlet weak var url: UIButton!
	@IBOutlet weak var imageHeight: UILabel!
	@IBOutlet weak var imageWidth: UILabel!


	//MARK:- Controller properties
	var fetchedResultsViewController: NSFetchedResultsController<Photo>!
	var fetchedResultsViewControllerDelegate: NSFetchedResultsControllerDelegate!
	var photo: Photo!

	//MARK:- View lifecycle methods
	override func viewDidLoad() {
		super.viewDidLoad()

		guard let image = photo.image else { preconditionFailure("No image passed to photo view controller") }

		imageView.image = image
		imageTitle.text = photo.title
		url.setTitle(photo.url?.absoluteString, for: .normal)
		imageHeight.text = photo.height
		imageWidth.text = photo.width
	}

	//MARK:- IBActions
	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
		dismiss(animated: true) {
			self.fetchedResultsViewController.managedObjectContext.delete(self.photo)
		}
	}
}
