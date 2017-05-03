//
//  PINViewController.swift
//  ExerciseApp
//
//  Created by Mike Rizza on 3/23/17.
//  Copyright © 2017 Mike Rizza. All rights reserved.
//

import UIKit

class PINViewController: UIViewController, UITextFieldDelegate {
    
     // MARK: - Properties
    
    var pin: String?
    let defaults = UserDefaults.standard
    
     // MARK: - Outlets
    
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var errorTxtField: UITextView!
    
    
    // MARK: - UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //hide back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        pinTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func validatePINLocally() -> Bool {
        
        // 1. Make sure PIN is not nil
        guard let pin = self.pin else {
            return false
        }
        
        // 2. Make sure PIN is exactly 6 characters long
        if pin.characters.count != 6 {
            return false
        }
        
        // 3. Make sure first three characters of PIN are uppercase letters
        //    and that last three are decimal digits
        let letters = CharacterSet.uppercaseLetters
        let digits = CharacterSet.decimalDigits
        
        var count = 0
        for uni in pin.unicodeScalars {
            if count < 3 && !letters.contains(uni) {
                return false
            } else if count >= 3 && !digits.contains(uni) {
                return false
            }
            count += 1
        }
        
        // 4. If everything is OK, return true
        return true
    }
    
    
    func validatePINWithServer(){
        // TODO - Upload pin and app name to server to verify that it is correct
        
        // 1. Make sure PIN is not nil
        guard let pin = self.pin else {
            return
        }
        
        
            //initialize indicator
            let indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.bringSubview(toFront: view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            indicator.startAnimating()
            
            //1. get URL string to request
            var request = URLRequest(url: URL(string: "http://students.cs.niu.edu/~exerciseapp/postcheckvalid.php")!)
        
            //2. set requst method to POST
            request.httpMethod = "POST"
        
            //3. configure post string
            let postString = "ver=\(defaults.integer(forKey: "version"))&pin=\(pin)"
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
                            
                            self.errorTxtField.text = ""

                            let defaults = UserDefaults.standard
                            defaults.set(pin, forKey: "PIN")
                            
                            //Return to main menu view controller
                            self.performSegue(withIdentifier: "Menu", sender: self)
                            
                        }else{
                            
                            //if failure dont segue to menu and fill in errorTextField
                            self.errorTxtField.text = "This token is invalid. There are 8 apps, are you using the right one for you?"
                            
                        }
                    }
                }
                
            }
            task.resume()
        
        return
    }

     // MARK: - UITextFieldDelegate methods
    
    // Dismiss keyboard when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func okBtnPressed(_ sender: Any) {
        
        // 1. Get the PIN from the
        pin = pinTextField.text!
        
        // 2. Check for a valid PIN string
       if !validatePINLocally() {
            errorTxtField.text = "Invalid PIN entered. Please try again."
            return
        }else{
            
            validatePINWithServer()
        }

    }
    

    // When keyboard has been dismissed, check for valid PIN and either return or
    // save the validated PIN and segue back to the main menu

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - helper functions
    func presentAlertWithTitle(title: String, andMessage message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil) }
    
    
}

