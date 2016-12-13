//
//  ViewController.swift
//  ChoreTracker
//
//  Created by Seth Skocelas on 11/20/16.
//  Copyright © 2016 Seth Skocelas. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller: NSFetchedResultsController<ChoreEvent>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        attemptFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureCell (cell: ChoreCell, indexPath: NSIndexPath){
        
        let chore = controller.object(at: indexPath as IndexPath)
        cell.configureCell(chore: chore)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = controller.fetchedObjects, objs.count > 0 {
            
            let chore = objs[indexPath.row]
            performSegue(withIdentifier: "ChoreDetailsVC", sender: chore)
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ChoreDetailsVC" {
            
            if let destination = segue.destination as? ChoreDetailsVC {
                
                if let chore = sender as? ChoreEvent {
                    
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
        
        let fetchRequest: NSFetchRequest<ChoreEvent> = ChoreEvent.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        let nameSort = NSSortDescriptor(key: "choreType.name", ascending: true)
        
        if segment.selectedSegmentIndex == 0 {
            
            fetchRequest.sortDescriptors = [dateSort]
            
        } else if segment.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [nameSort]
            
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
                
                let cell = tableView.cellForRow(at: indexPath) as! ChoreCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                
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
    
    


}

