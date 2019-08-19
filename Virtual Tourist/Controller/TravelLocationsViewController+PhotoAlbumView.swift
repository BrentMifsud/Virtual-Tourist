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

		//Set up Dark view
		darkView.backgroundColor = UIColor(white: 0, alpha: 0.5)
		darkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPhotoAlbumView)))
		window.addSubview(darkView)
		darkView.frame = window.frame
		darkView.alpha = 0

		//Set up slide up collection view
		collectionView = showCollectionView(photos: photos)
		window.addSubview(collectionView)
		let height: CGFloat = window.frame.height/2
		let y = window.frame.height - height
		collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)

		//Animate the views
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.darkView.alpha = 1
			self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
		}, completion: nil)
	}

	func showCollectionView(photos: [UIImage]) -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = .white
		return cv
	}

	@objc func dismissPhotoAlbumView(){
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
			guard let window = UIApplication.shared.keyWindow else { return }
			self.darkView.alpha = 0
			self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: self.collectionView.frame.height)
		}, completion: nil)
		self.instructionLabel.text = instructionLabelLongPress
	}
}
