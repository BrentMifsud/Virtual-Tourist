//
//  AppDelegate.swift
//  Virtual Tourist
//
//  Created by Brent Mifsud on 2019-07-09.
//  Copyright © 2019 Brent Mifsud. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	let dataController = DataController(modelName: "VirtualTourist")

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Set up the data controller
		dataController.load()
		
		// Set up Initial view controller
		guard let navVC = window?.rootViewController as? UINavigationController else { preconditionFailure("\nERROR:\nUnable to load root view controller") }

		guard let pinVC = navVC.viewControllers.first as? PinViewController else { preconditionFailure("\nERROR:\nUnable to load PinViewController") }

		pinVC.dataController = dataController

		pinVC.pinStore = PinCoreData()

		pinVC.albumStore = PhotoAlbumCoreData(photoCoreData: PhotoCoreData())

		pinVC.flickrClient = FlickrClient(
			networkClient: NetworkClient(urlSession: .shared),
			photoAlbumStore: pinVC.albumStore,
			dataController: dataController
		)

		return true
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		try? dataController.save()
	}

	func applicationWillTerminate(_ application: UIApplication) {
		try? dataController.save()
	}


}

