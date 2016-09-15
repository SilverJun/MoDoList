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
    
    @IBAction func changeToThreeRows(sender: UIButton) {
        numberOfRows = 1
        calendarView.reloadData()
    }
    
    @IBAction func changeToSixRows(sender: UIButton) {
        numberOfRows = 6
        calendarView.reloadData()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "yyyy MM dd"
        testCalendar.timeZone = NSTimeZone.localTimeZone()
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        calendarView.registerCellViewXib(fileName: "CellView")
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        
        let firstDate = formatter.dateFromString("2005 01 01")
        let secondDate = formatter.dateFromString("2031 12 31")
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

