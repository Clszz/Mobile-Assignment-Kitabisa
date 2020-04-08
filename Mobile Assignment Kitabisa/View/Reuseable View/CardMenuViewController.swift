//
//  CardMenuViewController.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 08/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import UIKit

class CardMenuViewController: UIViewController {
    
    @IBOutlet weak var anchorView: UIView!
    @IBOutlet weak var handleArea: UIView!
    @IBOutlet weak var tableView: UITableView!
    var menuCategory:[(key:String,value:String)] = [("Popular"
        ,"popular"),("Upcoming","upcoming"),("Top Rated","top_rated"),("Now Playing","now_playing")]
    var delegate:CategoryProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        cellDelegate()
        setupInterface()
    }
    
}
extension CardMenuViewController{
    private func setupInterface() {
        anchorView.outerRound()
    }
}
extension CardMenuViewController:UITableViewDataSource,UITableViewDelegate{
    private func registerCell() {
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCellID")
    }
    
    private func cellDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCellID", for: indexPath) as! CategoryTableViewCell
        
        cell.setCell(menuTitle: menuCategory[indexPath.row].key)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.categoryTapped(category: menuCategory[indexPath.row].value)
    }
    
}
