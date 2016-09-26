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
    
    var modifyCellIndex:NSIndexPath?
    
//    //셀의 갯수
//    var cellCount:Int = 0
    
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
            
            
            let mainText = newTodo.form.values()["mainText"] as? String;
            let subText = newTodo.form.values()["subText"] as? String;
            
            if mainText != nil && subText != nil {
                self.addToDo(newTodo.form.values())
            }
            else {
                UIAlertView(title: "에러", message: "할일의 제목 또는 내용이 없습니다!", delegate: self, cancelButtonTitle:"확인").show()
                
            }
        }
    }
    
    @IBAction func unwindAndQuickAddToDo(segue: UIStoryboardSegue) {
        if segue.sourceViewController.isKindOfClass(QuickToDoFormViewController) {
            let newTodo = segue.sourceViewController as! QuickToDoFormViewController
            
            let mainText = newTodo.form.values()["mainText"] as? String;
            let subText = newTodo.form.values()["subText"] as? String;
            
            if mainText != nil && subText != nil {
                self.quickAddToDo(newTodo.form.values())
            }
            else {
                UIAlertView(title: "에러", message: "할일의 제목 또는 내용이 없습니다!", delegate: self, cancelButtonTitle:"확인").show()
                
            }
        }
    }
    
    @IBAction func unwindAndModifyToDo(segue: UIStoryboardSegue) {
        if segue.sourceViewController.isKindOfClass(ModifyToDoFormViewController) {
            let newTodo = segue.sourceViewController as! ModifyToDoFormViewController
            
            let values = newTodo.form.values()
            
            let mainText = values["mainText"] as? String;
            let subText = values["subText"] as? String;
            
            if mainText != nil && subText != nil {
                self.modifyToDo(newTodo.form.values())
            }
            else {
                UIAlertView(title: "에러", message: "할일의 제목 또는 내용이 없습니다!", delegate: self, cancelButtonTitle:"확인").show()
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ModifyToDo") {
            
            let viewController = segue.destinationViewController as! UINavigationController

            let modifyView = viewController.topViewController as! ModifyToDoFormViewController
            
            
            modifyCellIndex = tableView.indexPathForSelectedRow!
            modifyView.basedToDoData = todoData[modifyCellIndex!.row]
            
        }
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
        todoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func doneCell(cell cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else { return }
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
        
        data.mainText = values["mainText"] as! String
        data.subText = values["subText"] as! String
        
        data.today = values["todaySwitch"] as? Bool
        
        if data.today ?? false {
            data.startDate = values["startDate"] as? NSDate
            data.endDate = values["endDate"] as? NSDate
        }
        else {
            data.startDate = NSDate()
            data.endDate = NSDate()
        }
        
        data.alarmOn = values["alarmOn"] as? Bool
        
        if data.alarmOn ?? true {
            data.after6 = values["after6"] as? Bool
            data.userTimeAlarm = values["userTimeAlarm"] as? Bool
            
            if data.userTimeAlarm ?? true {
                data.userTime = values["userTime"] as? NSDate
            }
            
            data.notDoneAlarm = values["notDoneAlarm"] as? Bool
        }
        
        data.isPrivate = values["private"] as? Bool
        
        
        
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
    
    func modifyToDo(values: [String:Any?]) {
        
        let i = modifyCellIndex!.row
        
        
        todoData[i].mainText = values["mainText"] as! String
        todoData[i].subText = values["subText"] as! String
        
        todoData[i].today = values["todaySwitch"] as? Bool
        
        if todoData[i].today ?? false {
            todoData[i].startDate = values["startDate"] as? NSDate
            todoData[i].endDate = values["endDate"] as? NSDate
        }
        else {
            todoData[i].startDate = NSDate()
            todoData[i].endDate = NSDate()
        }
        
        todoData[i].alarmOn = values["alarmOn"] as? Bool
        
        if todoData[i].alarmOn ?? true {
            todoData[i].after6 = values["after6"] as? Bool
            todoData[i].userTimeAlarm = values["userTimeAlarm"] as? Bool
            
            if todoData[i].userTimeAlarm ?? true {
                todoData[i].userTime = values["userTime"] as? NSDate
            }
            
            todoData[i].notDoneAlarm = values["notDoneAlarm"] as? Bool
        }
        
        todoData[i].isPrivate = values["private"] as? Bool
        
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
