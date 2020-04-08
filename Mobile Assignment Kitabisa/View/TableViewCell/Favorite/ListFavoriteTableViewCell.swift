//
//  ListFavoriteTableViewCell.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 09/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import UIKit

class ListFavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var moviteTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
extension ListFavoriteTableViewCell{
    func setCell(poster_path:String,titleText:String, date:String, description:String) {
        let completeLink = ConstantValue.defaultLink + poster_path
        
        posterImage.downloaded(from: completeLink, contentMode: .scaleAspectFill)
        moviteTitleLabel.text = titleText
        releaseDateLabel.text = date
        overviewLabel.text = description
    }
}
