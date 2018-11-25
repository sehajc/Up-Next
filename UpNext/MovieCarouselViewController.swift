//
//  HomeViewController.swift
//  UpNext
//
//  Created by Sehaj Chawla on 2018-11-17.
//  Copyright © 2018 Sehaj. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCarouselViewController: UIViewController {
	
	private var nowPlayingMovies: [Movie]?
	private var topRatedMovies: [Movie]?
	private var	displayMode = DisplayMode.nowPlaying
	var movieWebService: MovieDatabaseNetworkService!
	
	@IBOutlet var movieCollectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if movieWebService == nil {
			movieWebService = MovieDatabaseNetworkService() // Fallback, if a webservice wasn't injected into this view controller
			movieWebService.delegate = self
			movieWebService.fetchNowPlaying()
		}
	}
	
	@IBAction func switchMode(_ segmentedControl: UISegmentedControl) {
		if segmentedControl.selectedSegmentIndex == 0 {
			displayMode = .nowPlaying
		}
		if segmentedControl.selectedSegmentIndex == 1 {
			displayMode = .topRated
		}
		movieCollectionView.reloadData()
		movieCollectionView.setContentOffset(.zero, animated: false)
	}
	
	@IBAction func favouriteTapped(_ button: UIButton) {
		if displayMode == .nowPlaying {
			nowPlayingMovies?[button.tag].toggleFavourite()
		}
		if displayMode == .topRated {
			topRatedMovies?[button.tag].toggleFavourite()
		}
		movieCollectionView.reloadItems(at: [IndexPath(item: button.tag, section: 0)])
	}
	
	@IBAction func refreshTapped(_ sender: UIBarButtonItem) {
		movieWebService.fetchNowPlaying()
		movieWebService.fetchTopRated()
	}
	
	
	private enum DisplayMode {
		case nowPlaying
		case topRated
	}
}

extension MovieCarouselViewController: MovieDatabaseNetworkServiceDelegate {
	func didFetchNowPlaying(movies: [Movie]) {
		nowPlayingMovies = movies
		if displayMode == .nowPlaying {
			DispatchQueue.main.async { [unowned self] in
				self.movieCollectionView.reloadData()
			}
		}
	}
	
	func didFetchTopRated(movies: [Movie]) {
		topRatedMovies = movies
		if displayMode == .topRated {
			DispatchQueue.main.async { [unowned self] in
				self.movieCollectionView.reloadData()
			}
		}
	}
}

extension MovieCarouselViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 20
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
		let movieToShow: Movie?
		switch displayMode {
		case .nowPlaying:
			movieToShow = nowPlayingMovies?[indexPath.item]
		case .topRated:
			movieToShow = topRatedMovies?[indexPath.item]
		}
		guard let movie = movieToShow else { return cell }
		cell.title.text = movie.title
		cell.poster.kf.setImage(with: movie.poster)
		cell.favourite.tag = indexPath.item
		if movie.favourite {
			cell.favourite.imageView?.image = UIImage(imageLiteralResourceName: "favourite")
		} else {
			cell.favourite.imageView?.image = UIImage(imageLiteralResourceName: "unfavourite")
		}
		cell.rating.text = String(format:"%.1f", movie.voteAverage)
		if let releaseDate = movie.releaseDate {
			let dateFormatter = DateFormatter()
			dateFormatter.dateStyle = .long
			cell.releaseDate.text = dateFormatter.string(from: releaseDate)
		} else {
			cell.releaseDate.text = ""
		}
		cell.overview.text = movie.overview
		return cell
	}
}

extension MovieCarouselViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: collectionView.frame.width * 0.65, height: collectionView.frame.height) // 65% width, 100% height
	}
}
