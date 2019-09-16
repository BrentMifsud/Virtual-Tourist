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

		let pinAnnotation = annotation as! AnnotationPinView
		pinAnnotation.title = pinAnnotation.pin.locationName

		if pinView == nil {
			pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = false
			pinView!.markerTintColor = .blue

		} else {
			pinView!.annotation = annotation
		}

		return pinView
	}

	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		setPersistedMapLocation()
	}

	/// Persist the map's current view details inside user defaults.
	func setPersistedMapLocation() {
		let location = [
			"lat":mapView.centerCoordinate.latitude,
			"long":mapView.centerCoordinate.longitude,
			"latDelta":mapView.region.span.latitudeDelta,
			"longDelta":mapView.region.span.longitudeDelta
		]
		
		UserDefaults.standard.set(location, forKey: locationKey)
	}

	/// Returns the mapView's location to how it was last time the app was open.
	func loadPersistedMapLocation() {
		if let mapRegion = UserDefaults.standard.dictionary(forKey: locationKey) {

			let locationData = mapRegion as! [String : CLLocationDegrees]
			let center = CLLocationCoordinate2D(latitude: locationData["lat"]!, longitude: locationData["long"]!)
			let span = MKCoordinateSpan(latitudeDelta: locationData["latDelta"]!, longitudeDelta: locationData["longDelta"]!)

			mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
		}
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard let annotation = view.annotation else { return }
		guard !self.activityIndicator.isAnimating else {
			mapView.deselectAnnotation(view.annotation, animated: false)
			return
		}

		let pinAnnotation = annotation as! AnnotationPinView

		performSegue(withIdentifier: "showPhotoAlbum", sender: pinAnnotation)

		/*
		When closing the photo album view controller, the selected annotation stays selected.
		This prevents users from re-opening the same album without tapping somewhere else on the map.
		Wait to deselect so that the user does not see the animation.
		*/
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			mapView.deselectAnnotation(view.annotation, animated: false)
		}
	}

	/// Persists a new pin managed object and adds it to the map using the specified coordinate.
	/// - Parameter coordinate: the coordinate for the new pin to be added.
	func createGeocodedAnnotation(from coordinate: CLLocationCoordinate2D) {
		let geoCoder = CLGeocoder()
		let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

			geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
				DispatchQueue.main.async {
					guard let placemark = placemarks?.first else { return }
					let name = placemark.name ?? "Unknown Area"

					let newPin = self.pinStore.createPin(usingContext: self.dataController.viewContext, withLocation: name, andCoordinate: coordinate)
					let annotationPin = AnnotationPinView(pin: newPin)
					annotationPin.title = name

					do {
						// Try to save the newly created pin.
						try self.dataController.save()
					} catch {
						print("Error saving new pin: \(error)")
					}

					// Get images for current Pin
					self.flickrClient.getFlickrPhotos(forPin: newPin, resultsForPage: 1) { (pin, error) in
						guard pin == pin else { return }

						self.activityIndicator.stopAnimating()
						self.instructionLabel.setInstructionLabel(.longPress)
						self.mapView.isInteractionEnabled(true)
					}

					// Add the newly created pin to the map.
					self.mapView.addAnnotation(annotationPin)
				}
			}
	}

	/// Add a pin managed object to the Map View.
	/// - Parameter pin: Pin Managed Object to be added.
	func addPinAnnotation(pin: Pin){
		self.mapView.addAnnotation(AnnotationPinView(pin: pin))
	}

	/// Clear all existing annotations from the map.
	func clearAnnotations(){
		self.mapView.removeAnnotations(self.mapView.annotations)
	}
}
