//
//  FlickrErrorResponse.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-20.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation

struct FlickrErrorResponse: Codable {
	let status: String
	let code: Int
	let message: String

	enum CodingKeys: String, CodingKey {
		case status = "stat"
		case code
		case message
	}
}

extension FlickrErrorResponse: LocalizedError {
	var errorDescription: String? {
		return self.message
	}
}
