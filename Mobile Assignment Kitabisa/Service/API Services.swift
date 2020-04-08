//
//  Services.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 08/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import Foundation

import Foundation

enum ServiceError: Error{
    case noDataAvailable
    case decodeFail
}

struct MovieService {
    var resourceURL:URL
    
    init(component:String) {
        let resourceString = "https://api.themoviedb.org/3/movie/\(component)?api_key=\(ConstantValue.APIKey)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}

        self.resourceURL = resourceURL
    }
    
    func getMovies(completion: @escaping(Result<[Movie], ServiceError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL){ data, res, error in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(Movies.self, from: jsonData)
                let movies = movieResponse.results
                completion(.success(movies))
            }catch{
                completion(.failure(.decodeFail))
                return
            }
        }
        dataTask.resume()
    }
    
    func getMovieDetails(completion: @escaping(Result<MovieDetails, ServiceError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL){ data, res, error in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieDetails.self, from: jsonData)
                completion(.success(movieResponse))
            }catch{
                completion(.failure(.decodeFail))
                return
            }
        }
        dataTask.resume()
    }
    
}

struct ReviewService {
    var resourceURL:URL
    
    init(id:String) {
        let resourceString = "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=\(ConstantValue.APIKey)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}

        self.resourceURL = resourceURL
    }
    
    func getReviews(completion: @escaping(Result<[ReviewDetails], ServiceError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL){ data, res, error in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let reviewResponse = try decoder.decode(Reviews.self, from: jsonData)
                let reviews = reviewResponse.results
                completion(.success(reviews))
            }catch{
                completion(.failure(.decodeFail))
                return
            }
        }
        dataTask.resume()
    }
    
}
