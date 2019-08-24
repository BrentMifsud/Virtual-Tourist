//
//  FlickrResponse.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-24.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation

/// Response struct from flickr photo search API.
struct FlickrResponse: Codable {
	let searchResults: SearchResults
	let status: String

	enum CodingKeys: String, CodingKey {
		case searchResults = "photos"
		case status = "stat"
	}
}

// Pagination metadata from Flickr photos search API.
struct SearchResults: Codable {
	let page: Int
	let pages: Int
	let photosPerPage: Int
	let photos: [FlickrImage]

	enum CodingKeys: String, CodingKey {
		case page
		case pages
		case photosPerPage = "perpage"
		case photos = "photo"
	}
}

/// Individual photo metadata from flickr API.
struct FlickrImage: Codable {
	let id: String
	let title: String
	let mediumUrl: String

	enum CodingKeys: String, CodingKey {
		case id
		case title
		case mediumUrl = "url_m"
	}
}

