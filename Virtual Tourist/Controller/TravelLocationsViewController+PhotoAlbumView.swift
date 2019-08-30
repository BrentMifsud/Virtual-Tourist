//
//  TravelLocationViewController+PhotoAlbumView.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-08-20.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit

extension TravelLocationsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let photoCell = "photoCell"
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCell, for: indexPath)
		return cell
	}

	func showPhotoAlbum(photos: [UIImage]){
		guard let window = UIApplication.shared.keyWindow else { return }
		
		setUpCollectionView(window)

		//Animate the views
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.collectionView.frame = CGRect(x: 0, y: window.frame.height/2, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
			self.view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height/2)
		}, completion: nil)

		setUpActivityIndicator(window)
	}

	fileprivate func setUpCollectionView(_ window: UIWindow) {
		self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		self.collectionView.backgroundColor = .white
		self.collectionView.delegate = self
		self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height/2)
		window.addSubview(self.collectionView)
	}

	fileprivate func setUpActivityIndicator(_ window: UIWindow) {
		self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
		self.activityIndicator.center = self.collectionView.center
		self.activityIndicator.color = .black
		self.activityIndicator.hidesWhenStopped = true
		window.addSubview(self.activityIndicator)
	}

	@objc func dismissPhotoAlbumView(){
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
			guard let window = UIApplication.shared.keyWindow else { return }
			self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: self.collectionView.frame.height)
			self.view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
		}, completion: nil)
		self.instructionLabel.text = instructionLabelLongPress
	}
}
