//
//  Mobile_Assignment_KitabisaTests.swift
//  Mobile Assignment KitabisaTests
//
//  Created by Muhammad Reynaldi on 08/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import XCTest
import CoreData
@testable import Mobile_Assignment_Kitabisa

class Mobile_Assignment_KitabisaTests: XCTestCase {
    
    let listMovie = MovieService(component: "popular")
    let movieDetail = MovieService(component: "690560")
    let listReview = ReviewService(id: "690560")
    var listOfFavorites:[FavoriteMovie]?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
    
    
    func testRequestMovie() {
        let dataTask = URLSession.shared.dataTask(with: listMovie.resourceURL){ data, res, error in
            XCTAssert(data != nil, "Must be contain data")
            guard let jsonData = data else { XCTFail()
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(Movies.self, from: jsonData)
                let movies = movieResponse.results
                XCTAssertNotNil(movies)
            }catch{
                XCTFail(error.localizedDescription)
                return
            }
        }
        dataTask.resume()
    }
    
    func testRequestMovieDetail() {
        let dataTask = URLSession.shared.dataTask(with: movieDetail.resourceURL){ data, res, error in
            XCTAssert(data != nil, "Must be contain data")
            guard let jsonData = data else { XCTFail()
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieDetails.self, from: jsonData)
                XCTAssertNotNil(movieResponse)
            }catch{
                XCTFail(error.localizedDescription)
                return
            }
        }
        dataTask.resume()
    }
    
    func testRequestReviews() {
        let dataTask = URLSession.shared.dataTask(with: listReview.resourceURL){ data, res, error in
            XCTAssert(data != nil, "Must be contain data")
            guard let jsonData = data else { XCTFail()
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let reviewResponse = try decoder.decode(Reviews.self, from: jsonData)
                let reviews = reviewResponse.results
                XCTAssertNotNil(reviews)
            }catch{
                XCTFail(error.localizedDescription)
                return
            }
        }
        dataTask.resume()
    }
    
    func testRequestFavorites() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        do {
            listOfFavorites = try  managedContext.fetch(request) as? [FavoriteMovie]
            XCTAssertNotNil(listOfFavorites)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testSaveFavorites() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        saveData(context: managedContext)
        do{
            try managedContext.save()
            testRequestFavorites()
        }catch{
            XCTFail("Cannot Save Data")
        }
        
    }
    
    func testDeleteFavorites() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        saveData(context: managedContext)
        testRequestFavorites()
        managedContext.delete((listOfFavorites?[0])!)
        do {
            try managedContext.save()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
}
extension Mobile_Assignment_KitabisaTests{
    private func saveData(context:NSManagedObjectContext) {
        let movie = FavoriteMovie(context: context)
        movie.id = Int32(00)
        movie.original_title = "Bloodshot"
        movie.poster_path = "bloodshot.jpg"
        movie.release_date = "2020-02-02"
        movie.overview = "Vin diesel as an actor"
    }
}
