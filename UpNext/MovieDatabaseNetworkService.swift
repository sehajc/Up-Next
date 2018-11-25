//
//  MovieDatabaseNetworkService.swift
//  UpNext
//
//  Created by Sehaj Chawla on 2018-11-20.
//  Copyright © 2018 Sehaj. All rights reserved.
//

import Foundation

// TODO: Add notification support as well
// TODO: Convert networking class to operations and use operation queues to orchestrate calls that are dependent on each other
// TODO: Error handling. Delegate and completion handlers error support
// TODO: Pagination support
// TODO: Use the configuration API to fetch image base URL and poster sizes
// TODO: Add region support based on the user 

protocol MovieDatabaseNetworkServiceDelegate: class {
	func didFetchNowPlaying(movies: [Movie])
	func didFetchTopRated(movies: [Movie])
}

class MovieDatabaseNetworkService {
	private let apiKey = "87d973df17fd3fb419ff3cd92f0d90f7"
	private let nowPlayingPath = "https://api.themoviedb.org/3/movie/now_playing?api_key="
	private let topRatedPath = "https://api.themoviedb.org/3/movie/top_rated?api_key="
	static let imageBasePath = "https://image.tmdb.org/t/p/"
	static let posterSizePath = "w780"
	weak var delegate: MovieDatabaseNetworkServiceDelegate?
	
	func fetchNowPlaying(completion: (([Movie]?) -> Void)? = nil) {
		guard let url = URL(string: nowPlayingPath + apiKey) else {
			fatalError("Unable to make a URL object")
		}
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "Now playing response error")
				completion?(nil)
				return
			}
			do {
				let decoder = JSONDecoder()
				let movieResultsResponse = try decoder.decode(MovieDatabaseAPIResultsResponse.self, from: data)
				let nowPlayingMovies = movieResultsResponse.results.map { Movie(from: $0) }
				self.delegate?.didFetchNowPlaying(movies: nowPlayingMovies)
				completion?(nowPlayingMovies)
				return
			} catch {
				print(error.localizedDescription)
				completion?(nil)
				return
			}
		}
		task.resume()
	}
	
	func fetchTopRated(completion: (([Movie]?) -> Void)? = nil) {
		guard let url = URL(string: topRatedPath + apiKey) else {
			fatalError("Unable to make top rated URL")
		}
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard let data = data, error == nil else {
				print(error?.localizedDescription ?? "Top rated response error")
				completion?(nil)
				return
			}
			do {
				let decoder = JSONDecoder()
				let movieResultsResponse = try decoder.decode(MovieDatabaseAPIResultsResponse.self, from: data)
				let topRatedMovies = movieResultsResponse.results.map { Movie(from: $0) }
				self.delegate?.didFetchTopRated(movies: topRatedMovies)
				completion?(topRatedMovies)
				return
			} catch {
				print(error.localizedDescription)
				completion?(nil)
				return
			}		}
		task.resume()
	}
}
