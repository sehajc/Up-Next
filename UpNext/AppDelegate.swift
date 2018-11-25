//
//  AppDelegate.swift
//  UpNext
//
//  Created by Sehaj Chawla on 2018-11-17.
//  Copyright © 2018 Sehaj. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let movieWebService = MovieDatabaseNetworkService()
		let movieCarouselViewController = window!.rootViewController! as! MovieCarouselViewController
		movieCarouselViewController.movieWebService = movieWebService
		movieWebService.delegate = movieCarouselViewController
		movieWebService.fetchNowPlaying { _ in
			movieWebService.fetchTopRated()
		}
		return true
	}
}
