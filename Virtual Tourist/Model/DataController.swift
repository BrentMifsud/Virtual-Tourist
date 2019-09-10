//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-07-15.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreData

/// Used to manage core data in Virtual Tourist Application.
class DataController {
	let persistentContainer: NSPersistentContainer

	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}

	init(modelName: String) {
		persistentContainer = NSPersistentContainer(name: modelName)
	}

	func load(completion: (() -> Void)? = nil) {
		persistentContainer.loadPersistentStores { storeDescription, error in
			guard error == nil else {
				fatalError(error!.localizedDescription)
			}
			//TODO:- Enable this
			//self.autoSaveViewContext()
			completion?()
		}
	}

	func save() throws {
		if viewContext.hasChanges {
			try viewContext.save()
		}
	}
}

// MARK: - Autosaving
extension DataController {
	func autoSaveViewContext(interval: TimeInterval = 30) {
		print("Autosaving")

		guard interval > 0 else {
			print("cannot set negative autosave interval")
			return
		}

		if viewContext.hasChanges {
			try? viewContext.save()
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
			self.autoSaveViewContext(interval: interval)
		}
	}
}
