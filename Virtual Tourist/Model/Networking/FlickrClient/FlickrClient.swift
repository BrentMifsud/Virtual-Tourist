//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-24.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//  Credit to TiagoMaiaL for the idea of using enums without cases to store constants.
//

import Foundation

class FlickrClient {

	//Flicker API Constants
	enum API {
		static let BaseUrl = "https://api.flickr.com/services/rest/"
	}

	enum Methods {
		static let PhotosSearch = "flickr.photos.search"
	}

	enum ParameterKeys {
		static let APIKey = "api_key"
		static let Method = "method"
		static let Format = "format"
		static let NoJsonCallback = "nojsoncallback"
		static let Text = "text"
		static let Extra = "extras"
		static let latitude = "lat"
		static let longitude = "lon"
		static let radius = "radius"
		static let radiusUnits = "radius_units"
		static let page = "page"
		static let resultsPerPage = "per_page"
	}

	enum ParameterDefaultValues {
		static let Format = "json"
		static let NoJsonCallback = "1"
		static let ExtraMediumURL = "url_m"
		static let resultsPerPage = "100"
		static let radius = "0.5"
		static let radiusUnits = "km"
		static let APIKey = "ADD API KEY HERE"
	}
}
