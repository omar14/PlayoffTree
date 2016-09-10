//
//  PlayOffTree.swift
//  PlayoffTree
//
//  Created by Omar AlEssa on 9/9/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import Foundation

class PlayOffTree {
    
    private var numberOfRounds = 0
    private var numberOfTeams = 0
    
    private var firstRoundMatches = [Match]()
    private var numberOfMatchesInRound = [Int]()
    
    private var matchesInRound = [Match]()
    
    init(numberOfRounds: Int){
        self.numberOfRounds = numberOfRounds
        self.numberOfTeams = getNumberOfTeamsInFirstRound(numberOfRounds)
        self.firstRoundMatches = generateMatchesFromNumberOfTeams(numberOfTeams)
        self.numberOfMatchesInRound = getNumberOfMatchesInRoundFromTeam(numberOfTeams)
    }
    
    init(numberOfTeams: Int){
        
        if isValidPowerOfTwo(numberOfTeams) {
            self.numberOfRounds = getNumberOfRounds(numberOfTeams)
            self.numberOfTeams = numberOfTeams
            self.firstRoundMatches = generateMatchesFromNumberOfTeams(numberOfTeams)
            self.numberOfMatchesInRound = getNumberOfMatchesInRoundFromTeam(numberOfTeams)
        }
        
        
    }
    
    init(numberOfMatches: Int){
        
        if isValidPowerOfTwo(numberOfMatches+1) {
            self.numberOfRounds = getNumberOfRounds(numberOfMatches+1)
            self.numberOfTeams = numberOfMatches+1
            self.firstRoundMatches = generateMatches(numberOfMatches)
            self.numberOfMatchesInRound = getNumberOfMatchesInRoundFromTeam((numberOfMatches+1))
        }
        
    }
    
    init(firstRoundMatchesArray: [Match]){
        if isValidPowerOfTwo(firstRoundMatchesArray.count + 1) {
            self.firstRoundMatches = firstRoundMatchesArray
            self.numberOfTeams = firstRoundMatchesArray.count + 1
            self.numberOfRounds = getNumberOfRounds(firstRoundMatchesArray.count + 1)
            self.numberOfMatchesInRound = getNumberOfMatchesInRoundFromTeam(firstRoundMatchesArray.count + 1)
            
        }
    }
    
    
    
    func getNumberOfRounds() -> Int{
        return numberOfRounds
    }
    
    func getMatches() -> [Match]{
        return firstRoundMatches
    }
    
    
    func getNumberOfMatchesInRound() -> [Int]{
        return numberOfMatchesInRound
    }
    
    
    private func getNumberOfRounds(numberOfTeams: Int) -> Int{
        
        if numberOfTeams > 1 {
            numberOfRounds += 1
            getNumberOfRounds(numberOfTeams/2)
        }
        
        return numberOfRounds
    }
    
    
    func getNumberOfTeamsInFirstRound(numberOfRounds: Int) -> Int{
        
        return Int(pow(2.0, Double(numberOfRounds)))
        
    }
    
    
    
    private func getNumberOfMatchesInRoundFromTeam(totalTeams: Int) -> [Int]{
        
        if totalTeams > 1 {
            numberOfMatchesInRound.append(totalTeams/2)
            getNumberOfMatchesInRoundFromTeam(totalTeams/2)
        }
        
        return numberOfMatchesInRound
    }
    
    
    
    func getRoundName(numberOfMatches: Int) -> String {
        
        switch numberOfMatches {
        case 1:
            return "Final"
        case 2:
            return "Semi Final"
        case 4:
            return "Quarter Final"
        default:
            return "Round of " + String(numberOfMatches * 2)
        }
        
    }
    
    
    //Generate default matches from #Teams
    func generateMatchesFromNumberOfTeams(numberOfTeams: Int) -> [Match] {
        
        var matches = [Match]()
        
        for index in 1...numberOfTeams/2{
            let theTitle = "Match " + String(index)
            matches.append(Match(title: theTitle, homeTeam: "T1", awayTeam: "T2"))
        }
        
        return matches
    }
    
    
    //Generate default matches from #Matches
    func generateMatches(numberOfMatches: Int) -> [Match] {
        
        var matches = [Match]()
        
        for index in 1...numberOfMatches{
            let theTitle = "Match " + String(index)
            matches.append(Match(title: theTitle, homeTeam: "T1", awayTeam: "T2"))
        }
        
        return matches
    }
    
    
    func isValidPowerOfTwo(number: Int) -> Bool{
        
        return (number != 0) && ((number & (number - 1)) == 0)
        
    }
    

    
}