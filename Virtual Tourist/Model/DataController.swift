//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-07-15.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreData

class DataController {
	let persistentContainer: NSPersistentContainer

	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}

	init(modelName: String) {
		persistentContainer = NSPersistentContainer(name: modelName)
	}

	func load(completion: (() -> Void)? = nil) {
		persistentContainer.loadPersistentStores { (storeDescription, error) in
			guard error == nil else {
				fatalError(error!.localizedDescription)
			}
			completion?()
		}
	}
}
