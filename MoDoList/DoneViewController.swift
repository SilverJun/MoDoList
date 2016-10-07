//
//  DoneViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 10. 3..
//  Copyright © 2016년 SilverJun. All rights reserved.
//

import UIKit

var doneToDoData = Array<TaskDataUnit>()

class DoneViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let fm = ToDoFileManager()
    let notiManager = PushNotificationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView()
        
        doneToDoData += fm.loadToDoFile(.done)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


extension DoneViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
}

extension DoneViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneToDoData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ToDoCell", forIndexPath: indexPath) as! ToDoCell
        
        cell.setupDoneCell()
        
        
        cell.mainTitleLabel.text = doneToDoData[indexPath.row].mainText
        cell.subTitleLabel.text = doneToDoData[indexPath.row].subText
        cell.setNeedsUpdateConstraints()
        cell.swipeDelegate = self
        
        return cell
    }
    
    func deleteCell(cell cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else { return }
        doneToDoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    func restoreCell(cell cell: UITableViewCell){
        guard let indexPath = tableView?.indexPathForCell(cell) else { return }
        todoData.append(doneToDoData[indexPath.row])
        notiManager.addLocalNotification(todoData[indexPath.row])
        doneToDoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
}

extension DoneViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension DoneViewController: SwipeCompleteDelegate {
    func swipeComplete(cell cell: UITableViewCell, position: SwipeCell.Position) {
        //삭제
        if position == .Left1 {
            deleteCell(cell: cell)
        }
        if position == .Right1 {
            restoreCell(cell: cell)
        }
    }
}
