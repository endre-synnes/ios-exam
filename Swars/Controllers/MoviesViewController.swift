//
//  MoviesViewController.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 08/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // Using helper method to check for internet connection
        if(Helper.app.isInternetAvailable()){
            loadDataFromServer()
        } else {
            let alert = UIAlertController(title: "No internet connection!", message: "Ensure that WiFi or cellular is enabled.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {action in
                self.viewDidLoad()
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as!
        MoviesTableViewCell
        
        cell.movieNameLabel.text = movies[indexPath.row].title
        
        //Tar bort bakgrunnsfarge når man klikker på en tabellrad
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did hit did select for index: \(indexPath)")

        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "segueToMovieDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
            destination.movie = movies[indexPath.row]
        }
    }
    
    func loadDataFromServer() {
        let task = URLSession.shared.dataTask(with: URL.init(string: "https://swapi.co/api/films/?format=json")!) { (data, response, error) in
            
            if let actualData = data {
                
                _ = String.init(data: actualData, encoding: String.Encoding.utf8)
                
                let decoder = JSONDecoder()
                                
                do {
                    let movieResponse = try decoder.decode(MovieResponse.self, from: actualData)
                    self.movies = movieResponse.results
                    
                    //Siden kun main thread har lov til å gjøre UI opdpateringer så må man få tilgang til main thread og så kjøre kode på den for å oppdatere UI.
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    for movie in movieResponse.results {
                        print(movie.title)
                    }
                } catch let error {
                    print(error)
                }
                
            }
        }
        
        task.resume()
    }

}
