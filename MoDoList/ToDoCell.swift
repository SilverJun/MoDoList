//
//  ToDoCell.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 9..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit

protocol SwipeCompleteDelegate: class {
    func swipeComplete(cell cell: UITableViewCell, position: SwipeCell.Position)
}

class ToDoCell: UITableViewCell {
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    private var swipe: SwipeCell!
    weak var swipeDelegate: SwipeCompleteDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupDefaults()
        //setupSwipe()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupDefaults()
        //setupSwipe()
    }
    
    private func setupDefaults() {
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
        selectionStyle = .None
    }
    
    func setupSwipe() {
        swipe = SwipeCell(cell: self)
        
        // optional swipe delegate (see functions below)
        swipe.delegate = self
        
        // set the starting positions for the swipe buttons (up to 4 on each side)
        swipe.firstTrigger = 0.20
        swipe.secondTrigger = 0.60
        
        // create the swipe buttons
        // TODO: make [unowned self] default implimentation to prevent closure strong reference cycle
        swipe.create(position: SwipeCell.Position.Left1, animation: .Slide, icon: UIImageView(image:UIImage(named: "delete [#1487]")), color: UIColor(red:255.0/255.0, green:86.0/255.0, blue:94.0/255.0, alpha:1.0)) { [unowned self] (cell) in
            // send the completed choice from the cell to the view controller
            self.swipeDelegate?.swipeComplete(cell: cell, position: .Left1)
        }
        
        swipe.create(position: SwipeCell.Position.Right1, animation: .Slide, icon: UIImageView(image:UIImage(named: "done [#1476]")), color: UIColor(red: 48.0/255.0, green: 225.0/255.0, blue: 178.0/255.0, alpha: 1.0)) { [unowned self] (cell) in
            self.swipeDelegate?.swipeComplete(cell: cell, position: .Right1)
        }
        
        swipe.create(position: SwipeCell.Position.Right2, animation: .Bounce, icon: UIImageView(image:UIImage(named: "send_round [#1569]")), color: .grayColor()) { [unowned self] (cell) in
            self.swipeDelegate?.swipeComplete(cell: cell, position: .Right2)
        }
        
    }
    
    func setupShareCell() {
        swipe = SwipeCell(cell: self)
        
        // optional swipe delegate (see functions below)
        swipe.delegate = self
        
        // set the starting positions for the swipe buttons (up to 4 on each side)
        swipe.firstTrigger = 0.20
        swipe.secondTrigger = 0.60
        
        // create the swipe buttons
        // TODO: make [unowned self] default implimentation to prevent closure strong reference cycle
        swipe.create(position: SwipeCell.Position.Left1, animation: .Slide, icon: UIImageView(image:UIImage(named: "delete [#1487]")), color: UIColor(red:255.0/255.0, green:86.0/255.0, blue:94.0/255.0, alpha:1.0)) { [unowned self] (cell) in
            // send the completed choice from the cell to the view controller
            self.swipeDelegate?.swipeComplete(cell: cell, position: .Left1)
        }
        swipe.create(position: SwipeCell.Position.Right1, animation: .Slide, icon: UIImageView(image:UIImage(named: "done [#1476]")), color: UIColor(red: 48.0/255.0, green: 225.0/255.0, blue: 178.0/255.0, alpha: 1.0)) { [unowned self] (cell) in
            // send the completed choice from the cell to the view controller
            self.swipeDelegate?.swipeComplete(cell: cell, position: .Right1)
        }
        
    }
    
    func setupDoneCell() {
        swipe = SwipeCell(cell: self)
        
        // optional swipe delegate (see functions below)
        swipe.delegate = self
        
        // set the starting positions for the swipe buttons (up to 4 on each side)
        swipe.firstTrigger = 0.20
        swipe.secondTrigger = 0.60
        
        // create the swipe buttons
        // TODO: make [unowned self] default implimentation to prevent closure strong reference cycle
        swipe.create(position: SwipeCell.Position.Left1, animation: .Slide, icon: UIImageView(image:UIImage(named: "delete [#1487]")), color: UIColor(red:255.0/255.0, green:86.0/255.0, blue:94.0/255.0, alpha:1.0)) { [unowned self] (cell) in
            // send the completed choice from the cell to the view controller
            self.swipeDelegate?.swipeComplete(cell: cell, position: .Left1)
        }
        swipe.create(position: SwipeCell.Position.Right1, animation: .Slide, icon: UIImageView(image:UIImage(named: "arrow_repeat [#235]")), color: UIColor(red: 48.0/255.0, green: 225.0/255.0, blue: 178.0/255.0, alpha: 1.0)) { [unowned self] (cell) in
            // send the completed choice from the cell to the view controller
            self.swipeDelegate?.swipeComplete(cell: cell, position: .Right1)
        }
    }
}

extension ToDoCell: SwipeCellDelegate {
    func tableViewCellDidStartSwiping(cell cell: UITableViewCell) {
        //    print("started swiping")
    }
    
    func tableViewCellDidEndSwiping(cell cell: UITableViewCell) {
        //    print("ended swiping")
    }
    
    func tableViewCell(cell cell: UITableViewCell, didSwipeWithPercentage percentage: CGFloat) {
        //    print("swiping percent: \(percentage)")
    }
    
}

