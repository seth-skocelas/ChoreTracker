//
//  MainVC.swift
//  ChoreTracker
//
//  Created by Seth Skocelas on 11/20/16.
//  Copyright © 2016 Seth Skocelas. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<ChoreType>!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if (!doChoreTypesExist()) {
            createChoreTypes()
        }
        
        attemptFetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCell (cell: ChoreCell, indexPath: NSIndexPath){
        
        let choreType = controller.object(at: indexPath as IndexPath)
        
        let chore = getRecentChoreEvent(choreType: choreType)
        
        
        cell.configureCell(chore: chore)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects, objs.count > 0 {
            
            let chore = objs[indexPath.row]
            performSegue(withIdentifier: "SelectedChoreVC", sender: chore)
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SelectedChoreVC" {
            
            if let destination = segue.destination as? SelectedChoreVC {
                
                if let chore = sender as? ChoreType {
                    
                    destination.itemToEdit = chore
                }
                
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoreCell", for: indexPath) as! ChoreCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
            
        }
        
        return 0
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            
            return sections.count
            
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<ChoreType> = ChoreType.fetchRequest()
        let dateSort = NSSortDescriptor(key: "mostRecent", ascending: false)
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        
        
        if segment.selectedSegmentIndex == 0 {
         
            fetchRequest.sortDescriptors = [dateSort, nameSort]
         
        } else if segment.selectedSegmentIndex == 1 {
         
            fetchRequest.sortDescriptors = [nameSort, dateSort]
         
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        self.controller = controller
        
        do {
            
            try controller.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
        
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case.insert:
            if let indexPath = newIndexPath {
                
                tableView.insertRows(at: [indexPath], with: .fade)
                
            }
        case.delete:
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        case.update:
            if let indexPath = indexPath {
                
                if let cell = tableView.cellForRow(at: indexPath) as! ChoreCell? {
                    configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                }
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
        
    }
    
    
    func generateTestData() {
        
        
        let choreType = ChoreType(context: context)
        choreType.name = "Vacuum"
        
        
        let chore = ChoreEvent(context: context)
        chore.choreType = choreType
        chore.date = NSDate(timeIntervalSinceNow: 0)
        chore.notes = "Chore 1"
        
        let choreType2 = ChoreType(context: context)
        choreType2.name = "Mop"
        
        let chore2 = ChoreEvent(context: context)
        chore2.choreType = choreType2
        chore2.date = NSDate(timeIntervalSinceNow: 0)
        chore2.notes = "Chore 2"
        
        
        ad.saveContext()
        
        
    }
    
    func getRecentChoreEvent(choreType: ChoreType) -> ChoreEvent {
        
        var chores = [ChoreEvent]()
        
        let fetchRequest: NSFetchRequest<ChoreEvent> = ChoreEvent.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.predicate = NSPredicate(format: "choreType.name == %@", choreType.name!)
        //fetchRequest.fetchLimit = 1
        
        do {
            
            chores = try context.fetch(fetchRequest)
            
        } catch {
            
            print("made it")
            
        }
        
        if chores.count == 0 {
            
            let chore = ChoreEvent(context: context)
            chore.choreType = choreType
            
            return chore
            
        }
        
        return chores[0]
        
    }
    
    
    func createChoreTypes() {
        
        let chore = ChoreType(context: context)
        chore.name = "Vacuum"
        
        let chore2 = ChoreType(context: context)
        chore2.name = "Mop"
        
        let chore3 = ChoreType(context: context)
        chore3.name = "Kitchen"
        
        let chore4 = ChoreType(context: context)
        chore4.name = "Dishwasher"
        
        let chore5 = ChoreType(context: context)
        chore5.name = "Bathroom"
        
        let chore6 = ChoreType(context: context)
        chore6.name = "Laundry"
        
        let chore7 = ChoreType(context: context)
        chore7.name = "Groceries"
        
        let chore8 = ChoreType(context: context)
        chore8.name = "Misc."
        
        let chore9 = ChoreType(context: context)
        chore9.name = "Dusting"
        
        ad.saveContext()
        
        
    }
    
    
    func doChoreTypesExist() -> Bool {
        
        let fetchRequest: NSFetchRequest<ChoreType> = ChoreType.fetchRequest()
        
        do {
            
            let chores = try context.fetch(fetchRequest)
            if chores.count == 0 {
                
                return false
                
            } else {
                
                return true
            }
            
        } catch {
            
            //this needs to be handled properly
            return false
            
        }
        
    }

    
}

