//
//  PhotoDetailViewController.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-09-13.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var imageTitle: UILabel!
	@IBOutlet weak var url: UIButton!
	@IBOutlet weak var imageHeight: UILabel!
	@IBOutlet weak var imageWidth: UILabel!

	var dataController: DataController!

	var image: Photo!

	override func viewDidLoad() {
		super.viewDidLoad()

		guard let image = self.image.image else { preconditionFailure("No image passed to photo view controller")}

		self.imageView.image = image
		self.imageTitle.text = self.image.title
		self.url.setTitle(self.image.url?.absoluteString, for: .normal)
		self.imageHeight.text = self.image.height
		self.imageWidth.text = self.image.width
	}

	@IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
		DispatchQueue.main.async {
			self.dismiss(animated: true) {
				do{
					self.dataController.viewContext.delete(self.image)
					try self.dataController.save()
				}catch {
					print("Error deleting image")
				}
			}
		}
	}


	/*
	// MARK: - Navigation

	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/

}
