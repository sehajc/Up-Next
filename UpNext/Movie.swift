//
//  Movie.swift
//  UpNext
//
//  Created by Sehaj Chawla on 2018-11-21.
//  Copyright © 2018 Sehaj. All rights reserved.
//

import Foundation

struct Movie {
	let id: Int
	let poster: URL?
	let title: String
	let overview: String
	let voteAverage: Double
	let releaseDate: Date?
	var favourite: Bool
	
	init(from service: MovieDatabaseAPIResultsResponse.MovieResult) {
		if let posterRelativePath = service.posterPath {
			poster = URL(string: MovieDatabaseNetworkService.imageBasePath + MovieDatabaseNetworkService.posterSizePath + posterRelativePath)
		} else {
			poster = nil
		}
		id = service.id
		title = service.title
		overview = service.overview
		voteAverage = service.voteAverage
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		releaseDate = formatter.date(from: service.releaseDate)
		favourite = FavouritesList.isFavourite(id)
	}
	
	mutating func toggleFavourite() {
		favourite = !favourite
		favourite ? FavouritesList.addFavourite(id) : FavouritesList.removeFavourite(id)
	}
}
