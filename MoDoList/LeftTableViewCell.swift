//
//  LeftTableViewCell.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 4..
//

import UIKit

class LeftTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    internal var index:Int! = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
