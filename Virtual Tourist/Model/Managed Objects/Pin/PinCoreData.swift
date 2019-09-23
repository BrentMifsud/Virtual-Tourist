//
//  PinCoreData.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-29.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

struct PinCoreData: PinCoreDataProtocol {

	static let shared: PinCoreData = PinCoreData()

	private init(){
		
	}

	func createPin(
		usingContext context: NSManagedObjectContext,
		withLocation location: String?,
		andCoordinate coordinate: CLLocationCoordinate2D
	) -> Pin {
		let pin = Pin(context: context)

		pin.locationName = location
		pin.latitude = coordinate.latitude
		pin.longitude = coordinate.longitude

		return pin

	}

	func deletePin(pin: Pin, fromContext context: NSManagedObjectContext) {
		context.delete(pin)

		do {
			try context.save()
		} catch {
			print("Error deleting pin: \(error)")
		}
	}
}
