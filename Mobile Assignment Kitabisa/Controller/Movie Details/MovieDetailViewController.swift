//
//  MovieDetailViewController.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 08/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var id:String!
    var movieDetails:MovieDetails!
    var listOfReviews = [ReviewDetails](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMovieDetails(id: id)
        requestReviews(id: id)
        registerCell()
        cellDelegate()
    }
    
}
extension MovieDetailViewController{
    private func requestMovieDetails(id:String) {
        let movieReq = MovieService(component: id)
        movieReq.getMovieDetails { [weak self] (result) in
            switch result{
            case .failure(let err):
                print(err)
            case .success(let movieDetail):
                self?.movieDetails = movieDetail
                DispatchQueue.main.async {
                    self?.setupMainInterface()
                }
            }
        }
    }
    
    private func requestReviews(id:String) {
        let reviewReq = ReviewService(id: id)
        reviewReq.getReviews { [weak self] (result) in
            switch result{
            case .failure(let err):
                print(err)
            case .success(let reviews):
                self?.listOfReviews = reviews
            }
        }
    }
    private func setupMainInterface() {
        let defaultLink = "https://image.tmdb.org/t/p/w300"
        let completeLink = defaultLink + movieDetails.poster_path
        
        posterImage.downloaded(from: completeLink, contentMode: .scaleAspectFill)
        movieTitleLabel.text = movieDetails.original_title
        releaseDateLabel.text = movieDetails.release_date
        overviewLabel.text = movieDetails.overview
    }
}
extension MovieDetailViewController:UITableViewDataSource, UITableViewDelegate{
    private func registerCell() {
        tableView.register(UINib(nibName: "ListReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ListReviewTableViewCellID")
    }
    
    private func  cellDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListReviewTableViewCellID", for: indexPath) as! ListReviewTableViewCell
        
        let data = listOfReviews[indexPath.row]
        
        cell.setCell(initialText: data.author, authorText: data.author, urlText: data.url, contentText: data.content)
        return cell
    }
    
}
