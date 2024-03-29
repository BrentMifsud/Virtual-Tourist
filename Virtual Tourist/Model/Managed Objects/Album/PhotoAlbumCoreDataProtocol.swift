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
	///		- photoAlbum: album populated with images
	func addPhotos(images: [FlickrImage], toPhotoAlbum photoAlbum: PhotoAlbum) throws

	/// Set the total number of pages for the specified album.
	/// - Parameters:
	///		- currentPage: the current page of photos for the specified album.
	///		- pages: the total number of pages of photos for the specified album.
	///		- photoAlbum: album to be populated with page count.
	func setPagingInformation(currentPage: Int16, totalPages: Int16,  forAlbum photoAlbum: PhotoAlbum) throws
}
