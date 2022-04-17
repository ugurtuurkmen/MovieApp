//
//  MovieService.swift
//  MovieApp
//
//  Created by UgurTurkmen on 17.04.2022.
//

import Foundation

protocol MovieErrorDelegate {
    func didFailError(error : Error)
}


class MovieService {
    
    static let instance = MovieService()
    
    var delegate : MovieErrorDelegate?
    
    func fetchMovie(url:String , completion: @escaping ([Movie]?) -> ()){
        var movieList : [Movie]?
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailError(error: error!)
                }else {
                    if data != nil {
                        do {
                            let decodeData = try JSONDecoder().decode(MovieModel.self, from: data!)
                            movieList = decodeData.results
                            completion(movieList)
                        } catch{
                            self.delegate?.didFailError(error: error)
                        }
                    }
                }
            }
            dataTask.resume()
        }
        
    }
    
    func fetchSingleMovie(url: String ,completion: @escaping (Movie?) -> ()){
        if let url = URL(string: url){
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let dataTask = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailError(error: error!)
                }else {
                    if data != nil {
                        do {
                           let decodeData =  try JSONDecoder().decode(Movie.self, from: data!)
                            completion(decodeData)
                        } catch {
                            self.delegate?.didFailError(error: error)
                        }
                    }
                }
            }
            dataTask.resume()
        }
        
    }
    
}
