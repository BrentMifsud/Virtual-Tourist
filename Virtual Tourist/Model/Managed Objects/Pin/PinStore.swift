//
//  PinStore.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-29.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData

struct PinStore: PinStoreProtocol {

	func createPin(
		usingContext context: NSManagedObjectContext,
		withLocation location: String?,
		andCoordinate coordinate: CLLocationCoordinate2D
	) -> Pin {
		let pin = Pin(context: context)

		pin.locationName = location
		pin.latitude = coordinate.latitude
		pin.longitude = coordinate.longitude

		return Pin()
	}
}
