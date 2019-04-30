//
//  ViewController.swift
//  Elimination Game
//
//  Created by Georgia Ann Douglas on 4/1/19.
//  Copyright © 2019 Georgia Ann Douglas. All rights reserved.
//
// Based on tutorials from Mr. Macfarlane and Google's official tutorial

import UIKit
import GoogleSignIn


var userName: String?

class InitialViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Mark myself as the delegate
        GIDSignIn.sharedInstance().uiDelegate = self
        // To automatically sign in the user.
    //GIDSignIn.sharedInstance().signInSilently()
        //
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InitialViewController.receiveToggleAuthUINotification(_:)),
                                               name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        statusText.text = "Initialized... Use Retry Button"
        toggleAuthUI()
        checkPlayerSegue()
    }
    
    // [START signout_tapped]
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        // [START_EXCLUDE silent]
        statusText.text = "Signed out."
        toggleAuthUI()
        // [END_EXCLUDE]
    }
    // [END signout_tapped]
    // [START disconnect_tapped]
    @IBAction func didTapDisconnect(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().disconnect()
        // [START_EXCLUDE silent]
        statusText.text = "Disconnecting."
        // [END_EXCLUDE]
    }
    // [END disconnect_tapped]
    func checkPlayerSegue() {
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            performSegue(withIdentifier: "passToPlayer", sender: self)
        }


    }
    
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
            
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
            statusText.text = "Google Sign in iOS Demo"
        }
    }
    // [END toggle_auth]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                print(userInfo as [String:String])
                self.statusText.text = "\(userInfo["statusText"])"
                userName = self.statusText.text
                
                checkPlayerSegue()

            }

        }
    }
    
}


