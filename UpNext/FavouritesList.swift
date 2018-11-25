//
//  FavouritesList.swift
//  UpNext
//
//  Created by Sehaj Chawla on 2018-11-24.
//  Copyright © 2018 Sehaj. All rights reserved.
//

import Foundation

// TODO: Using UserDefaults because its fast for this prototype. Use KeyedArchiver later
struct FavouritesList {
	
	static private let defaults = UserDefaults.standard
	static private let key = "FavouriteMovies"
	
	private init() {}
	
	static func addFavourite(_ id: Int) {
		var favouriteMovies = savedFavourites()
		favouriteMovies.append(id)
		saveFavourites(ids: favouriteMovies)
	}
	
	static func removeFavourite(_ id: Int) {
		var favouriteMovies = savedFavourites()
		if let index = favouriteMovies.index(of: id) {
			favouriteMovies.remove(at: index)
		}
		saveFavourites(ids: favouriteMovies)
	}
	
	static func isFavourite(_ id: Int) -> Bool {
		let favouriteMovies = savedFavourites()
		return favouriteMovies.index(of: id) != nil
	}
	
	private static func savedFavourites() -> [Int] {
		return defaults.array(forKey: key) as? [Int] ?? [Int]()
	}
	
	private static func saveFavourites(ids: [Int]) {
		UserDefaults.standard.set(ids, forKey: key)
		UserDefaults.standard.synchronize()
	}
}
