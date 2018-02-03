//
//  SummaryVC.swift
//  ChoreTracker
//
//  Created by Seth Skocelas on 12/22/16.
//  Copyright © 2016 Seth Skocelas. All rights reserved.
//

import UIKit
import CoreData

class SummaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    
    var controller: NSFetchedResultsController<ChoreEvent>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.isHidden = false;
        
        
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
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


    

}
