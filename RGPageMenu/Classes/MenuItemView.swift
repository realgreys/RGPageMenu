//
//  MenuItemView.swift
//  paging
//
//  Created by realgreys on 2016. 5. 10..
//  Copyright © 2016 realgreys. All rights reserved.
//

import UIKit

class MenuItemView: UIView {
    
    private var options: RGPageMenuOptions!

    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .Center
        label.userInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var labelSize: CGSize {
        guard let text = titleLabel.text else { return .zero }
        return NSString(string: text).boundingRectWithSize(CGSizeMake(CGFloat.max, CGFloat.max),
                                                           options: .UsesLineFragmentOrigin,
                                                           attributes: [NSFontAttributeName: titleLabel.font],
                                                           context: nil).size
    }
    private var widthConstraint: NSLayoutConstraint!
    
    var selected: Bool = false {
        didSet {
            backgroundColor = selected ? options.selectedColor : options.backgroundColor
            titleLabel.textColor = selected ? options.selectedTextColor : options.textColor
            
            // font가 변경되면 size 계산 다시 해야 한다.
        }
    }
    
    // MARK: - Lifecycle
    
    init(title: String, options: RGPageMenuOptions) {
        super.init(frame: .zero)
        
        self.options = options
        
        backgroundColor = options.backgroundColor
        translatesAutoresizingMaskIntoConstraints = false
        
        setupLabel(title)
        layoutLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    
    private func setupLabel(title: String) {
        titleLabel.text = title
        titleLabel.textColor = options.textColor
        titleLabel.font = options.font
        addSubview(titleLabel)
    }
    
    private func layoutLabel() {
        let viewsDictionary = ["label": titleLabel]
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: viewsDictionary)
        
        NSLayoutConstraint.activateConstraints(horizontalConstraints + verticalConstraints)
        
        let labelSize = calcLabelSize()
        widthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: labelSize.width)
        widthConstraint.active = true
    }
    
    private func calcLabelSize() -> CGSize {
        
        let height = floor(labelSize.height) // why floor?
        
        if options.menuAlign == .Fit {
            let windowSize = UIApplication.sharedApplication().keyWindow!.bounds.size
            let width = windowSize.width / CGFloat(options.menuItemCount)
            return CGSizeMake(width, height)
        } else {
            let width = ceil(labelSize.width)
            
            return CGSizeMake(width + options.menuItemMargin * 2, height)
        }
    }
    
}
