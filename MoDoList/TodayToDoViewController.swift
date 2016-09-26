//
//  ToDoViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 4..
//

import UIKit
import FBSDKLoginKit


class TodayToDoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var suggestLabel: UILabel!
    
    var todoData = Array<TaskDataUnit>()
    
    
    //오늘!
    var today:NSDate = NSDate.init()
    
//    //셀의 갯수
//    var cellCount:Int = 0
    
    //새로운 투두의 데이터
    var newToDoData: TaskDataUnit? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMdd")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let s = dateFormatter.stringFromDate(today)
        
        print(s)
        
        tableView.tableFooterView = UIView.init()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.slideMenuController()?.delegate = self
        self.setNavigationBarItem()
        self.slideMenuController()?.removeLeftGestures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindAndAddToDo(segue: UIStoryboardSegue) {
        if segue.sourceViewController.isKindOfClass(NewToDoFormViewController) {
            let newTodo = segue.sourceViewController as! NewToDoFormViewController
            
            self.addToDo(newTodo.form.values())
        }
    }
    
    @IBAction func unwindAndQuickAddToDo(segue: UIStoryboardSegue) {
        if segue.sourceViewController.isKindOfClass(QuickToDoFormViewController) {
            let newTodo = segue.sourceViewController as! QuickToDoFormViewController
            
            self.quickAddToDo(newTodo.form.values())
        }
    }
    
    @IBAction func unwindAndModifyToDo(segue: UIStoryboardSegue) {
    }
    
}


extension TodayToDoViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
}

extension TodayToDoViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if todoData.count > 0 {
            suggestLabel.hidden = true
        }
        else {
            suggestLabel.hidden = false
        }
        
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
//        items.removeAtIndex(indexPath.row)
        todoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func doneCell(cell cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else { return }
        //        items.removeAtIndex(indexPath.row)
        todoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
}

extension TodayToDoViewController: UIScrollViewDelegate {
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

extension TodayToDoViewController : SlideMenuControllerDelegate {
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
        self.slideMenuController()?.addLeftGestures()
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
        self.slideMenuController()?.removeLeftGestures()
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}

//process add, modify
extension TodayToDoViewController {
    /*
     mainText
     subText
     todaySwitch
     startDate
     endDate
     alarmOn
     userTimeAlarm
     userTime
     notDoneAlarm
     private
     */
    
    func addToDo(values: [String:Any?]) {
        var data = TaskDataUnit()
        
        data.mainText = values["mainText"] as! String;
        data.subText = values["subText"] as! String;
        
        if values["todaySwitch"] as? Bool ?? false {
            data.startDate = values["startDate"] as? NSDate;
            data.endDate = values["endDate"] as? NSDate;
        }
        else {
            data.startDate = NSDate()
            data.endDate = NSDate()
        }
        
        
        //newToDoData = data
        
        let row = NSIndexPath(forRow: todoData.count, inSection: 0)
        
        self.tableView.beginUpdates()
        todoData.append(data)
        self.tableView.reloadData()
        self.tableView.insertRowsAtIndexPaths([row], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
        
        self.tableView.reloadData()
    }
    
    func quickAddToDo(values: [String:Any?]) {
        var data = TaskDataUnit()
        
        data.mainText = values["mainText"] as! String;
        data.subText = values["subText"] as! String;
        
        let row = NSIndexPath(forRow: todoData.count, inSection: 0)
        
        self.tableView.beginUpdates()
        todoData.append(data)
        self.tableView.reloadData()
        self.tableView.insertRowsAtIndexPaths([row], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
        
        self.tableView.reloadData()
    }
    
}


extension TodayToDoViewController: SwipeCompleteDelegate {
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
