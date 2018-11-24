//
//  MoviesTableViewCell.swift
//  Swars


import UIKit

class MoviesTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
