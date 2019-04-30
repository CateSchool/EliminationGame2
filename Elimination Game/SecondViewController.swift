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



class SecondViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var preyNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var killQuantityLabel: UILabel!

   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        GIDSignIn.sharedInstance().uiDelegate = self
        playerNameLabel.text = currentUser.userName
        
        let playerEmailID = currentUser.userEmail as String
        print("\(playerEmailID)")
        var spreadsheetID = "17FwJEoRo5yZdCHSX28TdVUex3KPLGOzhf2Opx5xrMMI"
        var range = "2A:A"
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet
            .query(withSpreadsheetId: spreadsheetID, range:range)
       
    }
    
    @IBAction func targetEliminateButton(_ sender: Any) {
        
        
    }
    
    @IBAction func concedeEliminationButton(_ sender: Any) {
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
