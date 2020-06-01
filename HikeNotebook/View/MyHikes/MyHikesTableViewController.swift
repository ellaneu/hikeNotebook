//
//  MyHikesTableViewController.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 3/30/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import UIKit
import os.log

class MyHikesTableViewController: UITableViewController {
    
    var hikes = [Hikes]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedHikes = loadHikes() {
            hikes += savedHikes
//        } else {
//            loadSampleHikes()
//        }
        }

         self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: Instructions Pop UP
    
    let welcomeStatement = "To record your first hike press the add button in the top right corner."
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(!appDelegate.hasAlreadyLaunched) {
            appDelegate.sethasAlreadyLaunched()
            displayFirstHikeStatement(message: self.welcomeStatement)
        }
    }
    
    func displayFirstHikeStatement(message: String) {
        
        // create alert
        let alert = UIAlertController(title: "Welcome", message: message, preferredStyle: .alert)
        
        // create next button
        let nextButton = UIAlertAction(title: "Get started!", style: .default) { (action) -> Void in
            
        }
        
        alert.addAction(nextButton)
        
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hikes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myHikes", for: indexPath) as? MyHikesTableViewCell else {
            fatalError("The dequeued cell is not an instance of MyHikeTableViewCell")
        }
        
        let certainHike = hikes[indexPath.row]
        
        cell.update(with: certainHike)
        

        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "addHike":
            os_log("Adding a new hike.", log: OSLog.default, type: .debug)
            
        case "editHike":
            guard let addHikesViewController = segue.destination as? AddHikesViewController
                else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedHikeCell = sender as? MyHikesTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedHikeCell) else {
                fatalError("The selected cell is not being displayed by the table.")
            }
            
            let selectedHike = hikes[indexPath.row]
            addHikesViewController.hike = selectedHike
            
        default:
            fatalError("Unexpected Segue Identifier: \(segue.identifier)")
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
        if let sourceViewController = segue.source as? AddHikesViewController, let hike = sourceViewController.hike {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                hikes[selectedIndexPath.row] = hike
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: hikes.count, section: 0)
                hikes.append(hike)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            savedHikes()
        }
    }

    // MARK: Table View Editing
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            hikes.remove(at: indexPath.row)
            savedHikes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
// MARK: Private Methods
    
    private func loadSampleHikes() {
        
        let photo1 = UIImage(named: "hikePlaceholder")
        let photo2 = UIImage(named: "hikePlaceholder")
        let photo3 = UIImage(named: "hikePlaceholder")
        
        guard let hike1 = Hikes(hikeName: "Horse Tail Falls", hikeNote: "It is straight up hill.", imageData: photo1, hikeDistance: "4 miles", rating: 4, hikeDifficulty: "Easy") else {
            fatalError("Unable to instantiate hike1")
        }
        
        guard let hike2 = Hikes(hikeName: "Doughnut Falls", hikeNote: "You have to walk through a river to get to the falls.", imageData: photo2, hikeDistance: "3.5 miles", rating: 3, hikeDifficulty: "Hard") else {
            fatalError("Unable to instantiate hike2")
        }
        
        guard let hike3 = Hikes(hikeName: "Stewart Falls", hikeNote: "My favorite waterfall hike.", imageData: photo3, hikeDistance: "3 miles", rating: 5, hikeDifficulty: "Medium") else {
              fatalError("Unable to instantiate hike3")
        }
        
        hikes += [hike1, hike2, hike3]
        
    }
    
    private func savedHikes() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(hikes, toFile: Hikes.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save hikes...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadHikes() -> [Hikes]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Hikes.ArchiveURL.path) as? [Hikes]
    }

}
