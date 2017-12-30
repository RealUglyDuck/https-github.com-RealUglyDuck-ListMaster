//
//  SelectedListVC.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 18/12/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit
import CoreData

class SelectedListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    let ad = UIApplication.shared.delegate as! AppDelegate
    lazy var context = ad.persistentContainer.viewContext
    
    var listName:String = ""
    var productList: [Product]?
    
    let titleBG:UIView = {
        let background = UIView()
        background.backgroundColor = MAIN_COLOR
        return background
    }()
    
    let backButton:StandardUIButton = {
        let button = StandardUIButton()
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let addItemButton: UIButton  = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        let backgroundImage = UIImage(named: "AddIcon")
        button.setImage(backgroundImage, for: .normal)
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
//        button.target(forAction: #selector(addNewItem), withSender: self)
        return button
    }()
    
    lazy var titleLabel: StandardUILabel = {
        let textTitle = StandardUILabel()
        textTitle.text = listName
        textTitle.textColor = .white
        textTitle.font = UIFont(name: "HelveticaNeue-Medium", size: 24)
        textTitle.textAlignment = .center
        return textTitle
    }()
    
    lazy var controller:NSFetchedResultsController<Product> = {
        
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let predicate = NSPredicate(format: "toList.name == %@", listName)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        let sectionSortDescriptor = NSSortDescriptor(key: "isInBasket",ascending:true)
        request.predicate = predicate
        request.sortDescriptors = [sectionSortDescriptor,sortDescriptor]
        
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
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addNewItem() {
        performSegue(withIdentifier: "AddNewItemSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewItemSegue" {
            if let targetVC = segue.destination as? NewItemVC {
                targetVC.listName = self.listName
            }
        }
    }
    
    let listTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        listTableView.delegate = self
        listTableView.dataSource = self
        controller.delegate = self
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        listTableView.separatorInset = .init(top: 0, left: 25, bottom: 1, right: 25)
        
        print(listName)
        listTableView.register(ItemCell.self, forCellReuseIdentifier: "CellName")
        listTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        listTableView.reloadData()
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
        
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sections = controller.sections else {
            return UIView()
        }
        
        let selectedSection = sections[section]
        if selectedSection.name == "1" {
            let header = TableHeaderView(leftTitle: "In Basket", rightTitle: "")
            header.setColorsOf(text: .white, background: SECONDARY_COLOR)
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
        return [action]
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
                } else {
                    cell.name.textColor = MAIN_COLOR
                    cell.amount.textColor = MAIN_COLOR
                    cell.measureUnit.textColor = MAIN_COLOR
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
    }

    func setupLayout() {
        view.addSubview(titleBG)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(listTableView)
        view.addSubview(addItemButton)
        
        _ = titleBG.constraintAnchors(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 60, width: nil)
        _ = backButton.constraintAnchors(top: titleBG.topAnchor, left: titleBG.leftAnchor, right: nil, bottom: titleBG.bottomAnchor, topDistance: 0, leftDistance: 25, rightDistance: 0, bottomDistance: 0, height: nil, width: 50)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.setPropertyOf(width: 22, height: 22)
        addItemButton.centerYAnchor.constraint(equalTo: titleBG.centerYAnchor).isActive = true
        addItemButton.rightAnchor.constraint(equalTo: titleBG.rightAnchor, constant: -25).isActive = true
        _ = titleLabel.constraintsWithDistanceTo(top: titleBG.topAnchor, left: backButton.rightAnchor, right: addItemButton.leftAnchor, bottom: titleBG.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
        
        _ = listTableView.constraintsWithDistanceTo(top: titleBG.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topDistance: 20, leftDistance: 0, rightDistance: 0, bottomDistance: 0)
    }
    
    func getItems() {
        
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let predicate = NSPredicate(format: "toList.name == %@", listName)
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        
        request.predicate = predicate
        request.sortDescriptors = [sortDescriptor]
        
        do {
            let productTable = try context.fetch(request)
            self.productList = productTable
        } catch {
            fatalError("\(error)")
        }
    }
}
