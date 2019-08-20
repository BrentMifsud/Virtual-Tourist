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
		
		//Set up view for tap recognizer
		tapView.backgroundColor = UIColor(white: 0, alpha: 0)
		tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPhotoAlbumView)))
		window.addSubview(tapView)
		tapView.frame = window.frame
		
		//Set up slide up collection view
		collectionView = showCollectionView()
		window.addSubview(collectionView)
		let height: CGFloat = window.frame.height/2
		let y = window.frame.height - height
		collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
		
		//Animate the views
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
			self.tapView.alpha = 1
			self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
			self.view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height/2)
		}, completion: nil)
	}
	
	func showCollectionView() -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = .white
		cv.delegate = self
		return cv
	}
	
	@objc func dismissPhotoAlbumView(){
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
			guard let window = UIApplication.shared.keyWindow else { return }
			self.tapView.alpha = 0
			self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: self.collectionView.frame.height)
			self.view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
		}, completion: nil)
		self.instructionLabel.text = instructionLabelLongPress
	}
}
