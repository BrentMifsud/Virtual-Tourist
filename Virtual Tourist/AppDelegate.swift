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
		// Override point for customization after application launch.

		dataController.load()

		guard let travelVC = window?.rootViewController as? TravelLocationsViewController else {
			preconditionFailure("Unable to load Root View Controller")

		}
		
		travelVC.dataController = dataController

		return true
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		try? dataController.save()
	}

	func applicationWillTerminate(_ application: UIApplication) {
		try? dataController.save()
	}


}

