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
import Alamofire

//this userName is from the Google ID, not the server. It will be passed to the next screen
var GIDuserName: String?

//must mark this class as GIDSignInUIDelegate to receive sign in data from AppDelegate.
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
       // GIDSignIn.sharedInstance().signInSilently()
        NotificationCenter.default.addObserver(self,
            selector: #selector(InitialViewController.receiveToggleAuthUINotification(_:)),
            name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                               object: nil)
        statusText.text = "Initialized... Use Retry Button"
        toggleAuthUI()
        //if the user is signed in silently, just go straight to whatever segue is necessary
        checkPlayerSegue()
    }
    
    // Signout/Retry button tapped
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
        let headStatus = getHeadStatus()
        if headStatus == true {
            //segue redirects to the Head screen
            if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                performSegue(withIdentifier: "passToHead", sender: self)
            }
        }
        else if headStatus == false {
            //segue redirects to the Player screen
            if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                    performSegue(withIdentifier: "passToPlayer", sender: self)
                }
            }
        }

    func getHeadStatus() -> Bool {
        //TODO: instead of hardcoding this (only done for debugging purposes), collect this from a set stored in the database. Should not be hard
        //if the email inputted matches a certain array of emails, redirect to the head screen instead of the player screen
        
        //if X set.contains(currentUser.userEmail) == true;
        if currentUser.userEmail == "georgia_douglas@cate.org" {
            //is a head
            return true
        }
        else {
            //is a player
            return false
        }
        //Will not be executed, but removing this causes an error
        return false
    }

    // Based on whether the User is signed in or not, show or hide relevant buttons.
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            //Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
            
        } else {
            //Signed out
            signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
            statusText.text = "Please Sign In"
        }
    }
    // [END toggle_auth]
    
    //just for looks
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
                                                  object: nil)
    }
    
    //when logged in properly, parse the userInfo google gives us for the userName that we are going to display on the next screen. Then initiate a segue and pass the userInfo on through AppDelegate to the next screen
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                print(userInfo as [String:String])
                GIDuserName = self.statusText.text
                checkPlayerSegue()

            }

        }
    }
    
}


