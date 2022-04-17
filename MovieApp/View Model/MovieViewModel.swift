//
//  MovieViewModel.swift
//  MovieApp
//
//  Created by UgurTurkmen on 17.04.2022.
//

import Foundation


struct MovieUpComingListViewModel {
    let movieList : [Movie]
    
    func numberOfRowsInSection() -> Int {
         return self.movieList.count
    }
    
    func movieAtIndex(_ index : Int) -> MovieViewModel {
        let movie = self.movieList[index]
        return MovieViewModel(movie)
    }
    
}

struct MovieNowPlayingListViewModel {
    let movieList : [Movie]
    
    func numberOfRowsInSection() -> Int {
         return self.movieList.count
    }
    
    func movieAtIndex(_ index : Int) -> MovieViewModel {
        let movie = self.movieList[index]
        return MovieViewModel(movie)
    }
    
}

struct MovieViewModel {
    let movie : Movie
    init(_ movies : Movie){
        self.movie = movies
    }
    
    var id : Int {
        return self.movie.id
    }
    
    var original_title : String {
        return self.movie.original_title
    }
    
    var poster_path : String {
        return self.movie.poster_path
    }
    
    var overview : String {
        return self.movie.overview
    }
    
    var vote_average : Double {
        return self.movie.vote_average
    }
    
    var release_date : String {
        return self.movie.release_date
    }
}
