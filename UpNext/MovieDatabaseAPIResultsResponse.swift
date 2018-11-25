//
//  MovieDatabaseAPIResultsResponse.swift
//  UpNext
//
//  Created by Sehaj Chawla on 2018-11-24.
//  Copyright © 2018 Sehaj. All rights reserved.
//

import Foundation

struct MovieDatabaseAPIResultsResponse: Codable {
	let results: [MovieResult]
	
	struct MovieResult: Codable {
		let id: Int
		let voteAverage: Double
		let title: String
		let posterPath: String?
		let overview: String
		let releaseDate: String
		
		enum CodingKeys: String, CodingKey {
			case id
			case title
			case overview
			case voteAverage = "vote_average"
			case posterPath = "poster_path"
			case releaseDate = "release_date"
		}
	}
}
