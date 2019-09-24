//
//  Album.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-24.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreData


/// Photo Album Core Data Managed Object
class PhotoAlbum: NSManagedObject {
	var isEmpty: Bool {
		return (photos?.count ?? 0) == 0
	}

	override func awakeFromInsert() {
		super.awakeFromInsert()
		dateCreated = Date()
		id = UUID().uuidString
	}
}
