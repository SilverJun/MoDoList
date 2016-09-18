//
//  ToDoCell.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 9..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit


class ToDoCell: UITableViewCell {
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    internal var data: TaskDataUnit?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
