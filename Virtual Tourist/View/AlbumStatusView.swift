//
//  AlbumStatusView.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-21.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit

class AlbumStatusView: UIView {

	var activityIndicator: UIActivityIndicatorView!
	var statusLabel: UILabel!

	enum State: String {
		case downloading = "Downloading Images..."
		case noImagesFound = "No Images found for this location."
		case displayImages
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.setUpView()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setUpView() {
		// Set up label
		statusLabel = UILabel()
		addSubview(statusLabel)
		statusLabel.translatesAutoresizingMaskIntoConstraints = false
		statusLabel.textAlignment = .center
		statusLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
		statusLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
		statusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
		statusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
		statusLabel.sizeToFit()

		// Set up activity indicator
		activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
		activityIndicator.hidesWhenStopped = true
		addSubview(activityIndicator)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.color = .black
		activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
		activityIndicator.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -10).isActive = true
	}

	func setState(state: State) {
		switch state {
		case .downloading:
			activityIndicator.startAnimating()
			statusLabel.text = state.rawValue
			self.isHidden = false
		case .noImagesFound:
			activityIndicator.stopAnimating()
			activityIndicator.isHidden = true
			statusLabel.text = state.rawValue
			self.isHidden = false
		case .displayImages:
			activityIndicator.stopAnimating()
			self.isHidden = true
		}
	}

}