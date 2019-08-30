//
//  PinStoreProtocol.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-29.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData


/// A store in charge of creating new Pin NSManagedObjects and store them with core data.
protocol PinStoreProtocol {
	/// Creates and persists a pin object.
	/// - Parameters:
	///     - context: the managed object context used to persist the pin.
	///     - location: the name of the location associated with the pin.
	///     - coordinate: the coordinates of the pin.
	/// - Returns: the created pin object.
	func createPin(usingContext context: NSManagedObjectContext, withLocation location: String?, andCoordinate coordinate: CLLocationCoordinate2D) -> Pin
}
