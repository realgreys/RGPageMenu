//
//  TimeTableViewController.swift
//  paging
//
//  Created by realgreys on 2016. 5. 10..
//  Copyright © 2016 realgreys. All rights reserved.
//

import UIKit

class TimeTableViewController: UITableViewController {
    
    var timeTable = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dateFormatter = NSDateFormatter()
//        timeTable = dateFormatter.monthSymbols
        
        for i in 1...24 {
            timeTable.append(i)
        }
    }

    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTable.count
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "\(timeTable[indexPath.row])"
        return cell
    }

}
