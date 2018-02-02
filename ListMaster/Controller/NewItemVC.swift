//
//  NewItemVC.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 19/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit

class NewItemVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate{

    var listName = ""
    var addButtonConstraints: [NSLayoutConstraint]? = nil
    var addedItemsCount = 0
    var predictionData: [String] = []
    var predictionDataFiltered: [String] = []
    let rowHeight: Double = 40
    var predictionHeightConstraint:NSLayoutConstraint?
    
    let ad = UIApplication.shared.delegate as! AppDelegate
    lazy var context = ad.persistentContainer.viewContext
    
    let mainView:UIView = {
        let background = UIView()
        background.backgroundColor = BACKGROUND_COLOR.withAlphaComponent(0.5)
        background.layer.borderColor = UIColor.white.cgColor
        background.layer.borderWidth = 3
        background.layer.cornerRadius = 23
        return background
    }()
    
    let closeButtonTapView = UIView()
    
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named:"CloseIcon")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func closeButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    let mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    let itemNameTextField: NewTextField = {
        let textField = NewTextField()
        textField.placeholder = "List name..."
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        return textField
    }()
    
    let amountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
//        stackView.spacing =
        return stackView
    }()
    
    let amountLabel: StandardUILabel = {
        let label = StandardUILabel()
        label.text = "Amount:"
        label.textAlignment = .right
        return label
    }()
    
    let amountButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    let plusButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        button.image = UIImage(named: "PlusButton")
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var minusButton: UIImageView = {
        let button = UIImageView()
        button.contentMode = .scaleAspectFit
        button.image = UIImage(named: "MinusButton")
        button.isUserInteractionEnabled = true
        return button
    }()
    
    @objc func plusButtonTapped(){
        print("plusButtonTapped")
        var currentAmount = Int(amountTextField.text!)!
        currentAmount = currentAmount + 1
        amountTextField.text = String(currentAmount)
        
    }
    
    @objc func minusButtonTapped(){
        print("plusButtonTapped")
        var currentAmount = Int(amountTextField.text!)!
        if currentAmount != 1 {
            currentAmount = currentAmount - 1
            amountTextField.text = String(currentAmount)
        }
        
    }

    
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
    
    let segmentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let topSegmentedControl: StandardUISegmentedControl = {
        let segment = StandardUISegmentedControl(items: ["pcs","kg","g"])
        segment.tag = 0
        segment.addTarget(self, action: #selector(segmentPressed), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    lazy var bottomSegmentedControl: StandardUISegmentedControl = {
        let segment = StandardUISegmentedControl(items: ["lb","l","ml"])
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
    
    let addedItemsLabel: StandardUILabel = {
        let label = StandardUILabel()
        label.font.withSize(12)
        label.textAlignment = .center
        label.text = ""
        label.textColor = SECONDARY_COLOR
        
        return label
    }()
    
    let addButton: FilledUIButton = {
        let button = FilledUIButton()
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let backButton: StandardUIButton = {
        let button = StandardUIButton()
        let image = UIImage(named: "BackButton")
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let predictionTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        predictionTableView.isHidden = true
        setupLayout()
//        self.hideKeyboardWhenTappedAround()
        predictionTableView.delegate = self
        predictionTableView.dataSource = self
        predictionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadPredictionDataFromCSV()
        predictionTableView.reloadData()
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeButtonPressed))
        let plusTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(plusButtonTapped))
        let minusTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(minusButtonTapped))
        closeButtonTapView.addGestureRecognizer(tap)
        plusButton.addGestureRecognizer(plusTapRecognizer)
        minusButton.addGestureRecognizer(minusTapRecognizer)
        itemNameTextField.delegate = self
        let hideKeyboardTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideKeyboardTap.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardTap)
        hideKeyboardTap.delegate = self
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: predictionTableView))! {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionDataFiltered.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DidSelectRow")
        self.itemNameTextField.text = predictionTableView.cellForRow(at: indexPath)?.textLabel?.text
        predictionTableView.isHidden = true
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = predictionTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = predictionDataFiltered[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    @objc func textFieldChanged(){
        if itemNameTextField.text == nil || itemNameTextField.text == "" {
            predictionTableView.isHidden = true
            
        } else {
            
            let capitalized = itemNameTextField.text!.capitalized
            print(capitalized)
            predictionDataFiltered = predictionData.filter({$0.range(of: capitalized) != nil  })
            predictionTableView.reloadData()
            if predictionTableView.numberOfRows(inSection: 0) == 0 {
                predictionTableView.isHidden = true
            } else {
                let rows = Double(predictionTableView.numberOfRows(inSection: 0))
                predictionHeightConstraint?.constant = CGFloat(rowHeight * rows)
                predictionTableView.isHidden = false
            }
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        predictionTableView.isHidden = true
    }
    
    func setupLayout() {
        view.backgroundColor = BACKGROUND_COLOR.withAlphaComponent(0.8)
        predictionTableView.backgroundColor = BACKGROUND_COLOR.withAlphaComponent(0.9)
        predictionTableView.separatorColor = .clear
        view.addSubview(mainView)
        view.addSubview(closeButton)
        view.addSubview(closeButtonTapView)
        mainView.addSubview(mainStack)
        mainStack.addArrangedSubview(itemNameTextField)
        mainStack.addArrangedSubview(amountStackView)
        amountStackView.addArrangedSubview(amountLabel)
        amountStackView.addArrangedSubview(amountTextField)
        amountStackView.addArrangedSubview(amountButtonStack)
        amountButtonStack.addArrangedSubview(plusButton)
        amountButtonStack.addArrangedSubview(minusButton)
        mainStack.addArrangedSubview(segmentsStackView)
        segmentsStackView.addArrangedSubview(topSegmentedControl)
        segmentsStackView.addArrangedSubview(bottomSegmentedControl)
        mainStack.addArrangedSubview(addedItemsLabel)
        mainStack.addArrangedSubview(addButton)
        mainView.addSubview(predictionTableView)
        
        
        _ = closeButton.constraintsWithDistanceTo(top: mainView.topAnchor, left: nil, right: mainView.rightAnchor, bottom: nil, topDistance: -7, leftDistance: 0, rightDistance: -7, bottomDistance: 0)
        closeButton.setPropertyOf(width: 22, height: 22)
        closeButtonTapView.centerInTheView(centerX: closeButton.centerXAnchor, centerY: closeButton.centerYAnchor)
        closeButtonTapView.setPropertyOf(width: 35, height: 35)
        _ = mainView.constraintsWithDistanceTo(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 40, leftDistance: 20, rightDistance: 20, bottomDistance: 0)
        mainView.setPropertyOf(width: nil, height: 340)
        _ = mainStack.constraintsWithDistanceTo(top: mainView.topAnchor, left: mainView.leftAnchor, right: mainView.rightAnchor, bottom: mainView.bottomAnchor, topDistance: 30, leftDistance: 30, rightDistance: 30, bottomDistance: 30)
        
        _ = predictionTableView.constraintsWithDistanceTo(top: itemNameTextField.bottomAnchor, left: itemNameTextField.leftAnchor, right: itemNameTextField.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 12.5, rightDistance: 12.5, bottomDistance: 0)
        predictionHeightConstraint = predictionTableView.heightAnchor.constraint(equalToConstant: 0)
        predictionHeightConstraint!.isActive = true
        
        amountStackView.translatesAutoresizingMaskIntoConstraints = false
        segmentsStackView.translatesAutoresizingMaskIntoConstraints = false
        itemNameTextField.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        amountButtonStack.translatesAutoresizingMaskIntoConstraints = false
        
        
        amountStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segmentsStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        itemNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addButtonPressed(sender: UIButton) {
        
        var measureUnit = "pcs"
        addedItemsCount += 1
        self.addedItemsLabel.text = "Added \(addedItemsCount) item(s)"
        
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
        
        itemNameTextField.text = ""
        amountTextField.text = "1"
        topSegmentedControl.selectedSegmentIndex = 0
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
    
    func loadPredictionDataFromCSV() {
        guard let filePath = Bundle.main.path(forResource: "GroceryList", ofType: "csv") else {
            return
        }
        do {
            let data = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = data.components(separatedBy: "\n")
            for row in rows {
                self.predictionData.append(row)
            }
        } catch {
            print(error)
        }
        
        
        
    }
}
