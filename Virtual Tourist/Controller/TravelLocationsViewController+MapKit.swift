//
//  TravelLocationsViewController+MapKit.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-07-09.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import MapKit

extension TravelLocationsViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

		let reuseId = "pin"

		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView!.pinTintColor = .red
			pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIButton
		} else {
			pinView!.annotation = annotation
		}

		return pinView
	}


	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if control == view.rightCalloutAccessoryView {
			let app = UIApplication.shared
			if let toOpen = view.annotation?.subtitle! {
				app.open(URL(string: toOpen) ?? URL(string: "")!, options: [:], completionHandler: nil)
			}
		}
	}

	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		setPersistedMapLocation()
	}

	func setPersistedMapLocation() {
		let location = ["lat":mapView.centerCoordinate.latitude
			, "long":mapView.centerCoordinate.longitude
			, "latDelta":mapView.region.span.latitudeDelta
			, "longDelta":mapView.region.span.longitudeDelta]

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

	func retrieveLocationName(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
		let geoCoder = CLGeocoder()
		let location = CLLocation(latitude: latitude, longitude: longitude)

		var locationName = ""

		geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
			guard let placemark = placemarks?.first else {return}

			// Location Name
			if let name = placemark.name{
				print(name)
				locationName = name
			}
		}

		return locationName
	}

}
