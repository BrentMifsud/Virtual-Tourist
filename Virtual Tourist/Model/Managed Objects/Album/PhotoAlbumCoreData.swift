//
//  PhotoAlbumCoreData.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-29.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation

struct PhotoAlbumCoreData: PhotoAlbumCoreDataProtocol {
	var photoCoreData: PhotoCoreDataProtocol

	init(photoCoreData: PhotoCoreDataProtocol) {
		self.photoCoreData = photoCoreData
	}

	func addPhotos(images: [FlickrImage], toPhotoAlbum photoAlbum: PhotoAlbum) throws {
		guard let context = photoAlbum.managedObjectContext else { preconditionFailure("Album does not have a context.") }

		images.forEach { (flickrImage) in
			_ = photoCoreData.createPhoto(flickrImage: flickrImage, inAlbum: photoAlbum)
		}

		try context.save()
	}
}
