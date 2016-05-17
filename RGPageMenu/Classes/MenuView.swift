//
//  MenuView.swift
//  paging
//
//  Created by realgreys on 2016. 5. 10..
//  Copyright © 2016 realgreys. All rights reserved.
//

import UIKit

class MenuView: UIScrollView {
    
    var menuItemViews = [MenuItemView]()
    private var options: RGPageMenuOptions!
    
    var currentPage: Int = 0
    
    private let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var underlineView: UIView = {
        let view = UIView(frame: .zero)
        view.userInteractionEnabled = false
        return view
    }()
    
    private var contentOffsetX: CGFloat {
//        return menuItemViews[currentPage].frame.midX - UIApplication.sharedApplication().keyWindow!.bounds.width / 2 // center of screen width
        
        let offset = (contentSize.width - frame.width)
        if offset < 0 {
            switch options.menuAlign {
            case .Left: return 0
            case .Center: return offset / 2
            case .Right: return offset
            }
        }
        
        let menuItemCount = menuItemViews.count
        let ratio = CGFloat(currentPage) / CGFloat(menuItemCount - 1)
        return offset * ratio
    }
    
    // MARK: - Lifecycle
    
    init(menuTitles: [String], options: RGPageMenuOptions) {
        super.init(frame: .zero)
        
        self.options = options
        
        setupScrollView()
        setupContentView()
        layoutContentView()
        setupMenuItems(menuTitles)
        layoutMenuItemView()
        setupUnderlineViewIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupScrollView() {
        backgroundColor = options.backgroundColor
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        bounces = options.menuBounces
        scrollEnabled = true
        scrollsToTop = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupContentView() {
        addSubview(contentView)
    }
    
    private func layoutContentView() {
        let viewsDictionary = ["contentView": contentView, "scrollView": self]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView(==scrollView)]|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: viewsDictionary)
        
        NSLayoutConstraint.activateConstraints(horizontalConstraints + verticalConstraints)
    }
    
    private func setupMenuItems(titles: [String]) {
        titles.forEach {
            let menuItemView = MenuItemView(title: $0, options: options)
            contentView.addSubview(menuItemView)
            
            menuItemViews.append(menuItemView)
        }
//        for i in 0..<titles.count {
//            let menuItemView = MenuItemView(title: titles[i], options: options)
//            contentView.addSubview(menuItemView)
//            
//            menuItemViews.append(menuItemView)
//        }
    }
    
    private func layoutMenuItemView() {
        NSLayoutConstraint.deactivateConstraints(contentView.constraints)
        
        for (index, menuItemView) in menuItemViews.enumerate() {
            let visualFormat: String
            var viewsDictionary = ["menuItemView": menuItemView]
            if index == 0 { // first menu
                visualFormat = "H:|[menuItemView]"
            } else  {
                viewsDictionary["previousMenuItemView"] = menuItemViews[index - 1]
                if index == menuItemViews.count - 1 { // last menu
                    visualFormat = "H:[previousMenuItemView][menuItemView]|"
                } else {
                    visualFormat = "H:[previousMenuItemView][menuItemView]"
                }
            }
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(visualFormat,
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: viewsDictionary)
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[menuItemView]|",
                                                                                     options: [],
                                                                                     metrics: nil,
                                                                                     views: viewsDictionary)
            
            NSLayoutConstraint.activateConstraints(horizontalConstraints + verticalConstraints)
        }
        
        
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func setupUnderlineViewIfNeeded() {
        guard case let .Underline(height, color, horizontalPadding, verticalPadding) = options.menuStyle else {
            return
        }
        
        let width = menuItemViews[currentPage].bounds.width - horizontalPadding * 2
        underlineView.frame = CGRectMake(horizontalPadding, options.menuHeight - (height + verticalPadding), width, height)
        underlineView.backgroundColor = color
        contentView.addSubview(underlineView)
    }
    
    private func animateUnderlineViewIfNeeded() {
        guard case let .Underline(_, _, horizontalPadding, _) = options.menuStyle else {
            return
        }
        
        let targetFrame = menuItemViews[currentPage].frame
        underlineView.frame.origin.x = targetFrame.minX + horizontalPadding
        underlineView.frame.size.width = targetFrame.width - horizontalPadding * 2
    }

    private func selectMenuItem() {
        for (index, menuItemView) in menuItemViews.enumerate() {
            menuItemView.selected = (index == currentPage)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    private func positionMenuItemViews() {
        contentOffset.x = contentOffsetX
        animateUnderlineViewIfNeeded()
    }
    
    // MARK: -
    
    func moveToMenu(page: Int, animated: Bool) {
        let duration = animated ? options.animationDuration : 0
        currentPage = page

        UIView.animateWithDuration(duration, animations: { [unowned self] () -> Void in
            self.selectMenuItem()
            self.positionMenuItemViews()
            })
        
    }
}
