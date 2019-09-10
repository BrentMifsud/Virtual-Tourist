//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-24.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//  Credit to TiagoMaiaL for the idea of using enums without cases to store constants.
//

import Foundation
import UIKit

class FlickrClient: FlickrClientProtocol {
	var networkClient: NetworkClientProtocol
	var photoAlbumStore: PhotoAlbumStoreProtocol
	var dataController: DataController

	private let baseURL: URL = URL(string: API.BaseUrl)!

	private static let jsonDecoder = JSONDecoder()

	required init(networkClient: NetworkClientProtocol, photoAlbumStore: PhotoAlbumStoreProtocol, dataController: DataController) {
		self.networkClient = networkClient
		self.photoAlbumStore = photoAlbumStore
		self.dataController = dataController
	}

	func getFlickrPhotos(forPin pin: Pin, resultsForPage page: Int, completionHandler: @escaping (Pin?, Error?) -> Void) {
		let pinId = pin.objectID

		requestImages(forPin: pin, resultsForPage: page) { (data, error) in
			guard let data = data, error == nil else {
				completionHandler(nil, error)
				return
			}

			self.dataController.persistentContainer.performBackgroundTask { (context) in
				guard let pinContext = context.object(with: pinId) as? Pin else {
					preconditionFailure("Pin must be fetched in background context")
				}

				do {
					try self.photoAlbumStore.addPhotos(images: data.searchResults.photos, toPhotoAlbum: pinContext.album!)

					completionHandler(pin, nil)
				} catch {
					completionHandler(nil, error)
				}
			}

		}
	}

	func requestImages(forPin pin: Pin, resultsForPage page: Int, completionHandler: @escaping (FlickrResponse?, Error?) -> Void) {
		var queryParms = [
			ParameterKeys.APIKey: ParameterDefaultValues.APIKey,
			ParameterKeys.Format: ParameterDefaultValues.Format,
			ParameterKeys.NoJsonCallback: ParameterDefaultValues.NoJsonCallback,
			ParameterKeys.Method: Methods.PhotosSearch,
			ParameterKeys.Extra: ParameterDefaultValues.ExtraMediumURL
		]

		if let locationName = pin.locationName {
			queryParms[ParameterKeys.Text] = locationName
		} else {
			queryParms[ParameterKeys.Latitude] = String(pin.latitude)
			queryParms[ParameterKeys.Longitude] = String(pin.longitude)
			queryParms[ParameterKeys.Page] = String(page)
			queryParms[ParameterKeys.RadiusUnits] = ParameterDefaultValues.RadiusUnits
			queryParms[ParameterKeys.Radius] = "0.1"
			queryParms[ParameterKeys.ResultsPerPage] = ParameterDefaultValues.ResultsPerPage
		}

		let dataTask = networkClient.createGetRequest(withUrl: baseURL, queryParms: queryParms, headers: nil) { (data, error) in

			guard let data = data, error == nil else {
				completionHandler(nil, error)
				return
			}

			let jsonDecoder = JSONDecoder()

			do {
				let flickrResponse = try jsonDecoder.decode(FlickrResponse.self, from: data)
				completionHandler(flickrResponse, nil)
			} catch {
				completionHandler(nil, error)
			}
			
		}
		//TODO:- enable network indicator

		dataTask.resume()
	}

	func requestImage(imageUrl: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
		let dataTask = networkClient.createGetRequest(withUrl: imageUrl, queryParms: [:], headers: [:]) { (data, error) in
			guard let data = data, error == nil else {
				completionHandler(nil, error)
				return
			}

			guard let image = UIImage(data: data) else {
				completionHandler(nil, error)
				return
			}

			completionHandler(image, nil)
		}

		//TODO:- enable network indicator

		dataTask.resume()
	}
}