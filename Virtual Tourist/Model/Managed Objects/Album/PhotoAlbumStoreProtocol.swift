//
//  AlbumStoreProtocol.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-29.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation

/// Create/Read/Delete Operations for PhotoAlbum NSManagedObject
protocol PhotoAlbumStoreProtocol {
	var photoStore: PhotoStoreProtocol { get }

	init(photoStore: PhotoStoreProtocol)

	/// Create and save images to the photo album.
	/// - Parameters:
	///		- images: the images from the flickr response
	///		- album: album populated with images
	func addPhotos(images: [FlickrImage], toPhotoAlbum photoAlbum: PhotoAlbum) throws
}
