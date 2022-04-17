//
//  HomeTableViewCell.swift
//  MovieApp
//
//  Created by UgurTurkmen on 17.04.2022.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var movieDate: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
