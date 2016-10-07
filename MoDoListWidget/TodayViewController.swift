//
//  TodayViewController.swift
//  MoDoListWidget
//
//  Created by Eun Jun Jang on 2016. 10. 5..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var suggestLabel: UILabel!
    var todoData = Array<TaskDataUnit>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        let fm = ToDoFileManager()
        
        todoData = fm.loadToDoFile()
        
        tableView.tableFooterView = UIView()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizesSubviews = true
        
        if todoData.count == 0 {
            self.preferredContentSize.height = suggestLabel.bounds.height
        }
        else {
            self.preferredContentSize = tableView.contentSize
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fm = ToDoFileManager()
        todoData = fm.loadToDoFile()
        
        widgetPerformUpdateWithCompletionHandler({(NCUpdateResult) -> Void in
        })
        
        if todoData.count == 0 {
            self.preferredContentSize.height = suggestLabel.bounds.height
        }
        else {
            self.preferredContentSize = tableView.contentSize
        }
        
        if todoData.count != 0 {
            suggestLabel.hidden = true
        }
        else {
            suggestLabel.hidden = false
        }
        suggestLabel.setNeedsUpdateConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        let fm = ToDoFileManager()
        todoData = fm.loadToDoFile()
        
        if todoData.count == 0 {
            self.preferredContentSize.height = suggestLabel.bounds.height
        }
        else {
            self.preferredContentSize = tableView.contentSize
        }
        
        if todoData.count != 0 {
            suggestLabel.hidden = true
        }
        else {
            suggestLabel.hidden = false
        }
        
        suggestLabel.setNeedsUpdateConstraints()
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
}

extension TodayViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
}

extension TodayViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ToDoCell", forIndexPath: indexPath) as! WidgetTableViewCell
        
        cell.mainText.text = todoData[indexPath.row].mainText
        cell.subText.text = todoData[indexPath.row].subText
        cell.setNeedsUpdateConstraints()
        
        return cell
    }
}
