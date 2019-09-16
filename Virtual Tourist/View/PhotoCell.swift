//
//  CollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-13.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit
import CoreData

class PhotoCell: UICollectionViewCell {
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var imageView: UIImageView!

	public static let reuseId = "photoCell"

	var photo: Photo!
	var flickrClient: FlickrClientProtocol!

	/// Set up the cell's imageView by downloading or reusing photos that have already been downloaded.
	func setUpPhotoCell() {
		// Populate cell imageview
		if let data = photo.imageData {
			// Photo data already exists in photo object. But has not yet been converted to a UIImage
			let image = UIImage(data: data)
			photo.image = image
			imageView.image = image
			activityIndicator.stopAnimating()
		} else {
			// No photo currently downloaded. Request image from flickr
			activityIndicator.startAnimating()

			flickrClient.downloadImage(fromUrl: photo.url!) { [unowned self] (image, error) in
				guard let image = image else { preconditionFailure("Unable to download image: \(error.debugDescription)") }

				self.photo.imageData = image.pngData()
				self.photo.image = image
				self.imageView.image = image
				self.activityIndicator.stopAnimating()
			}
		}
	}
}
