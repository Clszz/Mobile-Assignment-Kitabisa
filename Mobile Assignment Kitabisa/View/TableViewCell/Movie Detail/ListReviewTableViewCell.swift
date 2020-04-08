//
//  ListReviewTableViewCell.swift
//  Mobile Assignment Kitabisa
//
//  Created by Muhammad Reynaldi on 08/04/20.
//  Copyright © 2020 -. All rights reserved.
//

import UIKit

class ListReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIView!
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
extension ListReviewTableViewCell{
    func setCell(initialText:String, authorText:String, urlText:String, contentText:String) {
        initialLabel.text = String(initialText.first!.uppercased())
        authorLabel.text = authorText
        urlLabel.text = urlText
        contentLabel.text = contentText
        
        setInterface()
    }
    
    private func setInterface() {
        avatar.setRounded()
    }
    
}
