//
//  PhotoStore.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-29.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreData

struct PhotoStore: PhotoStoreProtocol {
	func createPhoto(flickrImage: FlickrImage, inAlbum album: PhotoAlbum) -> Photo {
		guard let context = album.managedObjectContext else { preconditionFailure("Failed to get album context.") }

		let photo = Photo(context: context)
		photo.title = flickrImage.title
		photo.url = URL(string: flickrImage.mediumUrl)
		photo.id = flickrImage.id
		photo.photoAlbum = album
		photo.height = flickrImage.height
		photo.width = flickrImage.width

		return photo
	}

	func getFetchedResultsController(forAlbum album: PhotoAlbum, fromContext context: NSManagedObjectContext) -> NSFetchedResultsController<Photo> {
		let photosRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
		photosRequest.predicate = NSPredicate(format: "album = %@", album)
		photosRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: true)]

		return NSFetchedResultsController(fetchRequest: photosRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
	}


}
