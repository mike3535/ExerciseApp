//
//  StartNewWorkoutDetailViewController.swift
//  ExerciseApp
//
//  Created by Mike Rizza on 3/25/17.
//  Copyright © 2017 Mike Rizza. All rights reserved.
//

import UIKit
import CoreData

class StartNewWorkoutDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var imageArray = [UIImage(named:"1a"),UIImage(named:"1b"),UIImage(named:"1c")]

    //MARK: Data Members
    var instructions:String = String()
    var labels:String = String()
    
    var recordedExercises: [NSManagedObject] = []
    
    //MARK: Outlets
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        instructionsTextView.text = instructions
        
        let myColor : UIColor = UIColor.white
        finishButton.layer.borderColor = myColor.cgColor
        finishButton.layer.borderWidth = 1.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! WorkoutImageCollectionViewCell
        
        cell.image.image = imageArray[indexPath.row]
        
        return cell
    
    }
    
    @IBAction func finishBtnClicked(_ sender: Any) {
        
        //get current date
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        // 2  create a new managed object and insert it into the managed object context
        let entity = NSEntityDescription.entity(forEntityName: "ExerciseLog", in: managedContext)!
        
        // 2
        let cdExercise = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //save into coreData
        cdExercise.setValue(30,forKeyPath: "minutes")
        cdExercise.setValue(month, forKey: "month")
        
        
        do {
            try managedContext.save()
            recordedExercises.append(cdExercise)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        presentAlertWithTitle(title: "Congratulations!",  andMessage: "You completed your workout \(labels)!")
        
        self.performSegue(withIdentifier: "Menu", sender: self)
    }
    


//function for pop up message
func presentAlertWithTitle(title: String, andMessage message: String) {
    
    let alertController = UIAlertController(title: title, message: message,preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
}

}
