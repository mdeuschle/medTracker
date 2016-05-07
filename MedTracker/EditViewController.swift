//
//  EditViewController.swift
//  MedTracker
//
//  Created by Matt Deuschle on 5/6/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var addMedTextField: UITextField!
    @IBOutlet var addDosageTexField: UITextField!
    @IBOutlet var segmentedControl: UISegmentedControl!

    var newMed : Medicine?
    var timeToTake = "Morning"

    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        if newMed != nil {

            addMedTextField.text = newMed?.name
            addDosageTexField.text = newMed?.dosage
            timeToTake = (newMed?.time)!

            if timeToTake == "Morning" {
                segmentedControl.selectedSegmentIndex = 0
            } else if timeToTake == "Afternoon" {
                segmentedControl.selectedSegmentIndex = 1
            } else if timeToTake == "Evening" {
                segmentedControl.selectedSegmentIndex = 2
            } else if timeToTake == "Bedtime" {
                segmentedControl.selectedSegmentIndex = 3
            }
        }

        addMedTextField.delegate = self
        addDosageTexField.delegate = self
    }

    // dismiss keyboard if someone touches outside of the textfield
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    // dismiss keyboard on return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        addDosageTexField.resignFirstResponder()
        addMedTextField.resignFirstResponder()
        return true
    }

    // func to dismiss vc in case user is editin or saving

    func dismissVC() {
        navigationController?.popToRootViewControllerAnimated(true)
    }




    @IBAction func onSegmetSelected(sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            timeToTake = "Morning"
        case 1:
            timeToTake = "Afternoon"
        case 2:
            timeToTake = "Evening"
        case 3:
            timeToTake = "Bedtime"
        default:
            break
        }
    }

    @IBAction func saveTapped(sender: UIBarButtonItem) {

        if newMed == nil {

            addMed()
        } else {
            editMed()
        }

        dismissVC()
    }

    func addMed() {

        let entity = NSEntityDescription.entityForName("Medicine", inManagedObjectContext: moc)
        let newMedicine = Medicine(entity: entity!, insertIntoManagedObjectContext: moc)
        newMedicine.name = addMedTextField.text
        newMedicine.dosage = addDosageTexField.text
        newMedicine.time = timeToTake

        do {
            try moc.save()
        } catch {
            return print("error")
        }
    }

    func editMed() {

        newMed?.name = addMedTextField.text
        newMed?.dosage = addDosageTexField.text

        switch segmentedControl {
        case "Morning":
            segmentedControl.selectedSegmentIndex = 0
        case "Afternoon":
            segmentedControl.selectedSegmentIndex = 1
        case "Evening":
            segmentedControl.selectedSegmentIndex = 2
        case "Bedtime":
            segmentedControl.selectedSegmentIndex = 3
        default:
            break
        }

        newMed?.time = timeToTake

        do {
            try moc.save()
        } catch {
            return
        }
    }
}






