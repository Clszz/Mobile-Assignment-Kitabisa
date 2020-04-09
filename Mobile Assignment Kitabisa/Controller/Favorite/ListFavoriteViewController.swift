//
//  ListFavoriteViewController.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 09/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import UIKit
import CoreData

class ListFavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var listOfFavorites:[FavoriteMovie]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        requestFavorites { (success) in
            if success{
                cellDelegate()
            }else{
                updateTable()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTable()
    }
    
}
extension ListFavoriteViewController{
    private func requestFavorites(completion: (_ complete: Bool) -> ()) {
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
    
    func updateTable() {
        if listOfFavorites!.isEmpty{
            self.tableView.tableFooterView = UIView()
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No Favorite Data"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
        }
    }
    
}
extension ListFavoriteViewController:UITableViewDataSource,UITableViewDelegate{
    private func registerCell() {
        tableView.register(UINib(nibName: "ListFavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "ListFavoriteTableViewCellID")
    }
    
    private func cellDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFavorites?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListFavoriteTableViewCellID", for: indexPath) as! ListFavoriteTableViewCell
        guard let favorite = listOfFavorites?[indexPath.row] else { return cell }
        cell.setCell(poster_path: favorite.poster_path!, titleText: favorite.original_title!, date: favorite.release_date!, description: favorite.overview!)
        return cell
    }
    
}
