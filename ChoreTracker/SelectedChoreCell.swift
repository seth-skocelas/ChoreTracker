//
//  SelectedChoreCell.swift
//  ChoreTracker
//
//  Created by Seth Skocelas on 12/30/16.
//  Copyright © 2016 Seth Skocelas. All rights reserved.
//

import UIKit

class SelectedChoreCell: UITableViewCell {
    
    @IBOutlet weak var choreName: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    @IBOutlet weak var choreNotes: UITextView!
    
    func configureCell(chore: ChoreEvent) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        choreName.text = chore.choreType?.name
        
        if chore.date != nil {
            //completionDate.text = formatter.string(from: chore.date as! Date)
            completionDate.text = (chore.date! as Date).getElapsedInterval()
        }
        
        choreNotes.text = chore.notes
        
        choreNotes!.layer.borderWidth = 1
        choreNotes!.layer.borderColor = UIColor.black.cgColor
        
    }
    
}
