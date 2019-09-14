//
//  PhotoAlbumViewController+CollectionView.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-03.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import UIKit

extension PhotoAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		let sections = albumPhotosFetchedResultsController.sections ?? []

		return sections.isEmpty ? 0 : 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		let count = albumPhotosFetchedResultsController.sections?[section].numberOfObjects ?? 0

		return count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell

		let currentPhoto = albumPhotosFetchedResultsController.object(at: indexPath)

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
				guard let image = image else { preconditionFailure("Unable to download image: \(error.debugDescription)") }

				currentPhoto.imageData = image.pngData()
				cell.imageView.image = image
				cell.activityIndicator.stopAnimating()
			}
		}

		do {
			try dataController.viewContext.save()
		} catch {
			print("Unable to save photo from flickr")
		}

		return cell

	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		var photo = albumPhotosFetchedResultsController.object(at: indexPath) as! Photo

		performSegue(withIdentifier: "showPhotoDetails", sender: photo)
	}

}
