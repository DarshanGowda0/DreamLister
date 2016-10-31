//
//  ViewController.swift
//  DreamLister
//
//  Created by Darshan Gowda on 31/10/16.
//  Copyright © 2016 Darshan Gowda. All rights reserved.
//

import UIKit
import CoreData

class MainVC : UIViewController,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller : NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
    
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
        
            let sectionInfo  = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell,indexPath : NSIndexPath){
    
        //update cell
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150 
        
    }
    
    func attemptFetch(){
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort  = NSSortDescriptor(key: "created", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller = controller
        
        do{
            try controller.performFetch()
        }catch {
            let err = error as NSError
            print(err)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath]
                    , with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath{
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                
            }
            break
        case .move:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
    
    
    func generateTestData(){
    
        let item = Item(context: context)
        item.title = "New MacBook Pro"
        item.price = 1800
        item.details = "I can't wait untill the september event, I hope they release the new MBPs!"
        
        let item2 = Item(context: context)
        item2.title = "Bose headphones"
        item2.price = 300
        item2.details = "I acn't wait untill the october event, I hope they release the new headphones!"
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 80000
        item3.details = "I acn't wait untill the november event, I hope they release the new model S!"
        
        ad.saveContext()
    }

}

