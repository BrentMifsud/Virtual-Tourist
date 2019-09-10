//
//  AnnotationPinView.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-09.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import MapKit

/// Custom Annotation that can be created using a Pin managed object.
class AnnotationPinView: MKPointAnnotation {
	var pin: Pin

	init(pin: Pin){
		self.pin = pin
		super.init()
		self.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
	}
}


