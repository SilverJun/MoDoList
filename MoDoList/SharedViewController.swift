//
//  SharedViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 20..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit

var sharedToDoData = Array<TaskDataUnit>()

class SharedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let fm = ToDoFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        
        
        sharedToDoData += fm.loadToDoFile(.shared)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setNavigationBarItem()
    }
    
    override func viewDidDisappear(animated: Bool) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let fileManager = ToDoFileManager()
            fileManager.saveToDoFile()
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SharedViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
}

extension SharedViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ToDoCell", forIndexPath: indexPath) as! ToDoCell
        
        cell.setupSwipe()
        
        
        cell.mainTitleLabel.text = todoData[indexPath.row].mainText
        cell.subTitleLabel.text = todoData[indexPath.row].subText
        cell.setNeedsUpdateConstraints()
        cell.swipeDelegate = self
        
        return cell
    }
    
    func deleteCell(cell cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else { return }
        todoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func doneCell(cell cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else { return }
        todoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
}

extension SharedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y;
        //let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (currentOffset * (-1) >= 60.0 && currentOffset < 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var quickView = storyboard.instantiateViewControllerWithIdentifier("QuickToDoFormViewController")
            quickView = UINavigationController(rootViewController: quickView)
            
            self.performSegueWithIdentifier("QuickAddToDo", sender: self)
        }
    }
}

extension SharedViewController: SwipeCompleteDelegate {
    func swipeComplete(cell cell: UITableViewCell, position: SwipeCell.Position) {
        //삭제
        if position == .Left1 {
            deleteCell(cell: cell)
        }
        //완료
        if position == .Right1 {
            doneCell(cell: cell)
        }
        //전달
        if position == .Right2 {
            // send
        }
    }
}

