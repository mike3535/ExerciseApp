//
//  StartNewWorkoutViewController.swift
//  ExerciseApp
//
//  Created by Mike Rizza on 3/24/17.
//  Copyright © 2017 Mike Rizza. All rights reserved.
//

import UIKit

class StartNewWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Data Members
    var pk = [String]()
    var label = [String]()
    var instructions = [String]()
   
    //MARK: - Outlets
    @IBOutlet weak var menuButton: UIBarButtonItem!
   
    @IBOutlet weak var tableView: UITableView!
    
   // var exercises = ["run", "jump", "box", "swim", "bike", "lift"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeGetCall()
        
        
        //set delegate and datasource to self
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        if(segue.identifier == "showChosenWorkout") {
            
            //find which row is selected
            let indexPath = tableView.indexPathForSelectedRow!
            
          //  let labels =  label[indexPath.row]
            let workoutInstrtuctions = instructions[indexPath.row]
            let labels = label[indexPath.row]
            
            let vc = segue.destination as! StartNewWorkoutDetailViewController
            
            //details to pass to new viewcontroller
            vc.instructions = workoutInstrtuctions
            vc.labels = labels
            
        }

    }
    

    // MARK: - Tableview DataSource
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return label.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        //alternate color for rows
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.lightGray
        }
        else
        {
            cell.backgroundColor = UIColor.gray
        }
        
        //for cell border
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5


        
        // Configure the cell...
        let labels = label[indexPath.row]
        
        
        cell.textLabel!.text = labels
        
        return cell
        
    }

    
    // MARK: NETWORKING
    
    //function to download URL async
    func makeGetCall() {
        
        //initialize indicator
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        indicator.startAnimating()
        
        // Set up the URL request
        let urlString: String = "http://students.cs.niu.edu/~exerciseapp/getworkout.php"
        
        //create url
        guard let url = URL(string: urlString)else {
            print("Error: cannot create URL")
            return
        }
        
        //request url
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                DispatchQueue.main.async {
                    self.presentAlertWithTitle(title: "Error", andMessage: "error calling GET")
                }
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                DispatchQueue.main.async {
                    self.presentAlertWithTitle(title: "Error", andMessage: "did not receive data")
                }
                
                return
            }
            // parse the result as JSON, in mainqueue
            DispatchQueue.main.async {
                do {
                    guard let fields = try JSONSerialization.jsonObject(with: responseData, options: []) as? [[String:AnyObject]] else {
                        self.presentAlertWithTitle(title: "Error", andMessage: "error trying to convert data to JSON")
                        
                        return
                    }
                    
                    //parse through the array
                    for field in fields {
                        if let lastName = field["pk"]{
                            self.pk.append(lastName as! String)
                            
                        }
                        
                        if let firstName = field["label"]{
                            self.label.append(firstName as! String)
                        }
                        
                        if let petName = field["instructions"]{
                            self.instructions.append(petName as! String)
                        }
                        

                        //stop indicatore after JSON is parsed
                        indicator.stopAnimating()
                        indicator.isHidden = true
                        
                        print(self.instructions)
                        
                        //reload tableview
                       // self.tableView.reloadData()
                        self.tableView.reloadData()
                    }
                } catch  {
                    self.presentAlertWithTitle(title: "Error", andMessage: "error trying to convert data to JSON")
                }
            }
        }
        task.resume()
    }
    
    // MARK: - helper functions
    func presentAlertWithTitle(title: String, andMessage message: String) {
        
        let alertController = UIAlertController(title: title, message: message,preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

}
