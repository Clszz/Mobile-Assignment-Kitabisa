//
//  ListMovieViewController.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 08/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import UIKit

enum CardState{
    case expanded
    case collapsed
}

class ListMovieViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var listOfMovies = [Movie]() {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    var cardViewController:CardMenuViewController!
    var visualEffectView:UIVisualEffectView!
    let cardHeight:CGFloat = 320
    let cardHandleAreaHeight:CGFloat = 70
    var cardVisible = false
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgress:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCard()
        requestAPI(category: "popular")
        registerCell()
        cellDelegate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "goToMovieDetails": break
//            let movieDetail = segue.destination as! MovieDetailsViewController
//            let data = sender as? Int
//            movieDetail.id = "\(data!)"
        default:
            break
        }
    }

    @IBAction func favoriteTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToFavorite", sender: nil)
    }
    
}
extension ListMovieViewController{
    
    private func requestAPI(category:String) {
        let movieReq = MovieService(component: category)
        movieReq.getMovies { [weak self] (result) in
            switch result{
            case .failure(_):
                self?.listOfMovies = []
            case .success(let movies):
                self?.listOfMovies = movies
            }
        }
    }
    
    private func setupCard() {
        cardViewController = CardMenuViewController(nibName: "CardMenuViewController", bundle: nil)
        self.addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        cardViewController.delegate = self
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        cardViewController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListMovieViewController.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ListMovieViewController.handleCardPan(recognizer:)))
        
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 1)
        default:
            break
        }
    }
    
    @objc func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 1)
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.cardViewController.view.layer.cornerRadius = 15
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                }
            }
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgress = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgress
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

}
extension ListMovieViewController:CategoryProtocol{
    func categoryTapped(category: String) {
        requestAPI(category: category)
        animateTransitionIfNeeded(state: nextState, duration: 1)
    }
}
extension ListMovieViewController:UITableViewDataSource, UITableViewDelegate{
    private func registerCell() {
        tableView.register(UINib(nibName: "ListMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "ListMovieTableViewCellID")
    }
    
    private func cellDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListMovieTableViewCellID", for: indexPath) as! ListMovieTableViewCell
        let movie = listOfMovies[indexPath.row]
        let completeLink = ConstantValue.defaultLink + movie.poster_path
        
        cell.posterImage.downloaded(from: completeLink, contentMode: .scaleAspectFill)
        cell.setCell(titleText: movie.original_title, date: movie.release_date, description: movie.overview)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMovieDetails", sender: listOfMovies[indexPath.row].id)
    }
    
}
