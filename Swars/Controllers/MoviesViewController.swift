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
        loadDataFromServer()

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
