//
//  FlickrClient+Constants.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-27.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation

extension FlickrClient {
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
