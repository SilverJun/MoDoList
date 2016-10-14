//
//  SharedViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 20..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit
import Alamofire
import Freddy

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
        tableView.reloadData()
//        self.tableView.beginUpdates()
//        self.tableView.reloadData()
//        self.tableView.endUpdates()
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
        return sharedToDoData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ToDoCell", forIndexPath: indexPath) as! ToDoCell
        
        cell.setupShareCell()
        
        
        cell.mainTitleLabel.text = sharedToDoData[indexPath.row].mainText
        cell.subTitleLabel.text = sharedToDoData[indexPath.row].subText
        cell.setNeedsUpdateConstraints()
        cell.swipeDelegate = self
        
        return cell
    }
    
    func deleteCell(cell cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else { return }
        sharedToDoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func doneCell(cell cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else { return }
        let userDefault = NSUserDefaults.standardUserDefaults()
        let name = userDefault.valueForKey("UserName") as! String
        
        let str = "\(ServerURL)/api/PushDoneAlarm?ownerId=\(sharedToDoData[indexPath.row].owner)&senderName=\(name)&todoData=\(sharedToDoData[indexPath.row].mainText)"
        let url = str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        Alamofire.request(.GET, url).responseData(completionHandler: {
            do {
                let result = try JSONParser.createJSONFromData($0.data!)
                print(result)
            }
            catch {}
        })
        
        sharedToDoData.removeAtIndex(indexPath.row)
        tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
}

extension SharedViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
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
    }
}

