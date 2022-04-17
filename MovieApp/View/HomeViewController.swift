//
//  ViewController.swift
//  MovieApp
//
//  Created by UgurTurkmen on 17.04.2022.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {

    
    let images = [UIImage(named: "manzara3")!,UIImage(named: "manzara5")!]
    var currentCellIndex = 0
    var selectMovie : MovieViewModel?
    
    private var movieUpComingListViewModel : MovieUpComingListViewModel!
    private var movieNowPlayingListViewModel : MovieNowPlayingListViewModel!
    
    let movieService = MovieService.instance
    
    let upComingUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=50a1b135877c2ccef3dca09681dd3e50&language=en-US&page=1"
    let nowPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=50a1b135877c2ccef3dca09681dd3e50&language=en-US&page=1"
    let imageBaseUrl = "https://image.tmdb.org/t/p/w185"
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        errorLabel.isHidden = true
        movieService.delegate = self
        getData()
    }
    
    func getData() {
        
        movieService.fetchMovie(url: upComingUrl) { movieList in
            if let movieList = movieList {
                self.movieUpComingListViewModel = MovieUpComingListViewModel(movieList: movieList)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        movieService.fetchMovie(url: nowPlayingUrl) { movieList in
            if let movieList = movieList {
                self.movieNowPlayingListViewModel = MovieNowPlayingListViewModel(movieList: movieList)
                DispatchQueue.main.async {
                    self.pageController.numberOfPages = self.movieNowPlayingListViewModel.numberOfRowsInSection()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey]{
                let newSize = newValue as! CGSize
                self.tableViewHeight.constant = newSize.height
            }
        }
    }
    
}


extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieUpComingListViewModel == nil ? 0 : self.movieUpComingListViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTableViewCell
        let movieViewModel = self.movieUpComingListViewModel.movieAtIndex(indexPath.row)
        let imageUrl = imageBaseUrl + movieViewModel.poster_path
        cell.movieImage.layer.cornerRadius = 10
        cell.movieImage.sd_setImage(with: URL(string: imageUrl), completed: nil)
        cell.movieTitle.text = movieViewModel.original_title
        cell.movieDescription.text = movieViewModel.overview
        cell.movieDate.text = movieViewModel.release_date
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectMovie =  self.movieUpComingListViewModel.movieAtIndex(indexPath.row)
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destination = segue.destination as! DetailViewController
            destination.id = selectMovie?.id
        }
    }
    
}


extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! HomeCollectionViewCell
        let movieNowPlaying = self.movieNowPlayingListViewModel.movieAtIndex(indexPath.row)
        let imageUrl = imageBaseUrl + movieNowPlaying.poster_path
        cell.imageCell.sd_setImage(with: URL(string: imageUrl), completed: nil)
        cell.titleCell.text = movieNowPlaying.original_title
        cell.descriptionCell.text = movieNowPlaying.overview
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieNowPlayingListViewModel == nil ? 0 : self.movieNowPlayingListViewModel.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentCellIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        pageController.currentPage = currentCellIndex
    }
    
   
}

extension HomeViewController : MovieErrorDelegate {
    
    func didFailError(error: Error) {
        print(error.localizedDescription)
        DispatchQueue.main.async {
            self.collectionView.isHidden = true
            self.tableView.isHidden = true
            self.errorLabel.text = "Error : \(error.localizedDescription)"
            self.errorLabel.isHidden = false
        }
    }
}
