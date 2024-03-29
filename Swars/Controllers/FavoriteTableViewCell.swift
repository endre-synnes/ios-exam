//
//  CharacterTableViewCell.swift
//  Swars


import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var moviesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func customInit(name: String, movies: String? = "") {
        nameLabel.text = name
        moviesLabel.text = movies
    }
    
}
