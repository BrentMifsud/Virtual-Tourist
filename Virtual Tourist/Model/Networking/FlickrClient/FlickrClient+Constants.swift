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
		static let Latitude = "lat"
		static let Longitude = "lon"
		static let Radius = "radius"
		static let RadiusUnits = "radius_units"
		static let Page = "page"
		static let ResultsPerPage = "per_page"
		static let Sort = "sort"
	}

	enum ParameterDefaultValues {
		static let Format = "json"
		static let NoJsonCallback = "1"
		static let ExtraMediumURL = "url_m"
		static let ResultsPerPage = "50"
		static let Radius = "0.1"
		static let RadiusUnits = "km"
		static let APIKey = "ADD API KEY HERE" // ADD YOUR FLICKR API KEY HERE
		static let Sort = "date-posted-desc"
	}
}
