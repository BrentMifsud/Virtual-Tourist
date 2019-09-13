//
//  PhotoAlbumViewController+MapView.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-03.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import Foundation
import MapKit

extension PhotoAlbumViewController: MKMapViewDelegate {

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

		let reuseId = "pin"

		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

		if pinView == nil {
			pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = false
			pinView!.markerTintColor = .blue
		} else {
			pinView!.annotation = annotation
		}

		pinView?.isSelected = true
		pinView?.isUserInteractionEnabled = false

		return pinView
	}

	func setUpMapView(){
		let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
		let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
		let region = MKCoordinateRegion(center: coordinate, span: span)
		mapView.setRegion(region, animated: true)
		mapView.isInteractionEnabled(false)
		mapView.addAnnotation(AnnotationPinView(pin: pin))
	}
}
