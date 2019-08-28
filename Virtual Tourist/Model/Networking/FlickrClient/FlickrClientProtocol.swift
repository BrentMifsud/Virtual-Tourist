//
//  FlickrClientProtocol.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-27.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation

protocol FlickrClientProtocol {
	var networkClient: NetworkClientProtocol { get }
	var dataController: DataController { get }

	init(networkClient: NetworkClientProtocol, dataController: DataController )

	/// Obtains photos from Flickr for a specified map pin.
	/// - Parameters:
	/// 	- pin: the map pin to be populated with photos.
	///		- completionHandler: function that will be called following the compeltion of this method.
	func getFlickrPhotos(forPin pin: Pin, completionHandler: @escaping (Pin?, Error?) -> Void)
}
