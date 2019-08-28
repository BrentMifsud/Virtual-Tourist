//
//  NetworkClient.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-27.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation

struct NetworkClient: NetworkClientProtocol {
	var urlSession: URLSession

	init(urlSession: URLSession) {
		self.urlSession = urlSession
	}

	func createGetRequest(
		withUrl baseUrl: URL,
		queryParms: [String : String],
		headers: [String : String]?,
		completionHandler: @escaping (Data?, Error?) -> Void
	) -> URLSessionDataTask {
		guard var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else { preconditionFailure("Failed to Build URLComponents from: \(baseUrl)")
		}

		urlComponents.queryItems = queryParms.map{ (key, value) in
			URLQueryItem(name: key, value: value)
		}

		var urlRequest = URLRequest(url: urlComponents.url!)

		urlRequest.httpMethod = HTTPMethods.get

		if let headers = headers {
			headers.forEach { (key, value) in
				urlRequest.addValue(value, forHTTPHeaderField: key)
			}
		} else {
			urlRequest.addValue(HeaderValues.contentType, forHTTPHeaderField: HeaderKeys.contentType)
			urlRequest.addValue(HeaderValues.accept, forHTTPHeaderField: HeaderKeys.accept)
		}

		return urlSession.dataTask(with: urlRequest){ (data, urlResponse, error) in
			guard let data = data, error == nil else {
				completionHandler(nil, error)
				return
			}

			completionHandler(data, nil)
		}
	}
}
