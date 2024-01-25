//
//  AppDelegate.swift
//  Exercises
//
//  Created by Andrey Lebedev on 20.01.2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		var vc = ExercisesScreenFactory().make()
		window?.rootViewController = UINavigationController(rootViewController: vc)
		window?.makeKeyAndVisible()
		return true
	}
}
