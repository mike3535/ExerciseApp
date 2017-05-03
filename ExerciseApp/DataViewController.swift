//
//  DataViewController.swift
//  ExerciseApp
//
//  Created by Mike Rizza on 3/24/17.
//  Copyright © 2017 Mike Rizza. All rights reserved.
//

import UIKit
import CoreData
import Charts


class DataViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var exerciseBarChart: BarChartView!
    
    var months = [String]()
    
    var mi = Array(repeating: 0.0, count: 12)
    
    var recordedExercises: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //side menu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            

            months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
           
            
            ///////////////////////
            //1
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //2
            //2
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ExerciseLog")
            
            //3
            do {
                
                recordedExercises = try managedContext.fetch(fetchRequest)
                
                for recordedExercise in recordedExercises{
                    
                    //get all recordedMinutes
                    guard let recMinutes = recordedExercise.value(forKey: "minutes") as? Double else{
                        return
                    }
                    //get the recordedMonths
                    guard let recMonth = recordedExercise.value(forKey: "month") as? Int else {
                        return
                    }
                    
                    //add minutes to its recorded month
                    switch recMonth {
                    case 1:
                        mi[0] += recMinutes
                    case 2:
                        mi[1] += recMinutes
                    case 3:
                        mi[2] += recMinutes
                    case 4:
                        mi[3] += recMinutes
                    case 5:
                        mi[4] += recMinutes
                    case 6:
                        mi[5] += recMinutes
                    case 7:
                        mi[6] += recMinutes
                    case 8:
                        mi[7] += recMinutes
                    case 9:
                        mi[8] += recMinutes
                    case 10:
                        mi[9] += recMinutes
                    case 11:
                        mi[10] += recMinutes
                    case 12:
                        mi[11] += recMinutes
                    default:
                        print("Error with month in core data!")
                    }
         
                    
                    
                    print(mi)
                }
                
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }


        }

        
        setChart(dataPoints: months, values: mi)
        
        
        
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
    
    //set up chart
   func setChart(dataPoints: [String], values: [Double]) {
        exerciseBarChart.noDataText = "You need to provide data for the chart."
        
        exerciseBarChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:months)
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Minutes Exercised")
        let chartData =  BarChartData(dataSet: chartDataSet)
        
        
        
        exerciseBarChart.xAxis.granularity = 1
        
        chartDataSet.colors = [UIColor.orange]
        
        exerciseBarChart.data = chartData
        
        exerciseBarChart.chartDescription?.text = ""
        
    }


}
