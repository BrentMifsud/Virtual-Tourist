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
	func isInteractionEnabled(_ enabled: Bool) {
		isScrollEnabled = enabled
		isZoomEnabled = enabled
		isPitchEnabled = enabled
		isRotateEnabled = enabled
	}
}
