//
//  PlayOffTree.swift
//  PlayoffTree
//
//  Created by Omar AlEssa on 9/9/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import Foundation

class PlayOffTree {
    
    //MARK: Tree properties with default values due to the empty constructor
    private var numberOfRounds = 0
    private var numberOfTeams = 0
    private var treeMatches = [Match]()
    private var numberOfMatchesPerRound = [Int]()
    private var totalMatchesNumber = 0
    
    
    init(){
        
    }
    
    //MARK: Number of Rounds init
    init(numberOfRounds: Int){
        self.numberOfRounds = numberOfRounds
        self.numberOfTeams = getNumberOfTeams(numberOfRounds)
        self.numberOfMatchesPerRound = getNumberOfMatchesPerRoundFromTeam(numberOfTeams)
        self.treeMatches = generateMatches(totalMatchesNumber)
    }
    
    //MARK: Number of Teams init
    init(numberOfTeams: Int){
        if isValidPowerOfTwo(numberOfTeams) && numberOfTeams != 1 {
            self.numberOfRounds = getNumberOfRounds(numberOfTeams)
            self.numberOfTeams = numberOfTeams
            self.numberOfMatchesPerRound = getNumberOfMatchesPerRoundFromTeam(numberOfTeams)
            self.treeMatches = generateMatches(totalMatchesNumber)
        }
    }
    
    //MARK: Number of Matches init
    init(numberOfMatches: Int){
        if isValidPowerOfTwo(numberOfMatches+1) {
            self.numberOfRounds = getNumberOfRounds(numberOfMatches+1)
            self.numberOfTeams = numberOfMatches+1
            self.numberOfMatchesPerRound = getNumberOfMatchesPerRoundFromTeam((numberOfMatches+1))
            self.treeMatches = generateMatches(numberOfMatches)
        }
    }
    
    
    //MARK: Matches Array init
    init(treeMatches: [Match]){
        if isValidPowerOfTwo(treeMatches.count + 1) {
            self.numberOfRounds = getNumberOfRounds(treeMatches.count + 1)
            self.numberOfTeams = treeMatches.count + 1
            self.numberOfMatchesPerRound = getNumberOfMatchesPerRoundFromTeam(treeMatches.count + 1)
            self.treeMatches = treeMatches
        }
    }
    
    
    //MARK: Public functions
    func getNumberOfRounds() -> Int{
        return numberOfRounds
    }
    
    func getMatches() -> [Match]{
        return treeMatches
    }
    
    func getMatch(index: Int) -> Match {
        return treeMatches[index]
    }
    
    func numberOfMatchesInRound() -> [Int]{
        return numberOfMatchesPerRound
    }
    
    func numberOfMatchesInRound(roundNumber: Int) -> Int{
        return numberOfMatchesPerRound[roundNumber]
    }
    
    func getNumberOfTeams(numberOfRounds: Int) -> Int{
        return Int(pow(2.0, Double(numberOfRounds)))
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
    
    
    //MARK: Private functions
    private func getNumberOfRounds(numberOfTeams: Int) -> Int{
        
        if numberOfTeams > 1 {
            numberOfRounds += 1
            getNumberOfRounds(numberOfTeams/2)
        }
        
        return numberOfRounds
    }
    
    
    
    private func getNumberOfMatchesPerRoundFromTeam(totalTeams: Int) -> [Int]{
        
        if totalTeams > 1 {
            numberOfMatchesPerRound.append(totalTeams/2)
            totalMatchesNumber += totalTeams/2
            getNumberOfMatchesPerRoundFromTeam(totalTeams/2)
        }
        
        return numberOfMatchesPerRound
    }
    
    
    
    
    //Generate default matches// (Another alternative will be just showing placeholder names without creating an array, but this way you can access the matches if you want even though it's a little bit slower specially when the number of round becomes big)
    private func generateMatches(numberOfMatches: Int) -> [Match] {
        
        var matches = [Match]()
        for index in 1...numberOfMatches{
            let theTitle = "Match " + String(index)
            matches.append(Match(title: theTitle, homeTeam: "T1", awayTeam: "T2"))
        }
        
        return matches
    }
    


    
}