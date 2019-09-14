//
//  FlickrClientProtocol.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-27.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import UIKit

protocol FlickrClientProtocol {
	var networkClient: NetworkClientProtocol { get }
	var photoAlbumStore: PhotoAlbumStoreProtocol { get }
	var dataController: DataController { get }

	init(networkClient: NetworkClientProtocol, photoAlbumStore: PhotoAlbumStoreProtocol, dataController: DataController )

	/// Obtains photos from Flickr for a specified map pin.
	/// - Parameters:
	/// 	- pin: the map pin to be populated with photos.
	///		- page: the page to grab photos from. Each page contains up to 100 photos.
	///		- completionHandler: function that will be called following the compeltion of this method.
	func getFlickrPhotos(forPin pin: Pin, resultsForPage page: Int, completionHandler: @escaping (Pin?, Error?) -> Void)

	/// Given Flickr image URL, download the image from Flickr.
	/// - Parameters:
	///		- url: Image Url.
	///		- completionHandler: function that will be called following the completion of this method.
	func downloadImage(fromUrl url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void )


	/// Obtain the number of pages of photos for the given pin.
	/// - Parameters:
	/// 	- pin: the map pin to be populated with photos.
	///		- completionHandler: function that will be called following the compeltion of this method.
	func getTotalPhotosCount(forPin pin: Pin, completionHandler: @escaping (Int?, Error?) -> Void)
}
