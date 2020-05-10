//
//  ViewController.swift
//  OnTheMap
//
//  Created by ludwig vantours on 29/04/2020.
//  Copyright © 2020 LudwigVaan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  let netInfo = NetInfo()
  
  @IBOutlet weak var login: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var loader: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    let navigationBar = navigationController
    navigationBar?.isNavigationBarHidden = true
  }
  
  @IBAction func LoginTap(_ sender: Any) {
    isLoading(true)
    APIClient.requestUserSession(username: login.text ?? "", password: password.text ?? "", completion: handleUserSession)
  }
  
  @IBAction func SignUpAction(_ sender: Any) {
    // https://auth.udacity.com/sign-up
    let signUpURL = URL(string: "https://auth.udacity.com/sign-up")
    UIApplication.shared.open(signUpURL!, options: [:], completionHandler: nil)
  }
  
  func handleUserSession(success: Bool, error: Error?){
    if(success){
      APIClient.getUserData(accountKey: User.account.key, completion: handleUserData)
    } else {
      isLoading(false)
      showAlertMessage(title: "Login Error", message: error?.localizedDescription ?? "")
    }
  }
  
  func handleUserData(success: Bool, error: Error?) {
    if success {
      APIClient.getStudentLocation(completion: handleStudentLocations)
    } else {
      isLoading(false)
      showAlertMessage(title: "Login Error", message: error?.localizedDescription ?? "")
    }
    
    
  }
  
  func handleStudentLocations(success: Bool, error: Error?){
    isLoading(false)
    if(success){
      performSegue(withIdentifier: "MapViewController", sender: nil)
    } else{
      isLoading(false)
      showAlertMessage(title: "Login Error", message: error?.localizedDescription ?? "")
    }
    
  }
  
  func isLoading(_ state: Bool) {
    if(state) {
      loader.startAnimating()
    } else {
      loader.stopAnimating()
    }
    login.isEnabled = !state
    password.isEnabled = !state
    loginButton.isEnabled = !state
  }
  
}

