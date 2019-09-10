//
//  NetworkClient+Constants.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-27.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation

extension NetworkClient {
	enum HeaderKeys {
		static let contentType = "Content-Type"
		static let accept = "Accept"
	}

	enum HeaderValues {
		static let contentType = "application/json"
		static let accept = "application/json"
	}

	enum HTTPMethods{
		static let get = "GET"
	}
}
