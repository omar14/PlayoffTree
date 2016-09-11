//
//  Match.swift
//  PlayoffTree
//
//  Created by Omar AlEssa on 9/8/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import Foundation

class Match{
    
    //MARK: Properties (You can add any additional match info score, date, stadium, etc)
    var title: String
    var homeTeam: String
    var awayTeam: String
    
    //MARK: Match init
    init(title: String, homeTeam: String, awayTeam: String){
        self.title = title
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
    
    
}