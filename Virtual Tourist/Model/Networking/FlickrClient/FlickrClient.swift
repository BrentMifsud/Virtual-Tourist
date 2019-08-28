//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-24.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//  Credit to TiagoMaiaL for the idea of using enums without cases to store constants.
//

import Foundation

class FlickrClient: FlickrClientProtocol {
	var networkClient: NetworkClientProtocol

	var dataController: DataController

	private let baseURL: URL = URL(string: API.BaseUrl)!

	required init(networkClient: NetworkClientProtocol, dataController: DataController) {
		self.networkClient = networkClient
		self.dataController = dataController
	}

	func getFlickrPhotos(forPin pin: Pin, completionHandler: @escaping (Pin?, Error?) -> Void) {
		let pinId = pin.objectID

		
	}
}
