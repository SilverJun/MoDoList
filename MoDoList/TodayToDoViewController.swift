//
//  ToDoViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 4..
//

import UIKit
import FBSDKLoginKit


var todoData = Array<TaskDataUnit>()

class ToDoViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var suggestLabel: UILabel!
    
    //오늘!
    var today:NSDate = NSDate.init()
    var privateToDoCount = 0
    
    var modifyCellIndex:NSIndexPath?
    
    var deletingCell:TaskDataUnit? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = NSDateFormatter.init()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMdd")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        let s = dateFormatter.stringFromDate(today)
        
        print(s)
        
        tableView.tableFooterView = UIView.init()
        
        if !Reachability.isConnectedToNetwork() {
            // Create the alert controller
            let alertController = UIAlertController(title: "오류", message: "MoDoList는 인터넷 환경이 필요합니다.\n인터넷을 연결해주세요.", preferredStyle: .Alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                //home button press programmatically
                let app = UIApplication.sharedApplication()
                app.performSelector(#selector(NSURLSessionTask.suspend))
                
                NSThread.sleepForTimeInterval(1.0)
                
                //exit app when app is in background
                exit(0)
            }
            
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let toDoCount:NSMutableArray = [todoData.count, privateToDoCount]
        userDefaults.setObject(toDoCount, forKey: "TodaysToDoCount")
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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


extension ToDoViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70.0
    }
}

extension ToDoViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if todoData.count == 0 {
            suggestLabel.hidden = false
        }
        else {
            suggestLabel.hidden = true
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
        if todoData[indexPath.row].isPrivate {
            privateToDoCount -= 1
        }
        todoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func doneCell(cell cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else { return }
        if todoData[indexPath.row].isPrivate {
            privateToDoCount -= 1
        }
        
        doneToDoData.append(todoData[indexPath.row])
        
        todoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
}

extension ToDoViewController: UIScrollViewDelegate {
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

extension ToDoViewController : SlideMenuControllerDelegate {
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
extension ToDoViewController {
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
        let app = UIApplication.sharedApplication()
        let noti = UILocalNotification()
        
        var data = TaskDataUnit()
        
        data.mainText = values["mainText"] as! String
        data.subText = values["subText"] as! String
        
        data.today = values["todaySwitch"] as? Bool ?? data.today
        
        if !data.today ?? false {
            data.startDate = values["startDate"] as? NSDate ?? data.startDate
            data.endDate = values["endDate"] as? NSDate ?? data.endDate
        }
        else {
            data.startDate = NSDate()
            data.endDate = NSDate()
        }
        
        data.alarmOn = values["alarmOn"] as? Bool ?? data.alarmOn
        
        if data.alarmOn ?? true {
            data.after6 = values["after6"] as? Bool ?? data.after6
            
            if data.after6 {
                noti.fireDate = NSDate(timeIntervalSinceNow: 21600)
                noti.timeZone = NSTimeZone.defaultTimeZone()
                noti.repeatInterval = NSCalendarUnit(rawValue: 0)
                noti.soundName = "ping.aiff"
                noti.alertBody = "\"\(data.mainText)\"할일 등록 후 6시간이 지났습니다!"
                app.scheduleLocalNotification(noti)
            }
            
            data.userTimeAlarm = values["userTimeAlarm"] as? Bool ?? data.userTimeAlarm
            
            if data.userTimeAlarm ?? true {
                data.userTime = values["userTime"] as? NSDate ?? data.userTime
                
                noti.fireDate = data.userTime
                noti.alertBody = "\"\(data.mainText)\"할일을 완료하셨나요? 알람입니다!"
                app.scheduleLocalNotification(noti)
            }
            
            data.notDoneAlarm = values["notDoneAlarm"] as? Bool ?? data.notDoneAlarm
            
            if data.notDoneAlarm {
                noti.fireDate = data.endDate.dateByAddingTimeInterval(86400)
                noti.repeatInterval = NSCalendarUnit.Day
                noti.alertBody = "\"\(data.mainText)\"할일을 아직 완료하지 않으셨네요! 까먹으셨나요?"
                app.scheduleLocalNotification(noti)
            }
        }
        
        data.isPrivate = values["private"] as? Bool ?? data.isPrivate
        
        if data.isPrivate {
            privateToDoCount += 1
        }
        
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
        
        todoData[i].today = values["todaySwitch"] as? Bool ?? todoData[i].today
        
        if !todoData[i].today ?? true {
            todoData[i].startDate = values["startDate"] as? NSDate ?? todoData[i].startDate
            todoData[i].endDate = values["endDate"] as? NSDate ?? todoData[i].endDate
        }
        else {
            todoData[i].startDate = NSDate()
            todoData[i].endDate = NSDate()
        }
        
        todoData[i].alarmOn = values["alarmOn"] as? Bool ?? todoData[i].alarmOn
        
        if todoData[i].alarmOn ?? true {
            todoData[i].after6 = values["after6"] as? Bool ?? todoData[i].after6
            todoData[i].userTimeAlarm = values["userTimeAlarm"] as? Bool ?? todoData[i].userTimeAlarm
            
            if todoData[i].userTimeAlarm ?? true {
                todoData[i].userTime = values["userTime"] as? NSDate ?? todoData[i].userTime
            }
            
            todoData[i].notDoneAlarm = values["notDoneAlarm"] as? Bool ?? todoData[i].notDoneAlarm
        }
        let before = todoData[i].isPrivate
        todoData[i].isPrivate = values["private"] as? Bool ?? todoData[i].isPrivate
        
        
        if before == true && todoData[i].isPrivate == false {
            privateToDoCount -= 1
        }
        else if before == false && todoData[i].isPrivate == true {
            privateToDoCount += 1
        }
        
        self.tableView.reloadData()
    }
    
}


extension ToDoViewController: SwipeCompleteDelegate {
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
