//
//  MovieDetailsViewController.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 09/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var movie : Movie?
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = movie?.title

        movieTitleLabel.text = "Title: \(movie?.title ?? "")"
        directorLabel.text = "Director: \(movie?.director ?? "")"
        producerLabel.text = "Producer: \(movie?.producer ?? "")"
        releaseDateLabel.text = "Release date: \(movie?.release_date ?? "")"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
