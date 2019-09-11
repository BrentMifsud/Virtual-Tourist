//
//  PinViewController+CoreData.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-09.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension PinViewController {
	/// Fetch all persisted pins and add them to the map view.
	func refreshPins() {
		// Clear all existing annotations before trying to refresh them.
		clearAnnotations()

		// Fetch all the pins from core data.
		let request: NSFetchRequest<Pin> = Pin.fetchRequest()
		request.sortDescriptors = [
			NSSortDescriptor(key: "dateCreated", ascending: false)
		]

		dataController.viewContext.perform {
			do {
				let pins = try self.dataController.viewContext.fetch(request)
				self.mapView.addAnnotations(pins.map { pin in AnnotationPinView(pin: pin) })
			} catch {
				print("Error fetching Pins: \(error)")
			}
		}
	}
}
