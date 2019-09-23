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

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Set up the data controller
		DataController.shared.load()

		return true
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		try? DataController.shared.save()
	}

	func applicationWillTerminate(_ application: UIApplication) {
		try? DataController.shared.save()
	}


}

