//
//  ViewController.swift
//  paging
//
//  Created by realgreys on 2016. 5. 10..
//  Copyright © 2016년 realgreys. All rights reserved.
//

import UIKit
import RGPageMenu

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let timeTableViewController = storyboard?.instantiateViewControllerWithIdentifier("TimeTableViewController")
        timeTableViewController?.title = "time"
        
        let vc0 = UIViewController()
        vc0.title = "lightGray"
        vc0.view.backgroundColor = UIColor.lightGrayColor()
        let vc1 = UIViewController()
        vc1.title = "darkGray"
        vc1.view.backgroundColor = UIColor.darkGrayColor()
        let vc2 = UIViewController()
        vc2.title = "blue"
        vc2.view.backgroundColor = UIColor.blueColor()
        let vc3 = UIViewController()
        vc3.title = "red"
        vc3.view.backgroundColor = UIColor.redColor()
        let vc4 = UIViewController()
        vc4.title = "green"
        vc4.view.backgroundColor = UIColor.greenColor()
        let vc5 = UIViewController()
        vc5.title = "brown"
        vc5.view.backgroundColor = UIColor.brownColor()
        
        let viewControllers = [timeTableViewController!, vc0, vc1, vc2, vc3, vc4, vc5]
        let options = RGPageMenuOptions()
//        options.menuPosition = .Bottom
        
        if let pageMenuController = childViewControllers.first as? RGPageMenuController {
            pageMenuController.configure(viewControllers, options: options)
            pageMenuController.delegate = self
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RootViewController: RGPageMenuControllerDelegate {
    
    func willMoveToPageMenuController(viewController: UIViewController, nextViewController: UIViewController) {
        // do something
    }
    
    func didMoveToPageMenuController(viewController: UIViewController) {
        // do something
    }
}

