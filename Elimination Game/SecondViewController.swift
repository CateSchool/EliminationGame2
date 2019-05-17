//
//  SecondViewController.swift
//  Elimination Game
//
//  Created by Jeffrey Kim on 4/15/19.
//  Copyright © 2019 Georgia Ann Douglas. All rights reserved.
//

import UIKit
import GoogleSignIn
import GoogleAPIClientForREST
import Alamofire
import SwiftyJSON

//again, class must be a subclass of GIDSignInUIDelegate throughout for the Name to work.
class SecondViewController: UIViewController, GIDSignInUIDelegate {
    
    //self explanatory labels.
    @IBOutlet weak var yourTargetIs: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var preyNameLabel: UILabel!
    @IBOutlet weak var playerDayLabel: UILabel!
    @IBOutlet weak var killQuantityLabel: UILabel!
    
    //using Josh Park's student database. At this time, my JSON variables(?) are not on the server, so it will not function.
    let updateURL = "http://172.17.7.68:8000/api/update/students/"
    let reqURL = "http://172.17.7.68:8000/api/request/students/"
    
    
    let AFParameters: Parameters = ["Email": currentUser.userEmail]
    let AFParamsForPOST: Parameters = ["EGKillCount":currentUser.killCount, "EGNextTarget":currentUser.target, "EGhasRecentlyEliminated":currentUser.hasRecentlyEliminated]
    
    
    //empty player struct that can be updated with new values
    var playerNextTarget = Player(userName: "", userEmail: "", killCount: 0, target: "", hasRecentlyEliminated: false, isKillLeader: false, hasBeenEliminated: false)
    
    //update the information that the client knows. Then, update all labels using that new information. Things like the player's emails and names are assumed to be static, and changes in them will cause issues
    func updateCurrentUserInfo() {
        Alamofire.request(reqURL, method: .get, parameters: AFParameters)
                .responseJSON { response in
                    if let AFresult = response.result.value {
                        let exampleJson = JSON(AFresult)
                        //error test case
                        print(exampleJson)
                        
                        currentUser.killCount = exampleJson["EGKillCount"].intValue
                        currentUser.target = exampleJson["EGNextTarget"].stringValue
                        currentUser.hasRecentlyEliminated = exampleJson["EGhasRecentlyEliminated"].boolValue
                        currentUser.isKillLeader = exampleJson["EGisKillLeader"].boolValue
                    }
                }
        preyNameLabel.text = currentUser.target
        killQuantityLabel.text = "You have: \(currentUser.killCount) kills"
    }

    //function for finding number of days since game's start
    func findGameDay() -> String {
        //how do we replace this placeholder date? Possibly, retrieve from a server
            let placeHolderDateStr = "2019/04/21 00:00"
        //convert the given placeholder string to a NSDate
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            let startingDate = formatter.date(from: placeHolderDateStr)
        //endDate is simply the current time
            let endDate = Date()
        //retrieve the interval between end and start in days (.day returns Int, conver to string)
            let intervalFormatter = DateComponentsFormatter()
            intervalFormatter.allowedUnits = .day
            intervalFormatter.unitsStyle = .full
            let interval = intervalFormatter.string(from: startingDate!, to: endDate)!
        print(interval)
        return interval
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setup basic things. Handled Server Side.
        GIDSignIn.sharedInstance().uiDelegate = self
        updateCurrentUserInfo()
        playerNameLabel.text = currentUser.userName
        //setup Day view. Handled Client Side using a static "start of game" value.
        let currentGameDay = findGameDay()
        playerDayLabel.text = "Days Passed: \(currentGameDay)"
    }
    
  //this creates "extra argument in call" errors that we can't figure out
    //func AFPostPlayerUpdate() {
      //  Alamofire.request(updateURL, method: .post, parameters: AFParameters, encoding: JSONEncoding.default, headers: HTTPHeaders?) { response in
        //    if let json = response.result.value {
            //    print("JSON: \(json)")
          //  } else {
              //  print("did not receive post JSON")
         //   }
            
      //  }
  //  }
    
    
    @IBAction func targetEliminateButton(_ sender: Any) {
        if playerNextTarget.hasBeenEliminated == true {
            //target has already conceded defeat, move on to next target
            currentUser.killCount += 1
            //AFPostPlayerUpdate()
            //use Post to update server on killcount... if it ever works
            killQuantityLabel.text = "\(currentUser.killCount)"
            //update Next Target
            currentUser.target = String(playerNextTarget.target)
            //use AF .get to receive the eliminated-target's target's information, then update client-side "playerNextTarget" entity with that person's properties.
            preyNameLabel.text = currentUser.target
            currentUser.hasRecentlyEliminated = true
            //TODO: turn currentUser.hasrecentlyEliminated back to false after 24 hours
            
           // if (check database for whether the player now has most kills) {
                //currentUser.isKillLeader = true
            // print("congratulations")
            // do something nice!
      //      }
        }
        else {
            //TODO: target has not conceded officially, ask for the victim's next target as password
        }
    }
    
    @IBAction func concedeEliminationButton(_ sender: Any) {
        //TODO: Add a warning, "Are you sure? There's no going back.."
        currentUser.hasBeenEliminated = true
        currentUser.target = "You are Dead!"
        yourTargetIs.isHidden = true
        preyNameLabel.text = currentUser.target
        playerNameLabel.textColor = UIColor.red
        currentUser.hasRecentlyEliminated = false
        
    }

    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
