//
//  PhotoStoreProtocol.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-29.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreData

/// Create photos from flickr.
protocol PhotoStoreProtocol {
	/// Creates a new Photo NSManagedObject
	/// - Parameters:
	/// 	- flickrImage: flickr image to be persisted.
	/// 	- album: the album associted with the image.
	func createPhoto(flickrImage: FlickrImage, inAlbum album: PhotoAlbum) -> Photo

	/// Retrieve Fetched results controller for the associated album.
	/// - Parameters:
	/// 	- photoAlbum: the album that photos will be retrieved from.
	///		- context: the managed object context to be fetched.
	/// - Returns: the fetched results controller.
	func getFetchedResultsController(forAlbum album: PhotoAlbum, fromContext context: NSManagedObjectContext) -> NSFetchedResultsController<Photo>
}
