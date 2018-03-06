//
//  PartViewController.swift
//  FD_Inv
//
//  Created by Fuat on 11/21/17.
//  Copyright © 2017 Joseph K. All rights reserved.
//

import UIKit
import os.log

class PartViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var partnumberTextField:  UITextField!
    @IBOutlet weak var rDateTextField: UITextField!
    @IBOutlet weak var rTimeTextField: UITextField!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value passed by  sender
     or constructed as a new reservation.
     */
    var partnumber: ParNumber?
    
    @IBOutlet weak var rDatePicker: UIDatePicker!
    
    @IBAction func showRDatePicker(_ sender: AnyObject) {
        // TODO
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        partnumberTextField.delegate  = self
        rDateTextField.delegate = self
        rTimeTextField.delegate = self
        qtyTextField.delegate = self
        
        
        // Set up views if editing an existing Reservation.
        if let reservation = reservation {
            navigationItem.title  = partnumber.name
            partnumberTextField.text    = reservation.name
            //rDateTextField.text   = reservation.rDate
            //rTimeTextField.text   = reservation.rTime
            qtyTextField.text   = partnumber.qty
        }
        
        // Enable the Save button all req meant.
        updateSaveButtonState()
    }
    
    //  Disable Save button during edit
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    // Hide Keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddReservationMode = presentingViewController is UINavigationController
        
        if isPresentingInAddReservationMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The viewCont missing nav controller.")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Not saved, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name   = partnumberTextField.text ??  ""
        //let rDate  = rDateTextField.text ?? ""
        //let rTime  = rTimeTextField.text ?? ""
        let qty  = qtyTextField.text ?? ""
        
        // Set the reservation to be passed to ReservationTableViewController after the unwind segue.
        partnumber = PartNumber(partnumber: partnumber, rDate: rDate, rTime: rTime, qty: qty)
    }
    
    
    // Disable Save button if only if all any of text fields left empty. all required fields
    private func updateSaveButtonState() {
        let textPartNumber  = partTextField.text  ?? ""
        let textRDate = rDateTextField.text ?? ""
        let textRTime = rTimeTextField.text ?? ""
        let textQty = qtyTextField.text ?? ""
        
        saveButton.isEnabled = !textPartNumber.isEmpty
        saveButton.isEnabled = !textRDate.isEmpty
        saveButton.isEnabled = !textRTime.isEmpty
        saveButton.isEnabled = !textQty.isEmpty
    }


}

