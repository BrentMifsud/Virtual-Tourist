//
//  NetworkClientProtocol.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-27.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation


/// Network Client is used to create various HTTP requests.
protocol NetworkClientProtocol {
	/// Builds a GET HTTP task with the provided query parameters.
	/// - Parameters:
    ///	    - baseUrl: the base url for the request.
	///		- queryParms: query parameters to be included in the request.
	///     - headers: http header values.
	///     - completionHandler: block of code that will run after the task finishes.
	/// - Returns: URLSessionDataTask that is ready to be run.
	func createGetRequest(withUrl baseUrl: URL, queryParms: [String: String], headers: [String: String]?, completionHandler: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask
}
