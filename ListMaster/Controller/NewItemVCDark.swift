//
//  NewItemVC.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 19/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class NewItemVCDark: UIViewController {

    var listName = ""
    var addButtonConstraints: [NSLayoutConstraint]? = nil
    
    let ad = UIApplication.shared.delegate as! AppDelegate
    lazy var context = ad.persistentContainer.viewContext
    
    let titleBackground:UIView = {
        let tb = UIView()
        tb.backgroundColor = MAIN_COLOR
        return tb
    }()

    let titleLabel: TitleUILabel = {
        let textTitle = TitleUILabel()
        textTitle.text = "Create New List"
        textTitle.textColor = .white
        textTitle.font = UIFont(name: "HelveticaNeue-medium", size: 24)
        return textTitle
    }()
    
    let itemNameTextField: NewTextField =  {
        let textField = NewTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedStringKey.foregroundColor:MAIN_COLOR.withAlphaComponent(0.7)])
        textField.placeholder = "Name"
        return textField
    }()
    
    let amountLabel: StandardUILabel = {
        let label = StandardUILabel()
        label.text = "Amount:"
        label.textAlignment = .right
        return label
    }()
    
    let amountTextField: NewTextField = {
        let textField = NewTextField()
        textField.text = "1"
        textField.keyboardType = UIKeyboardType.numberPad
        textField.textAlignment = .right
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textField.rightView = paddingView
        textField.rightViewMode = .always
        return textField
    }()
    
    let topSegmentedControl: StandardUISegmentedControl = {
        let segment = StandardUISegmentedControl(items: ["pcs","kg","g","lb"])
        segment.tag = 0
        segment.addTarget(self, action: #selector(segmentPressed), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    lazy var bottomSegmentedControl: StandardUISegmentedControl = {
        let segment = StandardUISegmentedControl(items: ["l","ml"])
//        segment.insertSegment(withTitle: "l", at: 0, animated: true)
//        segment.insertSegment(withTitle: "ml", at: 1, animated: true)
        segment.tag = 1
        segment.addTarget(self, action: #selector(segmentPressed), for: .valueChanged)
        return segment
    }()
    
    @objc func segmentPressed(sender:UISegmentedControl) {
        if sender.tag == 0 {
            self.bottomSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        } else {
            self.topSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
        }
        
    }
    
    let addButton: FilledUIButton = {
        let button = FilledUIButton()
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let backButton: FilledUIButton = {
        let button = FilledUIButton()
        button.setTitle("Back to List", for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonPressed(sender: UIButton) {
        
        var measureUnit = "pcs"
        
        if topSegmentedControl.selectedSegmentIndex == UISegmentedControlNoSegment {
            let key = bottomSegmentedControl.selectedSegmentIndex
            measureUnit = bottomSegmentedControl.titleForSegment(at: key)!
        } else {
            let key = topSegmentedControl.selectedSegmentIndex
            measureUnit = topSegmentedControl.titleForSegment(at: key)!
        }
        
        let item = Product(context: context)
        item.name = itemNameTextField.text
        item.amount = amountTextField.text
        item.isInBasket = false
        let list = getListObject(name: listName)
        item.toList = list
        item.measureUnit = measureUnit
        ad.saveContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        self.hideKeyboardWhenTappedAround()
        print(listName)
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    @objc func keyboardWillAppear() {

    }
    
    @objc func keyboardWillDisappear() {
        //Do something here
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupLayout() {
        
        
        view.addSubview(titleBackground)
        view.addSubview(titleLabel)
        view.addSubview(itemNameTextField)
        view.addSubview(amountLabel)
        view.addSubview(amountTextField)
        view.addSubview(topSegmentedControl)
        view.addSubview(bottomSegmentedControl)
        view.addSubview(addButton)
        view.addSubview(backButton)
        
        
        
        _ = titleBackground.constraintAnchors(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 60, width: nil)
        _ = titleLabel.constraintsWithDistanceTo(top: titleBackground.topAnchor, left: titleBackground.leftAnchor, right: titleBackground.rightAnchor, bottom: titleBackground.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        _ = itemNameTextField.constraintAnchors(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 15, leftDistance: 35, rightDistance: 35, bottomDistance: 0, height: 40, width: nil)
        _ = amountLabel.constraintsWithDistanceTo(top: amountTextField.topAnchor, left: itemNameTextField.leftAnchor, right: amountTextField.leftAnchor, bottom: amountTextField.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 10, bottomDistance: 0)
        _ = amountTextField.constraintAnchors(top: itemNameTextField.bottomAnchor, left: view.centerXAnchor, right: itemNameTextField.rightAnchor, bottom: nil, topDistance: 15, leftDistance: 5, rightDistance: 0, bottomDistance: 0, height: 40, width: nil)
        _ = topSegmentedControl.constraintAnchors(top: amountTextField.bottomAnchor, left: itemNameTextField.leftAnchor, right: itemNameTextField.rightAnchor, bottom: nil, topDistance: 15, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 30, width: nil)
        _ = bottomSegmentedControl.constraintAnchors(top: topSegmentedControl.bottomAnchor, left: itemNameTextField.leftAnchor, right: view.centerXAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 30, width: nil)
        addButtonConstraints = addButton.constraintAnchors(top: nil, left: itemNameTextField.leftAnchor, right: itemNameTextField.rightAnchor, bottom: backButton.topAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 10, height: 40, width: nil)
        _ = backButton.constraintAnchors(top: nil, left: itemNameTextField.leftAnchor, right: itemNameTextField.rightAnchor, bottom: view.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 25, height: 40, width: nil)
        

    }
    
    private func getListObject(name:String)->List{
        do{
            let listObject = try context.fetch(List.fetchRequest()).filter {$0.name == name}
            return listObject[0]
        } catch {
            print(error)
        }
        return List()
    }
}
