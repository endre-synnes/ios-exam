//
//  MoviesViewController.swift
//  Swars


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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MoviesTableViewCell
        
        cell.movieNameLabel.text = movies[indexPath.row].title
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "segueToMovieDetails", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
            destination.movie = movies[indexPath.row]
        }
    }
    
    func loadDataFromServer() {
        loadMoviesFromServer { (movies) in
            self.movies = movies
            self.movies = self.movies.sorted{ $0.episode_id < $1.episode_id}
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}
