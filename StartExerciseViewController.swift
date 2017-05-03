//
//  StartExerciseViewController.swift
//  ExerciseApp
//
//  Created by Mike Rizza on 3/24/17.
//  Copyright © 2017 Mike Rizza. All rights reserved.
//

import UIKit

class StartExerciseViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    //MARK: - data members
    var exercises = ["Backpacking","Baseball","Basketball","Boxing","Cardio exercise machines (elliptical, treadmill, stair climber)","Climbing (indoor/outdoor)","Cycling (indoor/outdoor)","Dance","Football","Gardening/Yard work"," Golf","Group exercise class (high intensity)","Group exercise class (low intensity)","Gymnastics","Hiking","Hockey","Ice skating","Jumping rope","Martial arts","Other team sport","Pilates","Racquetball","Rowing (indoor or outdoor)","Running (< 9 minute/mile)","Running (> 9 minute/mile)","Skiing","Snowboarding","Soccer","Softball","Swimming","Tennis","Triathlon training","Volleyball","Walking (brisk pace)","Weight lifting (free weights)","Weight lifting(machines)","Yoga"]
    
    var duration = ["15","30","45","60"]
    let defaults = UserDefaults.standard
    

    //MARK: - Outlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var exercisePickerView: UIPickerView!
    @IBOutlet weak var durationPickerView: UIPickerView!
    
    @IBOutlet weak var startExerciseBtn: UIButton!
    
    
    
    
    
    
    @IBAction func startExerciseBtnPressed(_ sender: Any) {
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColor : UIColor = UIColor.blue
        
        exercisePickerView.layer.borderColor = myColor.cgColor
        exercisePickerView.layer.borderWidth = 3.0
        exercisePickerView.layer.cornerRadius = 30
        
        durationPickerView.layer.borderColor = myColor.cgColor
        durationPickerView.layer.borderWidth = 3.0
        durationPickerView.layer.cornerRadius = 30
        
        let startColor : UIColor = UIColor.white
        
        startExerciseBtn.layer.borderColor = startColor.cgColor
        startExerciseBtn.layer.borderWidth = 1.0

        // Do any additional setup after loading the view.
        
        //set delegates and datasources for both pickerViews
        exercisePickerView.delegate = self
        exercisePickerView.dataSource = self
        durationPickerView.delegate = self
        durationPickerView.dataSource = self

        //side menu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "showChosenExercise") {
            
            //find which is selected
            let exerciseIndexPath = exercisePickerView.selectedRow(inComponent: 0)
            let durationIndexPath = durationPickerView.selectedRow(inComponent: 0)
            
            // get selected exercise and duration
            let selectedExercise = exercises[exerciseIndexPath]
            let selectedDuration = duration[durationIndexPath]
        
            //set selected exercise
            defaults.set(selectedExercise, forKey: "savedExercise")
           
            //set the starting count
            defaults.set(selectedDuration, forKey: "startCount")
            
            //calculate and set the updatedCount
            defaults.set(selectedDuration, forKey: "savedCount")
            var count = defaults.integer(forKey: "savedCount")
            count = (count * 60)
            defaults.set(count, forKey: "savedCount")
            
            //set ispaused and isfinished to false
            defaults.set(false, forKey:"isPaused")
            defaults.set(false, forKey:"isFinished")
            
            //set exerxideStarted to true
            defaults.set(true, forKey:"exerciseStarted")
            
            //set startTimer to true
            defaults.set(true, forKey:"startTimer")
            
          
            
             
            
            
            
        }

    }
    
    
    // MARK: - PickerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == exercisePickerView {
            
            return exercises.count
            
        }else if pickerView == durationPickerView{
            
            return duration.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        if pickerView == exercisePickerView {
            
            return exercises[row]
            
        }else if pickerView == durationPickerView{
            
            return duration[row]
        }
 
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }

}
