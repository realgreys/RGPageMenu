//
//  MenuOptions.swift
//  paging
//
//  Created by realgreys on 2016. 5. 10..
//  Copyright © 2016 realgreys. All rights reserved.
//

import UIKit

public class RGPageMenuOptions {
    
    public var backgroundColor = UIColor.blackColor()
    public var selectedColor = UIColor.blackColor()
    public var textColor = UIColor.darkGrayColor()
    public var selectedTextColor = UIColor.whiteColor()
    public var font = UIFont.systemFontOfSize(16)
    
    public var menuHeight: CGFloat = 45.0
    public var menuItemMargin: CGFloat = 10.0
    public var menuBounces = true
    public var menuPosition: MenuPosition = .Top
    public var menuAlign: MenuAlign = .Center
    public var menuStyle: MenuStyle = .Underline(height: 3,
                                                 color: UIColor.whiteColor(),
                                                 horizontalPadding: 0,
                                                 verticalPadding: 0)
    
    public var defaultPage = 0
    
    public var animationDuration: NSTimeInterval = 0.3
    
    
    public enum MenuPosition {
        case Top
        case Bottom
    }
    
    public enum MenuStyle {
        case None
        case Underline(height: CGFloat, color: UIColor, horizontalPadding: CGFloat, verticalPadding: CGFloat)
    }
    
    // menu 개수가 frame width보다 작을 때 align 기준
    public enum MenuAlign {
        case Left
        case Center
        case Right
    }
    
    public init() {}
}
