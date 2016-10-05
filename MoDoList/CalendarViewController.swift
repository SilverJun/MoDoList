//
//  CalendarViewController.swift
//  MoDoList
//
//  Created by Eun Jun Jang on 2016. 9. 13..
//  Copyright © 2016년 SilverJu. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController {

    var numberOfRows = 6
    
    @IBOutlet weak var ymLabel: UILabel!
    
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = NSDateFormatter()
    let testCalendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    
    @IBAction func changeToSixRows(sender: UIButton) {
        numberOfRows = 6
        calendarView.reloadData()
    }
    
    @IBAction func selectToDay(sender: AnyObject?) {
        let date = NSDate()
        calendarView.scrollToDate(date)
        calendarView.selectDates([date])
    }
    
    @IBAction func next(sender: UIButton) {
        self.calendarView.scrollToNextSegment() {
            let currentSegmentDates = self.calendarView.currentCalendarDateSegment()
            self.setupViewsOfCalendar(currentSegmentDates.dateRange.start, endDate: currentSegmentDates.dateRange.end)
        }
    }
    
    @IBAction func prev(sender: UIButton) {
        self.calendarView.scrollToPreviousSegment() {
            let currentSegmentDates = self.calendarView.currentCalendarDateSegment()
            self.setupViewsOfCalendar(currentSegmentDates.dateRange.start, endDate: currentSegmentDates.dateRange.end)
        }
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindAndAddToDo(segue: UIStoryboardSegue) {
        if segue.sourceViewController.isKindOfClass(NewToDoFormViewController) {
            let newTodo = segue.sourceViewController as! NewToDoFormViewController
            
            
            let mainText = newTodo.form.values()["mainText"] as? String;
            let subText = newTodo.form.values()["subText"] as? String;
            
            if mainText != nil && subText != nil {
                let root = slideMenuController()?.leftViewController as! LeftViewController
                let navigation = root.toDoViewController as! UINavigationController
                let todoView = navigation.topViewController as! ToDoViewController
                
                todoView.addToDo(newTodo.form.values())
            }
            else {
                UIAlertView(title: "에러", message: "할일의 제목 또는 내용이 없습니다!", delegate: self, cancelButtonTitle:"확인").show()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy MM dd"
        testCalendar.timeZone = NSTimeZone.localTimeZone()
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.registerCellViewXib(fileName: "CellView")
        
        calendarView.direction = .Horizontal                                 // default is horizontal
        calendarView.cellInset = CGPoint(x: 0, y: 0)                         // default is (3,3)
        calendarView.allowsMultipleSelection = true                         // default is false
        calendarView.firstDayOfWeek = .Sunday                                // default is Sunday
        calendarView.scrollEnabled = true                                    // default is true
        calendarView.scrollingMode = .StopAtEachCalendarFrameWidth           // default is .StopAtEachCalendarFrameWidth
        calendarView.itemSize = nil                                          // default is nil. Use a value here to change the size of your cells
        calendarView.rangeSelectionWillBeUsed = true                        // default is false
        
        calendarView.reloadData()
        
        calendarView.scrollToDate(NSDate(), triggerScrollToDateDelegate: false, animateScroll: false) {
            let currentDate = self.calendarView.currentCalendarDateSegment()
            self.setupViewsOfCalendar(currentDate.dateRange.start, endDate: currentDate.dateRange.end)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
    }
    
    func setupViewsOfCalendar(startDate: NSDate, endDate: NSDate) {
        let month = testCalendar.component(NSCalendarUnit.Month, fromDate: startDate)
        let year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: startDate)
        ymLabel.text = String(year) + "년 " + String((month%13)) + "월"
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "AddToDo") {
            let viewController = segue.destinationViewController as! UINavigationController
            let addView = viewController.topViewController as! NewToDoFormViewController
            
            let count = self.calendarView.selectedDates.count
            
            switch count {
            case 0, 1:
                addView.calendarDate = nil
                break
            default:
                addView.calendarDate = self.calendarView.selectedDates
            }
        }
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        
        let firstDate = formatter.dateFromString("2016 01 01")
        let secondDate = formatter.dateFromString("2020 12 31")
        let aCalendar = NSCalendar.currentCalendar() // Properly configure your calendar to your time zone here
        return (startDate: firstDate!, endDate: secondDate!, numberOfRows: numberOfRows, calendar: aCalendar)
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        (cell as? CellView)?.setupCellBeforeDisplay(cellState, date: date)
    }
    
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        (cell as? CellView)?.cellSelectionChanged(cellState)
    }
    
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        (cell as? CellView)?.cellSelectionChanged(cellState)
        
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToResetCell cell: JTAppleDayCellView) {
        (cell as? CellView)?.selectedView.hidden = true
    }
    
    func calendar(calendar: JTAppleCalendarView, didScrollToDateSegmentStartingWithdate startDate: NSDate, endingWithDate endDate: NSDate) {
        setupViewsOfCalendar(startDate, endDate: endDate)
    }
}

