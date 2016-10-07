//
//  WidgetTableViewCell.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 10. 6..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit

class WidgetTableViewCell: UITableViewCell {

    @IBOutlet weak var mainText: UILabel!
    @IBOutlet weak var subText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
