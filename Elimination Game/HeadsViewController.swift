//
//  HeadsViewController.swift
//  Elimination Game
//
//  Created by Jeffrey Kim on 4/15/19.
//  Copyright © 2019 Georgia Ann Douglas. All rights reserved.
//

import UIKit
import Foundation
import GoogleSignIn
import Alamofire
import SwiftyJSON


class HeadsViewController: UIViewController, GIDSignInUIDelegate {
    
//initiate label variables
    @IBOutlet weak var headsDayLabel: UILabel!
    @IBOutlet weak var killLeaderLabel: UILabel!
    @IBOutlet weak var playersEliminatedLabel: UILabel!
    @IBOutlet weak var playersAliveLabel: UILabel!
   
    //function for finding Day X since game's start
    func findGameDay() -> String {
        //how do we replace this placeholder date? Possibly, retrieve from a server. At least you only need this once.
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
        var currentGameDay = findGameDay()
        headsDayLabel.text = "Elapsed: \(currentGameDay)"
       // playersAliveLabel.text = "\()"
     //   playersEliminatedLabel = "\()"
     //   killLeaderLabel =
    }
    
    @IBAction func startCountdownButton(_ sender: Any) {
        //TODO
    }
    
    @IBAction func shufflePlayersButton(_ sender: Any) {
        //TODO
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
