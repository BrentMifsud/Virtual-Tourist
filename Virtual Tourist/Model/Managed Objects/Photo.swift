//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-24.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreData

extension Photo {
	override public func awakeFromInsert() {
		super.awakeFromInsert()
		dateCreated = Date()
	}
}
