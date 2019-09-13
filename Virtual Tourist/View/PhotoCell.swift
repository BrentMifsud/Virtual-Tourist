//
//  PhotoCell.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-12.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
	@IBOutlet weak var imageView: UIImageView!

	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	var photo: Photo!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
