//
//  AlbumCoreDataProtocol.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-29.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation

/// Utility for adding photos to PhotoAlbum Managed Object
protocol PhotoAlbumCoreDataProtocol {
	/// Create and save images to the photo album.
	/// - Parameters:
	///		- images: the images from the flickr response
	///		- album: album populated with images
	func addPhotos(images: [FlickrImage], toPhotoAlbum photoAlbum: PhotoAlbum) throws
}
