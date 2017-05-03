//
//  StartChosenExerciseViewController.swift
//  ExerciseApp
//
//  Created by Mike Rizza on 3/25/17.
//  Copyright © 2017 Mike Rizza. All rights reserved.
//

import UIKit
import CoreData

class StartChosenExerciseViewController: UIViewController {

    //MARK: - data members
    var finishedTime = Int()
    var timer = Timer()
    let defaults = UserDefaults.standard
    var exercise : String!
    
    
    var recordedExercises: [NSManagedObject] = []
    
    //MARK: - outlets
    @IBOutlet weak var pauseResumeBtn: UIButton!
    @IBOutlet weak var exerciseLbl: UILabel!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var finishBtn: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set the time view Loaded
        let timeLoaded = CFAbsoluteTimeGetCurrent()
        defaults.set(timeLoaded, forKey: "timeLoaded")

        //configure buttons
        let myColor : UIColor = UIColor.white
        pauseResumeBtn.layer.borderColor = myColor.cgColor
        pauseResumeBtn.layer.borderWidth = 1.0
        finishBtn.layer.borderColor = myColor.cgColor
        finishBtn.layer.borderWidth = 1.0
        
        //update exerciseLabel
         exercise = defaults.string(forKey: "savedExercise")
        
        //get the starting count
          let sc = defaults.integer(forKey: "startCount")
          exerciseLbl.text = ("\(exercise!) (\(sc) mins)")
        
        let savedCount =  defaults.integer(forKey: "savedCount")

        
        let checkIfPaused = defaults.bool(forKey: "isPaused")
        
        //display time
        let displayStr = String(format:"%02d:%02d", (savedCount/60), savedCount%60)
        timerLbl.text = displayStr
        
        
        if  checkIfPaused {
        
            
            //set button to show resume
            pauseResumeBtn.setTitle("Resume", for: .normal)
            pauseResumeBtn.backgroundColor = UIColor.green
            
           //if timer is not paused on loadup
        }else if !checkIfPaused {
            
            ///check if coming from resume exercise
            
            //set button to show pause
            pauseResumeBtn.setTitle("Pause", for: .normal)
            pauseResumeBtn.backgroundColor = UIColor.red

           
            //if user exited from view set
            if defaults.bool(forKey: "didDisappear")
            {
               // elapsed = CFAbsoluteTimeGetCurrent() - start

                
            }
            
            //start timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(StartChosenExerciseViewController.update), userInfo: nil, repeats: true)
            
        
        
        }

        
        //side menu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
       
        
    }
    
   /* override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
      
    }*/
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        //save that user exited view
        defaults.set(true, forKey: "didDisappear")
    }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    //MARK - actions

    @IBAction func pauseBtnClicked(_ sender: Any) {
        
        let checkIfPaused = defaults.bool(forKey: "isPaused")
        
        if !checkIfPaused {

            
            pauseResumeBtn.setTitle("Resume", for: .normal)
            pauseResumeBtn.backgroundColor = UIColor.green
            
            //store is UserDefaults
           // pausedBtnClicked = true
            defaults.set(true, forKey: "isPaused")
            
        //if you are clicking to resume
        }else if checkIfPaused {
    
            //change title to pause
            pauseResumeBtn.setTitle("Pause", for: .normal)
            pauseResumeBtn.backgroundColor = UIColor.red
            
            //resume timer
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(StartChosenExerciseViewController.update), userInfo: nil, repeats: true)
            
            //set so timer is not paused
            defaults.set(false, forKey: "isPaused")
        }

        
    }
    
    
    
    
    @IBAction func finishBtnClicked(_ sender: Any) {
    
         exercise = defaults.string(forKey: "savedExercise")
        defaults.set(false, forKey: "startTimer")
        
        //set isfinished to true
        defaults.set(true, forKey: "isFinished")
        
       
        
        //set exerxideStarted to false
        defaults.set(false, forKey:"exerciseStarted")
        
        //set so not paused
        defaults.set(false, forKey: "isPaused")
        
        //set elapsed time to 0 
        defaults.set(0, forKey: "elapsedTimeInBackground")

        //calculate time completed and present
        let duration = defaults.integer(forKey: "startCount")
        let count = defaults.integer(forKey: "savedCount")
        finishedTime = (duration * 60) - count
        
        let minutes = String(finishedTime / 60)
        let seconds = String(finishedTime % 60)
        presentAlertWithTitle(title: "Congratulations!",  andMessage: "You completed \(minutes) minutes \(seconds) seconds of \(exercise!)")
        
        pauseResumeBtn.isHidden = false
        
        //store and save on server!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        //get pin
        let pin = defaults.string(forKey: "PIN")!
        
        //get current date
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        
        //set activity
        let activity = 1
        
        //get version
        let ver = defaults.integer(forKey: "version")
        
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
            //initialize indicator
            let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.bringSubview(toFront: view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            indicator.startAnimating()
            
            //1. get URL string to request
            var request = URLRequest(url: URL(string: "http://students.cs.niu.edu/~exerciseapp/postusagedata.php")!)
            
            //2. set requst method to POST
            request.httpMethod = "POST"
            
            //3. configure post string
            let postString = "pin=\(pin)&min=\(minutes)&act=\(activity)&name=\(exercise)&dt=\(date)&ver=\(ver)"
            request.httpBody = postString.data(using: .utf8)
            
            //5. send psotString request to URL
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
                }
                
                //make sure http status is 200
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    
                }
                
                //check for success or failure from response string
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                    DispatchQueue.main.async {
                        
                        //stop indicatore after data is uploaded
                        indicator.stopAnimating()
                        indicator.isHidden = true
                        
                        //if success sugue to menu and store PIN in UserDefaults
                        if responseString == "{\"status\":\"success, pin and verison are correct\"}"{
                            
                           // self.errorTxtField.text = ""
                            
                            let defaults = UserDefaults.standard
                            defaults.set(pin, forKey: "PIN")
                            
                            //Return to main menu view controller
                            self.performSegue(withIdentifier: "Menu", sender: self)
                            
                        }else{
                            
                            //if failure dont segue to menu and fill in errorTextField
                          //  self.errorTxtField.text = "This token is invalid. There are 8 apps, are you using the right one for you?"
                            
                        }
                    }
                }
                
            }
            task.resume()
            
      ////////////////////////////////////////////////////////////////////////////////////////////////////
        let cdMinutes = (finishedTime / 60)
        
       // save(data: cdMinutes, entityName: "ExerciseLog", keyPath: "minutes")
        //save(data: exercise, entityName: "ExerciseLog", keyPath: "exercise")
        
        //fetch from coreData
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        // 2  create a new managed object and insert it into the managed object context
        let entity = NSEntityDescription.entity(forEntityName: "ExerciseLog", in: managedContext)!
        
        // 2
        let cdExercise = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //save into coreData
        cdExercise.setValue(cdMinutes,forKeyPath: "minutes")
        cdExercise.setValue(exercise,forKeyPath: "exercise")
        cdExercise.setValue(month, forKey: "month")
        

          do {
            try managedContext.save()
            recordedExercises.append(cdExercise)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

        
       /////for fetching 
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExerciseLog")
        
        //3
        do {
            
            recordedExercises = try managedContext.fetch(fetchRequest)
            
            for recordedExercise in recordedExercises{
                
                guard let re = recordedExercise.value(forKey: "exercise") as? String else{
                        return
                }
                
                
                
                if re == "Boxing"{
                
            
            print("my minutes \(String(describing: recordedExercise.value(forKey: "minutes")!))")
                }
                
                print("my ex \(String(describing: recordedExercise.value(forKey: "exercise")!))")
            }
            
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    
    

        
        
        
        print(date, pin, minutes, activity, ver, exercise)
        //print(month)
        
        
        
    }   
    
   
    
    //MARK - helper functions
    
    //function to update timer called every seocnd
    func update() {
        
        //get saved count
        var count = defaults.integer(forKey: "savedCount")
        
        
        
        
        //if time elapsed is greater than count set count to zero, else subtract elapsedTime from count
        if defaults.integer(forKey: "elapsedTimeInBackground") > count{
            count = 0
        }else{
        
        count = count - defaults.integer(forKey: "elapsedTimeInBackground")
        }
        
        //if count is greater than zero display count, subtract count by 1 and save savedCount
        if(count > 0){
            
            // if timer is paused or finished stop it or if timer needs to be invalidated when returned from menu
            if defaults.bool(forKey: "isPaused") || defaults.bool(forKey: "isFinished") || !defaults.bool(forKey:"startTimer")
            {
                timer.invalidate()
                defaults.set(false, forKey: "tv")
               
                //set startTimer to true
                defaults.set(true, forKey: "startTimer")
                return
            }
            
            let displayStr = String(format:"%02d:%02d", (count/60), count%60)
            
            timerLbl.text = displayStr
            
            let b = count
            
            count -= 1
            
            let c = count
            
            print("\(b)  and c is \(c)")
           
            //set savedCount
            defaults.set(count, forKey: "savedCount")
        
            print(count)
        } else{
            
            //if count is at or below zero update timerLbl and stop timer
            defaults.set(0, forKey: "savedCount")
            timerLbl.text = "Workout Complete!"
            timerLbl.font = UIFont.systemFont(ofSize: 30)
            timer.invalidate()
            pauseResumeBtn.isHidden = true
        }
        
        //set elapsed time to 0 because update is called every second
        defaults.set(0, forKey: "elapsedTimeInBackground")
    }
    
    //function for pop up message
    func presentAlertWithTitle(title: String, andMessage message: String) {
        
        let alertController = UIAlertController(title: title, message: message,preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK: coreData
    func save(data: Any, entityName: String, keyPath: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: entityName,
                                       in: managedContext)!
        
        let exercise = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        exercise.setValue(data, forKeyPath: keyPath)
        
        // 4
        do {
            try managedContext.save()
            recordedExercises.append(exercise)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}

