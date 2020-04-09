//
//  MovieDetailViewController.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 08/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var id:String!
    var movieDetails:MovieDetails!
    var listOfFavorites:[FavoriteMovie]?
    var listOfReviews = [ReviewDetails](){
        didSet{
            DispatchQueue.main.async {
                self.checkTableData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        checkFavorite()
    }
    
    @IBAction func favoriteTapped(_ sender: Any) {
        inspectFavorite()
    }
    
}
extension MovieDetailViewController{
    private func setupMainInterface() {
        let completeLink = ConstantValue.defaultLink + movieDetails.poster_path
        
        outerView.outerRoundvVer2()
        outerView.dropShadow()
        posterImage.downloaded(from: completeLink, contentMode: .scaleAspectFill)
        movieTitleLabel.text = movieDetails.original_title
        releaseDateLabel.text = movieDetails.release_date
        overviewLabel.text = movieDetails.overview
    }
    
    private func requestMovieDetails(id:String) {
        let movieReq = MovieService(component: id)
        movieReq.getMovieDetails { [weak self] (result) in
            switch result{
            case .failure(_):
                fatalError()
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
            case .failure(_):
                fatalError()
            case .success(let reviews):
                self?.listOfReviews = reviews
            }
        }
    }
    
    private func findAndDelete() {
        for (index,item) in listOfFavorites!.enumerated(){
            if String(item.id) == id{
                deleteFavorites(index: index)
            }
        }
    }
    
    private func inspectFavorite() {
        if !favoriteButton.isSelected{
            saveFavorites { (complete) in if complete{return}}
        }else{
            findAndDelete()
        }
        favoriteButton.isSelected = !favoriteButton.isSelected
    }
    
    private func isSelected() {
        for item in listOfFavorites!{
            if String(item.id) == id{
                favoriteButton.isSelected = !favoriteButton.isSelected
            }
        }
    }
    
    private func checkFavorite() {
        requestFavorites { (success) in
            if success { isSelected() }
        }
    }
    
    private func checkTableData() {
        if listOfReviews.isEmpty{
            self.tableView.tableFooterView = UIView()
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Review"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
        }
    }
    
}
extension MovieDetailViewController:CoreDataServiceProtocol{
    internal func requestFavorites(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
        do {
            listOfFavorites = try  managedContext.fetch(request) as? [FavoriteMovie]
            completion(true)
        } catch {
            print("Unable to fetch data: ", error.localizedDescription)
            completion(false)
        }
    }
    
    internal func saveFavorites(completion: (_ finished:Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let movie = FavoriteMovie(context: managedContext)
        movie.id = Int32(id) ?? 0
        movie.original_title = movieDetails.original_title
        movie.poster_path = movieDetails.poster_path
        movie.release_date = movieDetails.release_date
        movie.overview = movieDetails.overview
        do{
            try managedContext.save()
            completion(true)
        }catch{
            completion(false)
        }
    }
    
    internal func deleteFavorites(index: Int) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete((listOfFavorites?[index])!)
        do {
            try managedContext.save()
        } catch {
            print("Failed to delete data: ", error.localizedDescription)
        }
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
