//
//  Extensions.swift
//  CodeDrawing
//
//  Created by Paweł Ambrożej on 13/11/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit


class StandardUIButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FilledUIButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 20
        self.backgroundColor = BACKGROUND_COLOR
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isAccessibilityElement: Bool {
        get { return true }
        set {}
    }
    
    override var accessibilityLabel: String? {
        get {
            return self.titleLabel?.text ?? ""
        }
        set {}
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return UIAccessibilityTraitButton
        }
        set {}
    }
}

class StandardUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        self.textColor = MAIN_COLOR
        self.adjustsFontForContentSizeCategory = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TitleUILabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        self.textColor = .white
        self.textAlignment = .center
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isAccessibilityElement: Bool {
        get{ return true }
        set{}
    }
    
    override var accessibilityTraits: UIAccessibilityTraits{
        get{
            return UIAccessibilityTraitHeader
        }
        set{}
    }
}

class NewTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.textColor = MAIN_COLOR
        self.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        self.leftView = paddingView
        self.leftViewMode = .always
        self.backgroundColor = THIRD_COLOR
        self.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        self.placeholder = ""
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isAccessibilityElement: Bool{
        get{
            return true
        }
        set{}
    }
    
    override var accessibilityLabel: String? {
        get{
            return self.placeholder
        }
        set{}
    }
    

    
}

class StandardSearchBar: UISearchBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = MAIN_COLOR.cgColor
        self.tintColor = .white
        self.backgroundColor = MAIN_COLOR
        self.placeholder = "Name"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StandardUISegmentedControl: UISegmentedControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = MAIN_COLOR.cgColor
        self.tintColor = MAIN_COLOR
        self.backgroundColor = .clear
        self.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.white], for: .normal)
    }

    override init(items: [Any]?) {
        super.init(items: items)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIView {
    
    func constraintAnchors(top:NSLayoutYAxisAnchor?, left:NSLayoutXAxisAnchor?, right:NSLayoutXAxisAnchor?, bottom:NSLayoutYAxisAnchor?, topDistance: CGFloat, leftDistance: CGFloat, rightDistance: CGFloat, bottomDistance: CGFloat, height: CGFloat?, width: CGFloat?) -> [NSLayoutConstraint] {
        
        let constraints = constraintsWithDistanceTo(top: top, left: left, right: right, bottom: bottom, topDistance: topDistance, leftDistance: leftDistance, rightDistance: rightDistance, bottomDistance: bottomDistance)
        
        setPropertyOf(width: width, height: height)
//        var propertyDictionary:Dictionary<String,NSLayoutConstraint> = [:]
        
        return constraints
        
    }
    
    func constraintsTo(top:NSLayoutYAxisAnchor?, left:NSLayoutXAxisAnchor?, right:NSLayoutXAxisAnchor?, bottom:NSLayoutYAxisAnchor?) {
        
        _ = self.constraintsWithDistanceTo(top: top, left: left, right: right, bottom: bottom, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        
    }
    
    func constraintsWithDistanceTo(top:NSLayoutYAxisAnchor?,  left:NSLayoutXAxisAnchor?, right:NSLayoutXAxisAnchor?, bottom:NSLayoutYAxisAnchor?, topDistance: CGFloat, leftDistance: CGFloat, rightDistance: CGFloat, bottomDistance: CGFloat)->[NSLayoutConstraint]{
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        if let top = top {
            let constraint = self.topAnchor.constraint(equalTo: top, constant: topDistance)
            constraint.isActive = true
            constraint.identifier = "topAnchorConstraint"
            constraints.append(constraint)
        }
        
        if let left = left {
            let constraint = self.leftAnchor.constraint(equalTo: left, constant: leftDistance)
            constraint.isActive = true
            constraint.identifier = "leftAnchorConstraint"
            constraints.append(constraint)
        }
        
        if let right = right {
            let constraint = self.rightAnchor.constraint(equalTo: right, constant: -rightDistance)
            constraint.isActive = true
            constraint.identifier = "rightAnchorConstraint"
            constraints.append(constraint)
        }
        
        if let bottom = bottom {
            let constraint = self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomDistance)
            constraint.isActive = true
            constraint.identifier = "bottomAnchorConstraint"
            constraints.append(constraint)
        }
        return constraints
    }
    
    func centerInTheView(centerX:NSLayoutXAxisAnchor?, centerY:NSLayoutYAxisAnchor?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
    }
    
    func setPropertyOf(width:CGFloat?, height:CGFloat?) {
        
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func constraintWith(visualFormat:String,views:UIView...) {
        
        var viewsDict:Dictionary<String,UIView> = [:]
        
        for index in views.indices {
            
            views[index].translatesAutoresizingMaskIntoConstraints = false
            let viewName = "v\(index)"
            viewsDict[viewName] = views[index]
        }
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDict))
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [GRADIENT_COLOR_1,UIColor.black.cgColor]
        gradient.frame = self.bounds
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint.init(x: 1, y: 1)
        self.layer.addSublayer(gradient)
    }
    

}

extension UIViewController {
    
    func presentFromRight(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 2
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        self.view.window?.layer.backgroundColor = UIColor.white.cgColor
        self.view.window?.backgroundColor = .white
        self.view.window!.layer.add(transition, forKey: kCATransition)
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        viewControllerToPresent.modalTransitionStyle = .coverVertical
        
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissFromLeft() {
        let transition = CATransition()
//        transition.duration = 0.25
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}
