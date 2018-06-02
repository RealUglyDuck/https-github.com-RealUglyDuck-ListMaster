//
//  SelectedListVC.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 18/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit
import CoreData

class ShoppingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, ListItemEditDelegate {

    let ad = UIApplication.shared.delegate as! AppDelegate
    lazy var context = ad.persistentContainer.viewContext
    
    
    var listName:String = ""
    var productList: [Product]?
    let listTableView = UITableView()
    
    let titleBG:UIView = {
        let background = UIView()
        background.backgroundColor = BACKGROUND_COLOR
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOpacity = 0.5
        background.layer.shadowOffset = CGSize.zero
        background.layer.shadowRadius = 10
        return background
    }()
    
    let backButtonTapView = UIView()
    
    let backButton:StandardUIButton = {
        let button = StandardUIButton()
        button.accessibilityTraits = UIAccessibilityTraitButton
        button.accessibilityLabel = "Back to your lists"
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let image = UIImage(named: "BackButton")
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    
    let addItemButton: UIButton  = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.accessibilityTraits = UIAccessibilityTraitButton
        button.accessibilityLabel = "Add products button"
        let backgroundImage = UIImage(named: "AddButton")
        button.setImage(backgroundImage, for: .normal)
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: TitleUILabel = {
        let textTitle = TitleUILabel()
        textTitle.text = listName
        return textTitle
    }()
    
    lazy var controller:NSFetchedResultsController<Product> = {
        
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let predicate = NSPredicate(format: "toList.name == %@", listName)
//        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        let sectionSortDescriptor = NSSortDescriptor(key: "isInBasket",ascending:true)
        request.predicate = predicate
        request.sortDescriptors = [sectionSortDescriptor]
        
        let fetchController: NSFetchedResultsController<Product> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "isInBasket", cacheName: nil)
        
        do {
            try fetchController.performFetch()
        } catch let error{
            print(error)
            
        }
        listTableView.reloadData()
        return fetchController
    }()
    
    @objc func backButtonPressed() {
        let slideTrans = SlideTransition()
        slideTrans.transitionMode = .Dismiss
        self.transitioningDelegate = slideTrans
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addNewItem() {
        let slideTransition = SlideTransition()
        slideTransition.transitionMode = .Present
        let newItemVC = NewItemVC()
        newItemVC.listName = self.listName
        newItemVC.transitioningDelegate = slideTransition
        present(newItemVC, animated: true)
    }
    
    lazy var bottomBG: UIView = {
        let background = UIView()
        let button = StandardUIButton()
        button.setTitle("Share List", for: .normal)
        button.addTarget(self, action: #selector(handleSharing), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-medium", size: 16)
        background.backgroundColor = BACKGROUND_COLOR
        background.addSubview(button)
        button.centerInTheView(centerX: nil, centerY: background.centerYAnchor)
        button.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -20).isActive = true
        return background
    }()
    
    let emptyListView = EmptyListView(firstString: "You don't have any products. \n Press ", imageName: "AddButton", secondString: " button to add new products")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        registerCells()
        setupLayout()
        listTableView.delegate = self
        listTableView.dataSource = self
        controller.delegate = self
        listTableView.reloadData()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        backButtonTapView.addGestureRecognizer(tap)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfListIsEmpty()
    }
    
    func registerCells() {
        listTableView.register(ItemCell.self, forCellReuseIdentifier: "CellName")
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc func handleSharing() {
        
        let list = generateListString()
        UIGraphicsBeginImageContextWithOptions(CGSize(width: listTableView.contentSize.width, height: listTableView.contentSize.height),false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let previousFrame = listTableView.frame
        
        listTableView.frame = CGRect(x: listTableView.frame.origin.x, y: listTableView.frame.origin.y, width: listTableView.contentSize.width, height: listTableView.contentSize.height)
        
        
        listTableView.layer.render(in: context)
        
        listTableView.frame = previousFrame
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        guard let sharedImage = image else {return}
        let activeView = UIActivityViewController(activityItems: [list], applicationActivities: nil)
        activeView.excludedActivityTypes = [UIActivityType.saveToCameraRoll]
        present(activeView, animated: true, completion: nil)
    }
    
    func checkIfListIsEmpty() {
        if listTableView.visibleCells.count == 0  {
            emptyListView.isHidden = false
        } else {
            emptyListView.isHidden = true
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = controller.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = controller.sections else {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        listTableView.separatorColor = .clear
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sections = controller.sections else {
            return UIView()
        }
        
        let selectedSection = sections[section]
        if selectedSection.name == "1" {
            let header = TableHeaderView(leftTitle: "In Basket", rightTitle: "")
            let bg = SECONDARY_COLOR
            header.setColorsOf(text: .white, background: bg)
            let width = tableView.bounds.width
            header.setPropertyOf(width: width, height: 30)
            return header
        } else if selectedSection.name == "0" {
            let header = TableHeaderView(leftTitle: "To Buy", rightTitle: "")
            let width = tableView.bounds.width
            header.setPropertyOf(width: width, height: 30)
            return header
            
        }
        return UIView()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellName", for: indexPath) as! ItemCell
         
        
        let product = self.controller.object(at: indexPath)

        cell.configureCell(object: product)
        cell.selectionStyle = .none
        cell.accessibilityLabel = "\(cell.name) \(cell.amount) \(cell.measureUnit)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sections = controller.sections else {
            return
        }
        
        let section = sections[indexPath.section]
        let objects = section.objects as! [Product]
        let product = objects[indexPath.row]
        if product.isInBasket {
            product.isInBasket = false
        } else {
            product.isInBasket = true
        }
        ad.saveContext()
        print("Object changed")
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(rowAction,indexPath) in
            let object = self.controller.object(at: indexPath)
            self.context.delete(object)
            self.ad.saveContext()
        })
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            
            let product = self.controller.object(at: indexPath)
            let slideTransition = SlideTransition()
            slideTransition.transitionMode = .Present
            let vc = NewItemVC()
            vc.listName = self.listName
            vc.productToEdit = product
            vc.indexPath = indexPath
            vc.delegate = self
            vc.transitioningDelegate = slideTransition
            self.present(vc, animated: true)

        }
        return [action,editAction]
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        listTableView.beginUpdates()
        print("controller will change content")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("enter controller serttings")
        switch(type) {
        case .delete :
            listTableView.deleteRows(at: [indexPath!], with: .top)
            break
        case .insert:
            if let indexPath = newIndexPath{
                listTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case .move:
            listTableView.moveRow(at: indexPath!, to: newIndexPath!)
            print("Object moved")
            if let cell = listTableView.cellForRow(at: indexPath!) as? ItemCell {
                if newIndexPath?.section == 1 {
                    cell.name.textColor = SECONDARY_COLOR
                    cell.amount.textColor = SECONDARY_COLOR
                    cell.measureUnit.textColor = SECONDARY_COLOR
                    cell.separator.backgroundColor = SECONDARY_COLOR.withAlphaComponent(0.5)
                } else {
                    cell.name.textColor = MAIN_COLOR
                    cell.amount.textColor = MAIN_COLOR
                    cell.measureUnit.textColor = MAIN_COLOR
                    cell.separator.backgroundColor = MAIN_COLOR.withAlphaComponent(0.5)
                }
            }
            
            break
        case .update:
            listTableView.reloadRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch(type) {
        case .delete :
            print("section index: \(sectionInfo.name)")
            listTableView.deleteSections(IndexSet(integer: sectionIndex), with: .top)
            break
        case .insert:
            print("section index: \(sectionInfo.name)")
            listTableView.insertSections(IndexSet(integer: sectionIndex), with: .top)
            break
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        listTableView.endUpdates()
        checkIfListIsEmpty()
    }
    
    func userFinishedEditingItem(at indexPath: IndexPath) {
        print("Delegate methot runned")
        let product = self.controller.object(at: indexPath)
        context.delete(product)
        ad.saveContext()
        listTableView.reloadData()
    }

    func setupLayout() {
        view.backgroundColor = .white
        view.addSubview(listTableView)
        view.addSubview(emptyListView)
        view.addSubview(titleBG)
        titleBG.addSubview(backButton)
        titleBG.addSubview(backButtonTapView)
        titleBG.addSubview(titleLabel)
        titleBG.addSubview(addItemButton)
        view.addSubview(bottomBG)
        
        _ = titleBG.constraintAnchors(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 80, width: nil)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leftAnchor.constraint(equalTo: titleBG.leftAnchor, constant: 25).isActive = true
        backButton.centerYAnchor.constraint(equalTo: titleBG.centerYAnchor, constant: 10).isActive = true
        backButton.setPropertyOf(width: 20, height: 30)
        backButtonTapView.centerInTheView(centerX: backButton.centerXAnchor, centerY: backButton.centerYAnchor)
        backButtonTapView.setPropertyOf(width: 80, height: 50)
        
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.setPropertyOf(width: 32, height: 32)
        addItemButton.centerInTheView(centerX: nil, centerY: backButton.centerYAnchor)
        addItemButton.rightAnchor.constraint(equalTo: titleBG.rightAnchor, constant: -25).isActive = true
        
        _ = titleLabel.centerInTheView(centerX: titleBG.centerXAnchor, centerY: backButton.centerYAnchor)
        _ = listTableView.constraintsWithDistanceTo(top: titleBG.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: bottomBG.topAnchor, topDistance: 15, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        _ = emptyListView.constraintsWithDistanceTo(top: listTableView.topAnchor, left: listTableView.leftAnchor, right: listTableView.rightAnchor, bottom: listTableView.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        
        bottomBG.constraintsTo(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor)
        bottomBG.setPropertyOf(width: nil, height: 40)
        
        listTableView.backgroundColor = .clear
    }
    
    func getItems() -> [Product]?{
        
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let predicate = NSPredicate(format: "toList.name == %@", listName)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let productTable = try context.fetch(request)
            return productTable
        } catch {
            fatalError("\(error)")
        }
        return nil
    }
    
    func generateListString() -> String{
        var list = ""
        let numberOfRows = listTableView.numberOfRows(inSection: 0)
        for index in 0..<numberOfRows {
            if let cell = listTableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ItemCell{
                list += "\(cell.name.text!)\t\(cell.amount.text!)\(cell.measureUnit.text!)\n"
            }
            
        }
        print(list)
        return list
    }
}