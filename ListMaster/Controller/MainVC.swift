//
//  ViewController.swift
//  ListMaster
//
//  Created by Paweł Ambrożej on 26/11/2017.
//  Copyright © 2017 Paweł Ambrożej. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate {

    let ad = UIApplication.shared.delegate as! AppDelegate
    lazy var context = ad.persistentContainer.viewContext
    
    var lists:[List]?
    let listCellID = "ListCellIdentifier"
    
    let listsTableView = UITableView()
    
    let logo:UIImageView = {
        let screen = UIView()
        let image = UIImageView()
        screen.backgroundColor = MAIN_COLOR
        screen.addSubview(image)
        image.image = UIImage(named: "AppIcon")
        image.centerInTheView(centerX: screen.centerXAnchor, centerY: screen.centerYAnchor)
        image.setPropertyOf(width: 100, height: 74)
        return image
    }()
    
    let topView:UIView = {
        let tv = UIView()
        tv.backgroundColor = .clear
        return tv
    }()
    
    let titleBG:UIView = {
        let background = UIView()
        background.backgroundColor = .clear
        return background
    }()
    
    
    let addItemButton: UIButton  = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        let backgroundImage = UIImage(named: "AddButton")
        button.setImage(backgroundImage, for: .normal)
        button.addTarget(self, action: #selector(addNewItem), for: .touchUpInside)
        //        button.target(forAction: #selector(addNewItem), withSender: self)
        return button
    }()
    
    lazy var titleLabel: TitleUILabel = {
        let textTitle = TitleUILabel()
        textTitle.text = "Your Lists"
        return textTitle
    }()
    
    @objc func addNewItem() {
        performSegue(withIdentifier: "AddNewList", sender: self)
        
    }
    
    lazy var controller:NSFetchedResultsController<List> = {
        
        let request: NSFetchRequest<List> = List.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let fetchController: NSFetchedResultsController<List> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchController.performFetch()
        } catch let error{
            print(error)
            
        }
        listsTableView.reloadData()
        return fetchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.delegate = self
        setupLayout()
        registerCells()
        listsTableView.delegate = self
        listsTableView.dataSource = self
        listsTableView.separatorInset = UIEdgeInsets.zero
        getLists()
//        clearLists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLists()
        listsTableView.reloadData()
    }
    
    func registerCells() {
        listsTableView.register(ListCell.self, forCellReuseIdentifier: listCellID)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = controller.sections else {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.separatorColor = .clear
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = controller.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let header = TableHeaderView(leftTitle: "Name", rightTitle: "Created")
        headerView.addSubview(header)
//        let width = tableView.bounds.width
        
        _ = header.constraintsTo(top: headerView.topAnchor, left: headerView.leftAnchor, right: headerView.rightAnchor, bottom: headerView.bottomAnchor)
        header.setPropertyOf(width: nil, height: 30)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSelectedListSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowSelectedListSegue" {
                if let targetVC = segue.destination as? SelectedListVC {
                    let index = listsTableView.indexPathForSelectedRow
                    guard let cell = listsTableView.cellForRow(at: index!) as? ListCell else {
                        return
                    }
                    targetVC.listName = cell.listName.text!
                }
            }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("reaload Data")
        let cell = tableView.dequeueReusableCell(withIdentifier: listCellID, for: indexPath) as! ListCell
        
        let list = self.controller.object(at: indexPath)
        
        cell.configureCell(object: list)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        listsTableView.beginUpdates()
        print("controller will change content")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("enter controller serttings")
        switch(type) {
        case .delete :
            listsTableView.deleteRows(at: [indexPath!], with: .top)
            break
        case .insert:
            if let indexPath = newIndexPath{
                listsTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case .move:
            listsTableView.moveRow(at: indexPath!, to: newIndexPath!)
            break
        case .update:
            listsTableView.reloadRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        listsTableView.endUpdates()
    }
    
    @objc func addNewList() {
        performSegue(withIdentifier: "AddNewList", sender: nil)
    }
    
    func setupLayout() {
//        view.addGradient()
        view.backgroundColor = BACKGROUND_COLOR
        view.addSubview(listsTableView)
        view.addSubview(titleBG)
        view.addSubview(titleLabel)
        view.addSubview(addItemButton)
        view.addSubview(topView)
        topView.addSubview(logo)
        

        listsTableView.backgroundColor = .clear
        _ = topView.constraintsWithDistanceTo(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.centerYAnchor, topDistance: 20, leftDistance: 0, rightDistance: 0, bottomDistance: 50)
        logo.centerInTheView(centerX: topView.centerXAnchor, centerY: topView.centerYAnchor)
        _ = titleBG.constraintAnchors(top: topView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0, height: 60, width: nil)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.setPropertyOf(width: 22, height: 22)
        addItemButton.centerYAnchor.constraint(equalTo: titleBG.centerYAnchor).isActive = true
        addItemButton.rightAnchor.constraint(equalTo: titleBG.rightAnchor, constant: -25).isActive = true
        titleLabel.centerInTheView(centerX: titleBG.centerXAnchor, centerY: titleBG.centerYAnchor)
        _ = listsTableView.constraintsWithDistanceTo(top: titleBG.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topDistance: 0, leftDistance: 0, rightDistance: 0, bottomDistance: 0)

    
    }
    
    func getLists() {
        
//        let request:NSFetchRequest<List> = List.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
//        request.sortDescriptors = [sortDescriptor]
//        
//        do {
//            let listTable = try context.fetch(request)
//            self.lists = listTable
//        } catch {
//            fatalError("\(error)")
//        }
    }
    
    func clearLists() {
        if let listArray = lists {
            for list in listArray {
                context.delete(list)
                ad.saveContext()
            }
        }
    }


}
