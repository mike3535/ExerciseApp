//
//  MenuViewController.swift
//  ExerciseApp
//
//  Created by Mike Rizza on 3/23/17.
//  Copyright © 2017 Mike Rizza. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    //save this when pausing exercis in startchosenexerciseviewcontroller
  //  var pausedBtnClicked = false
    
   // var isResumeWorkoutInCoreData = false
    
    let defaults = UserDefaults.standard
    
    
    //MARK: - outlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var dataBtn: UIButton!
    @IBOutlet weak var goalsBtn: UIButton!
    @IBOutlet weak var startNewWorkoutBtn: UIButton!
    @IBOutlet weak var startOneExerciseBtn: UIButton!
    
    
    
    @IBOutlet weak var resumeExerciseBtn: UIButton!
    @IBOutlet weak var resumeWorkoutBtn: UIButton!
    
    
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        
        //if there is no pin stored go to loging screen
        let pin = defaults.string(forKey: "PIN")
        if pin == nil {
            performSegue(withIdentifier: "Get PIN", sender: self)
            
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        let myColor : UIColor = UIColor.white
        
        resumeWorkoutBtn.layer.borderColor = myColor.cgColor
        resumeWorkoutBtn.layer.borderWidth = 1.0
        
        dataBtn.layer.borderColor = myColor.cgColor
        dataBtn.layer.borderWidth = 1.0
        
        goalsBtn.layer.borderColor = myColor.cgColor
        goalsBtn.layer.borderWidth = 1.0        
        
        startNewWorkoutBtn.layer.borderColor = myColor.cgColor
        startNewWorkoutBtn.layer.borderWidth = 1.0
        
        startOneExerciseBtn.layer.borderColor = myColor.cgColor
        startOneExerciseBtn.layer.borderWidth = 1.0
        
        resumeExerciseBtn.layer.borderColor = myColor.cgColor
        resumeExerciseBtn.layer.borderWidth = 1.0
        
        
        
        //side menu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
               
        // check if you should enable resume exercise btn
        if defaults.bool(forKey: "isFinished")
        {
            resumeExerciseBtn.isEnabled = false
            resumeExerciseBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            
            startOneExerciseBtn.isEnabled = true
            startOneExerciseBtn.backgroundColor = UIColor.blue
            
            
        }else{
            resumeExerciseBtn.isEnabled = true
            resumeExerciseBtn.backgroundColor = UIColor.blue
            
            startOneExerciseBtn.isEnabled = false
            startOneExerciseBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        }
        
        // check if you should enable resume wourkout btn
      // if !isResumeWorkoutInCoreData{
            resumeWorkoutBtn.isEnabled = false
            resumeWorkoutBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
     /*   }else{
            resumeWorkoutBtn.isEnabled = true
            resumeWorkoutBtn.backgroundColor = UIColor.blue
 */
            
        }

    //}
   // }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "resumeFromMain") {
            
            //set startTimer to false
            defaults.set(false, forKey:"startTimer")
            
            
           
            
            
            
                    
                   // vc.timer.invalidate()
            
          
                    
                    
        }

        
    }
    
    
    //create segue for menu
    @IBAction func unwindToMenu(segue: UIStoryboardSegue){
        
    }

}
