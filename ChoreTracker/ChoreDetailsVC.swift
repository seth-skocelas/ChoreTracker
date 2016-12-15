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
    @IBOutlet weak var scrollView: UIScrollView!
    
    var chores = [ChoreType]()
    var itemToEdit: ChoreEvent?
    weak var activeTextView: UITextView?
    var keyboardSize: CGSize?
    var keyboardSizeRetrieved: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        chorePicker.delegate = self
        chorePicker.dataSource = self
        
        notes.delegate = self
        
        notes!.layer.borderWidth = 1
        notes!.layer.borderColor = UIColor.black.cgColor
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(retrieveKeyboardSize), name: Notification.Name.UIKeyboardWillShow, object: nil)

        
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
        self.notes.becomeFirstResponder()
        self.notes.resignFirstResponder()

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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if (keyboardSizeRetrieved == true) {
            
            self.activeTextView = textView
            scrollView.isScrollEnabled = true
            preventKeyboardFromBlockingText()
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if (keyboardSizeRetrieved == true) {
        
            self.activeTextView = nil
            //scrollView.isScrollEnabled = false
            
        } else {
            
            keyboardSizeRetrieved = true
            
        }
        
    }
    
    private func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    func preventKeyboardFromBlockingText () {
        
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect: CGRect = self.view.frame
        aRect.size.height -= (keyboardSize?.height)!
        let activeTextFieldRect: CGRect? = activeTextView?.frame
        scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
        
    }
    
    
    func retrieveKeyboardSize(notification:NSNotification){
        
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let value: NSValue = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
        keyboardSize = value.cgRectValue.size
        
        }
    
    func keyboardWillHide(notification:NSNotification){
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
    }
    
    override func viewWillLayoutSubviews(){
        
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 300, height: 600)
        
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
