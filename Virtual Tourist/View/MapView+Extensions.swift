//
//  MapView+Extensions.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-05.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
	/// Set all map interaction on or off
	/// - Parameter enabled: Whether to enable or disable map interaction.
	func isInteractionEnabled(_ enabled: Bool) {
		isScrollEnabled = enabled
		isZoomEnabled = enabled
		isPitchEnabled = enabled
		isRotateEnabled = enabled
	}

	/// Add a pin managed object to the Map View.
	/// - Parameter pin: Pin Managed Object to be added.
	func addPinAnnotation(pin: Pin){
		addAnnotation(AnnotationPinView(pin: pin))
	}

	/// Clear all existing annotations from the map.
	func clearAnnotations(){
		removeAnnotations(annotations)
	}
}
