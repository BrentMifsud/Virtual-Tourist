//
//  PinViewController+MapView.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-07-09.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import MapKit

extension PinViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

		let reuseId = "pin"

		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

		if pinView == nil {
			pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = false
			pinView!.glyphTintColor = .blue
		} else {
			pinView!.annotation = annotation
		}

		return pinView
	}

	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		setPersistedMapLocation()
	}

	func setPersistedMapLocation() {
		let location = [
			"lat":mapView.centerCoordinate.latitude,
			"long":mapView.centerCoordinate.longitude,
			"latDelta":mapView.region.span.latitudeDelta,
			"longDelta":mapView.region.span.longitudeDelta
		]
		
		UserDefaults.standard.set(location, forKey: locationKey)
	}

	func retrievePersistedMapLocation() {
		if let mapRegion = UserDefaults.standard.dictionary(forKey: locationKey) {
			let locationData = mapRegion as! [String : CLLocationDegrees]
			let center = CLLocationCoordinate2D(latitude: locationData["lat"]!, longitude: locationData["long"]!)
			let span = MKCoordinateSpan(latitudeDelta: locationData["latDelta"]!, longitudeDelta: locationData["longDelta"]!)
			mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
		}
	}

	func addMapPin(locationName: String, coordinate: CLLocationCoordinate2D) {
		let newAnnotation = MKPointAnnotation()
		newAnnotation.coordinate = coordinate
		newAnnotation.title = locationName

		mapView.addAnnotation(newAnnotation)
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard let annotation = view.annotation else { return }

		let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)

		let region = MKCoordinateRegion(center: annotation.coordinate, span: span)

		mapView.setRegion(region, animated: true)

		performSegue(withIdentifier: "showPhotoAlbum", sender: annotation)
	}
}
