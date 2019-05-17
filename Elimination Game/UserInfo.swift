//
//  UserInfo.swift
//  Elimination Game
//
//  Created by Jeffrey Kim on 4/26/19.
//  Copyright © 2019 Georgia Ann Douglas. All rights reserved.
//

import Foundation


struct Player {
    //these can be gathered from either the server or the google signin data.
    public var userName : String
    public var userEmail: String
    public var killCount: Int
    //default should be zero.
    public var target: String
    public var hasRecentlyEliminated: Bool! = false
        //if is false at the end of a countdown, eliminate player
    public var isKillLeader: Bool! = false
    public var hasBeenEliminated: Bool! = false
        //where true = the player has been eliminated
    
    
}
