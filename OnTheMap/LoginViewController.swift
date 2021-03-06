//
//  ViewController.swift
//  OnTheMap
//
//  Created by Damonique Thomas on 6/30/16.
//  Copyright © 2016 Damonique Thomas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Change logo to white
        logo.image = logo.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        logo.tintColor = UIColor.whiteColor()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    //Authenticate the user through their Udacity username and password
    @IBAction func loginPressed(sender: AnyObject) {
        let username = emailTextField.text
        let password = passwordTextField.text
        if username != "" && password != "" {
            activityIndicator.startAnimating()
            UdacityClient.sharedInstance().createSession(username!, password:password!){ (success, error) in
                performUIUpdatesOnMain {
                    if success {
                        self.getStudentLocations()
                    } else {
                        self.displayAlert(error!)
                    }
                }
            }
        } else {
            displayAlert("Please enter a email and password!")
        }
    }
    
    //Sends user to udacity website to sign up for an account
    @IBAction func signUpPressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.udacity.com/account/auth#!/signup")!)
    }
    
    //Authenicates a user through Facebook
    @IBAction func facebookPressed(sender: AnyObject) {
        
    }
    
    func displayAlert(message:String){
        activityIndicator.stopAnimating()
        let alertView = UIAlertController(title: "Uh-Oh", message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    //Keyboard hides when return is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func completeLogin() {
        activityIndicator.stopAnimating()
        let controller = storyboard!.instantiateViewControllerWithIdentifier("mainNavController") as! UINavigationController
        presentViewController(controller, animated: true, completion: nil)
    }

    func getStudentLocations(){
        ParseClient.sharedInstance().getStudentLocations(){ (success, error) in
            performUIUpdatesOnMain {
                if success {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.completeLogin()
                    }
                } else {
                    self.displayAlert(error!)
                }
            }
        }
    }
}

