//
//  ListTableViewController.swift
//  MedTracker
//
//  Created by Matt Deuschle on 5/6/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let moc : NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var frc : NSFetchedResultsController = NSFetchedResultsController()

    func fetchRequest() -> NSFetchRequest {

        let fetchRequest = NSFetchRequest(entityName: "Medicine")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }

    func getFrc() -> NSFetchedResultsController {

        frc = NSFetchedResultsController(fetchRequest: fetchRequest(), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        frc = getFrc()
        frc.delegate = self

        do {
            try frc.performFetch()
        } catch {
            return
        }
    }

    // update table when new med added

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        let numberOfSections = frc.sections?.count
        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let numberOfRowsInSection = frc.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // set alternating alphas

        if (indexPath.row) % 2 == 0 {

            cell.backgroundColor = UIColor.clearColor()
        } else {

            cell.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            cell.textLabel?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.0)
            cell.detailTextLabel?.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.0)
        }

        let med = frc.objectAtIndexPath(indexPath) as! Medicine
        cell.textLabel?.text = med.name
        cell.detailTextLabel?.text = "\(med.dosage!)mg at \(med.time!)"
        return cell
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        let managedObject : NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject

        moc.deleteObject(managedObject)

        do {
            try moc.save()
        } catch {
            return
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "Edit" {

            let dvc = segue.destinationViewController as! EditViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let newMed = frc.objectAtIndexPath(indexPath!) as! Medicine
            dvc.newMed = newMed
        }














//        if segue.identifier == "Edit" {
//
//            let medController = segue.destinationViewController as! EditViewController
//            let cell = sender as! UITableViewCell
//            let indexPath = tableView.indexPathForCell(cell)
//            let newMed = frc.objectAtIndexPath(indexPath!) as! Medicine
//            medController.newMed = newMed
//        }


        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
