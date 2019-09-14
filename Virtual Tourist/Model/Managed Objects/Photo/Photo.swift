//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-24.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Photo: NSManagedObject {
	var image: UIImage?

	override func awakeFromInsert() {
		super.awakeFromInsert()
		dateCreated = Date()
	}

	func isEqual(_ photo: Photo) -> Bool {
		guard let photo1 = self.url?.absoluteString, let photo2 = photo.url?.absoluteString else { preconditionFailure("\nError: Cannot compare nil Photo") }
		let isEqual = photo1 == photo2 ? true : false
		return isEqual
	}
}
