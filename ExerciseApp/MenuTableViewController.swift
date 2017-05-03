//
//  MenuTableViewController.swift
//  ExerciseApp
//
//  Created by Mike Rizza on 3/25/17.
//  Copyright © 2017 Mike Rizza. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
  
    var isResumeExerciseInCoreData = false
    var isResumeWorkoutInCoreData = false
    var defaults = UserDefaults()

    @IBAction func startOneExercise(_ sender: Any) {
        
   
            
        }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
       
        
        if let ident = identifier {
           
            if ident == "startExFromSide" {
              
                 if !defaults.bool(forKey: "isFinished") {
                    
                    presentAlertWithTitle(title: "Must Finish Exercise in Progress!", andMessage: "Go to resume Exercise")
                    return false
                }
            }
            
            
            if ident == "resumeFromSide"{
                
                //invalidate  timer
                defaults.set(false, forKey:"startTimer")
                
                 if defaults.bool(forKey: "isFinished") {
                    
                    presentAlertWithTitle(title: "No Exercise In Progress!", andMessage: "Go to start Exercise")
                    
                    return false

                }
                
                
            }
        }
        
        return true
    }
    
    
    //@IBOutlet weak var resumeExerciseBtn: UIButton!
    //@IBOutlet weak var resumeWorkoutBtn: UIButton!
    
    @IBOutlet weak var menuButtonCell: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // check if you should enable resume exercise btn
        // check if you should enable resume exercise btn
       // if defaults.bool(forKey: "isFinished")
       // {
       //     resumeExerciseBtn.isEnabled = false
          //  resumeExerciseBtn.setTitleColor(UIColor.red, for: .normal)
       // }else{
       //     resumeExerciseBtn.isEnabled = true
        //    resumeExerciseBtn.setTitleColor(UIColor.white, for: .normal)
        //}
        
        
        
   /*
        // check if you should enable resume wourkout btn
        if !isResumeWorkoutInCoreData{
            resumeWorkoutBtn.isEnabled = false
            resumeWorkoutBtn.setTitleColor(UIColor.red, for: .normal)
        }else{
            resumeWorkoutBtn.isEnabled = true
            resumeWorkoutBtn.setTitleColor(UIColor.white, for: .normal)
            
        } */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

 /*   override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell

        // Configure the cell...
         if indexPath.row == 0 {
            cell.menuButton.setTitle("View my data", for: .normal)
            
         }else if indexPath.row == 1 {
            cell.menuButton.setTitle("Manage my goals", for: .normal)
            
         }else if indexPath.row == 2 {
            cell.menuButton.setTitle("Start a new workout", for: .normal)
            
         }else if indexPath.row == 3 {
            cell.menuButton.setTitle("Resume my workout", for: .normal)
            
         }else if indexPath.row == 4 {
            cell.menuButton.setTitle("Start one exercise", for: .normal)
            
         }else if indexPath.row == 5 {
            cell.menuButton.setTitle("Resume my exercise", for: .normal)
        }
            


        return cell
    }  */
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
  //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
       
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//    }
    
    //function for pop up message
    func presentAlertWithTitle(title: String, andMessage message: String) {
        
        let alertController = UIAlertController(title: title, message: message,preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    

}
