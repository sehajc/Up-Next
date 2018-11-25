//
//  MovieCollectionViewCell.swift
//  UpNext
//
//  Created by Sehaj Chawla on 2018-11-21.
//  Copyright © 2018 Sehaj. All rights reserved.
//

import UIKit

// TODO: Setup placeholder views
class MovieCollectionViewCell: UICollectionViewCell {
	@IBOutlet var title: UILabel!
	@IBOutlet var poster: UIImageView!
	@IBOutlet var favourite: UIButton!
	@IBOutlet var rating: UILabel!
	@IBOutlet var releaseDate: UILabel!
	@IBOutlet var overview: UITextView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
