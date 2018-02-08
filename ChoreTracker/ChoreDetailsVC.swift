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
    @IBOutlet var mainView: UIView!
    
    
    var chores = [ChoreType]()
    var itemToEdit: ChoreEvent?
    weak var activeTextView: UITextView?
    var keyboardSize: CGSize?
    var keyboardSizeRetrieved: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.bindToKeyboard()
        
        chorePicker.delegate = self
        chorePicker.dataSource = self
        
        notes.delegate = self
        
        notes!.layer.borderWidth = 1
        notes!.layer.borderColor = UIColor.black.cgColor
        
        
        if (!doChoreTypesExist()) {
            createChoreTypes()
        }
        
        getChores()
        
        if itemToEdit != nil {
            
            loadItemData()
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        notes.isScrollEnabled = false

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
        
        let chore7 = ChoreType(context: context)
        chore7.name = "Groceries"
        
        let chore8 = ChoreType(context: context)
        chore8.name = "Comforter"
        
        let chore9 = ChoreType(context: context)
        chore9.name = "Dusting"
        
        ad.saveContext()
        
        
    }
    
    func getChores() {
        
        let fetchRequest: NSFetchRequest<ChoreType> = ChoreType.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        do {
            
            self.chores = try context.fetch(fetchRequest)
            
            self.chorePicker.reloadAllComponents()
            
        } catch {
            
            //handle this
            
        }
        
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

    
    
    func saveMostRecentChoreTypeDate (chore: ChoreEvent, onDelete: Bool) {
        
        var choreTypes = [ChoreType]()
        
        let fetchRequest: NSFetchRequest<ChoreType> = ChoreType.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        fetchRequest.predicate = NSPredicate(format: "name = %@", (chore.choreType?.name)!)
        
        do {
            
            choreTypes = try context.fetch(fetchRequest)
            
        } catch {
            
            //handle this
            
        }
        
        let currentChoreType = choreTypes[0]
        
        if  ((currentChoreType.mostRecent == nil)) {
            
            choreTypes[0].mostRecent = chore.date
            
        } else if (chore.date as! Date > currentChoreType.mostRecent as! Date) {
            
            choreTypes[0].mostRecent = chore.date
            
        } else if (onDelete) {
            
            choreTypes[0].mostRecent = chore.date
        }
        
        ad.saveContext()

        
        
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
        
        saveMostRecentChoreTypeDate(chore: chore, onDelete: false)
        
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
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
            
            let currentChoreType = itemToEdit?.choreType
            
            context.delete(itemToEdit!)
            ad.saveContext()
            
            let mostRecentChoreEvent = getRecentChoreEvent(choreType: currentChoreType!)
            
            saveMostRecentChoreTypeDate(chore: mostRecentChoreEvent, onDelete: true)
    
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (keyboardSizeRetrieved == true) {
            
            self.activeTextView = textView
            //preventKeyboardFromBlockingText()
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if (keyboardSizeRetrieved == true) {
        
            self.activeTextView = nil
            
        } else {
            
            keyboardSizeRetrieved = true
            
        }
        
    }
    
    private func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    func preventKeyboardFromBlockingText () {
        
        //dirty hack, don't know why keyboard notification isn't working, hard coding value
        //fix this later!!!! (See eariler commit)
        
    }
    
    override func viewWillLayoutSubviews(){
        
        super.viewWillLayoutSubviews()

        
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
