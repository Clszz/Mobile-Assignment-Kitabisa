//
//  APIClientProtocols.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 09/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import Foundation

protocol MovieAPIProtocol {
    func getMovies(completion: @escaping(Result<[Movie], ServiceError>) -> Void)
    func getMovieDetails(completion: @escaping(Result<MovieDetails, ServiceError>) -> Void)
}

protocol ReviewAPIProtocol {
    func getReviews(completion: @escaping(Result<[ReviewDetails], ServiceError>) -> Void)
}
