//
//  Album.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-24.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreData

extension PhotoAlbum {
	var hasImages: Bool {
		return (photos?.count ?? 0) > 0
	}

	override public func awakeFromInsert() {
		super.awakeFromInsert()
		dateCreated = Date()
		id = UUID().uuidString
	}
}
