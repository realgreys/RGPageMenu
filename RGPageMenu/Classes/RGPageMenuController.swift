//
//  PageMenuController.swift
//  paging
//
//  Created by realgreys on 2016. 5. 10..
//  Copyright © 2016 realgreys. All rights reserved.
//

import UIKit

@objc
public protocol RGPageMenuControllerDelegate: class {
    optional func willMoveToPageMenuController(viewController: UIViewController, nextViewController: UIViewController)
    optional func didMoveToPageMenuController(viewController: UIViewController)
}


public class RGPageMenuController: UIViewController {
    
    weak public var delegate: RGPageMenuControllerDelegate?

    private var menuView: MenuView!
    private var options: RGPageMenuOptions!
    private var menuTitles: [String] {
        return viewControllers.map {
            return $0.title ?? "Menu"
        }
    }
    
    private var pageViewController: UIPageViewController!
    
    private(set) var currentPage = 0
    private var viewControllers: [UIViewController]!
    
    
    
    // MARK: - Lifecycle
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(viewControllers: [UIViewController], options: RGPageMenuOptions) {
        super.init(nibName: nil, bundle: nil)
        
        configure(viewControllers, options: options)
    }
    
    public convenience init(viewControllers: [UIViewController]) {
        self.init(viewControllers: viewControllers, options: RGPageMenuOptions())
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        menuView.moveToMenu(currentPage, animated: false)
    }
    
    
    // MARK: - Layout
    
    private func setupMenuView() {
        menuView = MenuView(menuTitles: menuTitles, options: options)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuView)
        
        addTapGestureHandlers()
    }
    
    private func layoutMenuView() {
        // cleanup
//        NSLayoutConstraint.deactivateConstraints(menuView.constraints)
        
        let viewsDictionary = ["menuView": menuView]
        let metrics = ["height": options.menuHeight]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[menuView]|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: viewsDictionary)
        let verticalConstraints: [NSLayoutConstraint]
        switch options.menuPosition {
        case .Top:
            verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[menuView(height)]",
                                                                                 options: [],
                                                                                 metrics: metrics,
                                                                                 views: viewsDictionary)
        case .Bottom:
            verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[menuView(height)]|",
                                                                                 options: [],
                                                                                 metrics: metrics,
                                                                                 views: viewsDictionary)
        }
        
        NSLayoutConstraint.activateConstraints(horizontalConstraints + verticalConstraints)
        
        menuView.setNeedsLayout()
        menuView.layoutIfNeeded()
    }
    
    private func setupPageView() {
        pageViewController = UIPageViewController(transitionStyle: .Scroll,
                                                  navigationOrientation: .Horizontal,
                                                  options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        let childViewControllers = [ viewControllers[currentPage] ]
        pageViewController.setViewControllers(childViewControllers,
                                              direction: .Forward,
                                              animated: false,
                                              completion: nil)
        
        addChildViewController(pageViewController)
        pageViewController.view.frame = .zero
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        
        pageViewController.didMoveToParentViewController(self)
    }
    
    private func layoutPageView() {
        let viewsDictionary = ["pageView": pageViewController.view, "menuView": menuView]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[pageView]|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: viewsDictionary)
        let verticalConstraints: [NSLayoutConstraint]
        switch options.menuPosition {
        case .Top:
            verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[menuView][pageView]|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: viewsDictionary)
        case .Bottom:
            verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[pageView][menuView]",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: viewsDictionary)
        }
        
        NSLayoutConstraint.activateConstraints(horizontalConstraints + verticalConstraints)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    private func validateDefaultPage() {
        guard options.defaultPage >= 0 && options.defaultPage < options.menuItemCount else {
            NSException(name: "PageMenuException", reason: "default page is not valid!", userInfo: nil).raise()
            return
        }
    }
    
    private func indexOfViewController(viewController: UIViewController) -> Int {
        return viewControllers.indexOf(viewController) ?? NSNotFound
    }
    
    // MARK: - Gesture handler
    
    private func addTapGestureHandlers() {
        menuView.menuItemViews.forEach {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
            gestureRecognizer.numberOfTapsRequired = 1
            $0.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    func handleTapGesture(recognizer: UITapGestureRecognizer) {
        guard let menuItemView = recognizer.view as? MenuItemView else { return }
        guard let page = menuView.menuItemViews.indexOf(menuItemView) where page != menuView.currentPage else { return }

        moveToPage(page)
    }
    
    
    // MARK: - public
    
    public func configure(viewControllers: [UIViewController], options: RGPageMenuOptions) {
        let menuItemCount = viewControllers.count
        guard menuItemCount > 0 else {
            NSException(name: "PageMenuException", reason: "child view controller is empty!", userInfo: nil).raise()
            return
        }
        
        self.viewControllers = viewControllers
        self.options = options
        self.options.menuItemCount = menuItemCount
        
        validateDefaultPage()
        currentPage = options.defaultPage
        
        setupMenuView()
        layoutMenuView()
        setupPageView()
        layoutPageView()
    }
    
    public func moveToPage(page: Int, animated: Bool = true) {
        guard page < options.menuItemCount && page != currentPage else { return }
        
        let direction: UIPageViewControllerNavigationDirection = page < currentPage ? .Reverse : .Forward
        
        // page 이동
        currentPage = page % viewControllers.count // for infinite loop
        
        // menu 이동
        menuView.moveToMenu(currentPage, animated: animated)
        
        let childViewControllers = [ viewControllers[currentPage] ]
        pageViewController.setViewControllers(childViewControllers,
                                              direction: direction,
                                              animated: animated,
                                              completion: nil)
    }
    
}

extension RGPageMenuController: UIPageViewControllerDelegate {
    
    // MARK: - UIPageViewControllerDelegate
    
    public func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        if let nextViewController = pendingViewControllers.first {
            let index = indexOfViewController(nextViewController)
            guard index != NSNotFound else { return }
            
            currentPage = index
            menuView.moveToMenu(currentPage, animated: true)
            
            if let viewController = pageViewController.viewControllers?.first {
                // delegate가 있으면 notify
                delegate?.willMoveToPageMenuController?(viewController, nextViewController: nextViewController)
            }
        }
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            if let previousViewController = previousViewControllers.first {
                let index = indexOfViewController(previousViewController)
                guard index != NSNotFound else { return }
                
                currentPage = index
                menuView.moveToMenu(currentPage, animated: true)
            }
        } else {
            if let nextViewController = pageViewController.viewControllers?.first {
                // delegate가 있으면 notify
                delegate?.didMoveToPageMenuController?(nextViewController)
            }
        }
    }
}

extension RGPageMenuController: UIPageViewControllerDataSource {
    
    // MARK: - UIPageViewControllerDataSource
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = indexOfViewController(viewController)
        guard index != 0 && index != NSNotFound else {
            return nil
        }
        
        return viewControllers[index - 1]
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = indexOfViewController(viewController)
        guard index < viewControllers.count - 1 && index != NSNotFound else {
            return nil
        }

        return viewControllers[index + 1]
    }
}




