//
//  ChoreDetailsVCViewController.swift
//  ChoreTracker
//
//  Created by Seth Skocelas on 12/4/16.
//  Copyright © 2016 Seth Skocelas. All rights reserved.
//

import UIKit
import CoreData


class ChoreDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate {

    @IBOutlet weak var chorePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notes: UITextView!
    
    var chores = [ChoreType]()
    var itemToEdit: ChoreEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chorePicker.delegate = self
        chorePicker.dataSource = self
        
        notes.delegate = self
        
        notes!.layer.borderWidth = 1
        notes!.layer.borderColor = UIColor.black.cgColor
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        
        //createChoreTypes()
        getChores()
        
        if itemToEdit != nil {
            
            loadItemData()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let chore = chores[row]
        return chore.name
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return chores.count
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
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
        
        let chore8 = ChoreType(context: context)
        chore8.name = "Comforter"
        
        ad.saveContext()
        
        
    }
    
    func getChores() {
        
        let fetchRequest: NSFetchRequest<ChoreType> = ChoreType.fetchRequest()
        
        do {
            
            self.chores = try context.fetch(fetchRequest)
            self.chorePicker.reloadAllComponents()
            
        } catch {
            
            //handle this
            
        }
        
    }

    @IBAction func savePressed(_ sender: UIButton) {
        
        var chore: ChoreEvent!
        
        if itemToEdit == nil {
            chore = ChoreEvent(context: context)
        } else {
            chore = itemToEdit
        }
        
        chore.choreType = chores[chorePicker.selectedRow(inComponent: 0)]
        chore.date = datePicker.date as NSDate?
        
        if let userNotes = notes.text {
            
            chore.notes = userNotes
            
        }
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool //
    {
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
    
    
    func loadItemData() {
        
        if let chore = itemToEdit {
            
            datePicker.date = chore.date as! Date
            notes.text = chore.notes
    
            if let type = chore.choreType {
                
                var index = 0
                repeat {
                    
                    let c = chores[index]
                    if c.name == type.name {
                        
                        chorePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                        
                    }
                    index += 1
                } while (index < chores.count)
                
            }
            
        }
        
    }
    
    @IBAction func deleteChore(_ sender: UIBarButtonItem) {
        
        if itemToEdit != nil {
            
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    

}
