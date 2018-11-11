//
//  CharacterTableViewCell.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 11/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var moviesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customInit(name: String, movies: String? = "") {
        nameLabel.text = name
        moviesLabel.text = movies
    }
    
}
