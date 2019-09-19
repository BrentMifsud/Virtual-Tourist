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
		activityIndicator.startAnimating()

		// Populate cell imageview
		if let data = photo.imageData {
			// Photo data already exists in photo object. But has not yet been converted to a UIImage
			let image = UIImage(data: data)
			imageView.image = image
			activityIndicator.stopAnimating()
		} else {
			// No photo currently downloaded. Request image from flickr
			activityIndicator.startAnimating()

			flickrClient.downloadImage(fromUrl: photo.url!) { [weak self] (imageData, url, error) in
				guard let weakSelf = self else { return }

				guard let imageData = imageData else { preconditionFailure("Unable to download image: \(error.debugDescription)") }

				if url != weakSelf.photo.url?.absoluteString {
					return
				}

				DispatchQueue.main.async {
					weakSelf.photo.imageData = imageData.jpegData(compressionQuality: 1)
					weakSelf.imageView.image = imageData
					weakSelf.activityIndicator.stopAnimating()
				}
			}
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		self.imageView.image = nil
		self.photo = nil
	}
}
