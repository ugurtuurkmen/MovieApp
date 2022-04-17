//
//  DetailViewController.swift
//  MovieApp
//
//  Created by UgurTurkmen on 17.04.2022.
//

import UIKit

class DetailViewController: UIViewController {
    var id : Int? = nil
    var imageUrl = URL(string: "")
    var movie : Movie?
    
    let movieService = MovieService.instance
    
    @IBOutlet weak var imdbImage: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDetail: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
        getData()
        movieService.delegate = self
        
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getData(){
        if let id = id {
            let url = "https://api.themoviedb.org/3/movie/\(id)?api_key=50a1b135877c2ccef3dca09681dd3e50&language=en-US"
            movieService.fetchSingleMovie(url: url) { movies in
                if let movies = movies {
                    self.imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movies.poster_path)")
                    DispatchQueue.main.async {
                        self.movie = movies
                        self.movieImage.sd_setImage(with: self.imageUrl, completed: nil)
                        self.movieTitle.text = movies.original_title
                        self.movieDescription.text = movies.overview
                        self.movieDetail.text = "⭐️ \(movies.vote_average)/10 * \(movies.release_date)"
                        
                    }
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    


}

extension DetailViewController : MovieErrorDelegate {
    
    func didFailError(error: Error) {
        print(error.localizedDescription)
        DispatchQueue.main.async {
            self.movieImage.isHidden = true
            self.imdbImage.isHidden = true
            self.movieTitle.isHidden = true
            self.movieDetail.isHidden = true
            self.movieDescription.isHidden = true
            self.errorLabel.text = "Error : \(error.localizedDescription)"
            self.errorLabel.isHidden = false
        }
    }
    
    
}
