//
//  ViewController.swift
//  PlayoffTree
//
//  Created by Omar AlEssa on 9/7/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    
    var roundNumber = 0
    
    var playOffTree: PlayOffTree?
    var numberOfMatchesInRound = [Int]()
    var treeMatches = [Match]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myMatches = [Match(title: "Match1", homeTeam: "VAL", awayTeam: "ARS"), Match(title: "Match2", homeTeam: "BRC", awayTeam: "MAL"), Match(title: "Match3", homeTeam: "DOR", awayTeam: "FCB"), Match(title: "Match4", homeTeam: "FCB", awayTeam: "SWE"), Match(title: "Match5", homeTeam: "MCU", awayTeam: "RAC"), Match(title: "Match6", homeTeam: "POR", awayTeam: "RMD"),  Match(title: "Match7", homeTeam: "LIV", awayTeam: "LEC")]
        
        playOffTree = PlayOffTree(treeMatches: myMatches)
        numberOfMatchesInRound = playOffTree!.getNumberOfMatchesInRound()
        treeMatches = playOffTree!.getMatches()
        
    }
    
    //TODO: See what you can do with this
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        queue.cancelAllOperations()
        playOffTree = nil
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (playOffTree?.getNumberOfRounds())!
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
     
        return CGSizeMake(collectionView.frame.width, collectionView.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let roundCell = collectionView.dequeueReusableCellWithReuseIdentifier("roundCell", forIndexPath: indexPath) as! RoundCell
        
        roundCell.contentView.frame = roundCell.bounds
        
        return roundCell
        
    }
    
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let MainCell = cell as? RoundCell else {
            return
        }
       
        roundNumber = indexPath.section
        
        let viewHieght = CGFloat(80)
        let dummeyView = UIView(frame: CGRectMake(0,0,MainCell.matchTableView.bounds.size.width, viewHieght))
        MainCell.matchTableView.tableHeaderView = dummeyView
        MainCell.matchTableView.contentInset = UIEdgeInsetsMake(-viewHieght, 0, 0, 0)
        
        MainCell.matchTableView.separatorColor = UIColor.clearColor()
        MainCell.matchTableView.tableFooterView = UIView()
        MainCell.matchTableView.allowsSelection = false
        
        
        MainCell.matchTableView.reloadData()
        
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let roundView = UIView(frame: CGRectMake(0,0, tableView.frame.width, 40))
        roundView.backgroundColor = UIColor.clearColor()
        
        let roundTitle = UILabel(frame: roundView.frame)
        roundTitle.text = playOffTree?.getRoundName(numberOfMatchesInRound[roundNumber])
        roundTitle.textAlignment = .Center
        roundTitle.textColor = UIColor.whiteColor()
        
        roundView.addSubview(roundTitle)
        
        return roundView
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfMatchesInRound[roundNumber]
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("matchCell") as! MatchCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        let matchIndex = treeMatches.count - numberOfMatchesInRound[roundNumber] - indexPath.row
        print("Round: ", roundNumber)
        print(matchIndex)
        
        cell.matchTitle.text = treeMatches[matchIndex].title
        cell.homeTeam.text = treeMatches[matchIndex].homeTeam
        cell.awayTeam.text = treeMatches[matchIndex].awayTeam
        
        return cell
        
    }
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func changeTypeOfTree(sender: UISegmentedControl) {
        
        textField.text = ""
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            textField.placeholder = "Add number of rounds"
        case 1:
            textField.placeholder = "Add number of teams participating"
        case 2:
            textField.placeholder = "Add number of matches"
        default:
            break
        }
    }
    
    var generateOperation = NSOperation()
    let queue = NSOperationQueue()

    @IBAction func generateTreeClick(sender: UIButton) {
        
        guard let text = textField.text where !text.isEmpty else {
            return
        }
        
        
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            generateOperation = NSBlockOperation(block: {
                self.playOffTree = PlayOffTree(numberOfRounds: Int(self.textField.text!)!)
                self.numberOfMatchesInRound = self.playOffTree!.getNumberOfMatchesInRound()
                self.treeMatches = self.playOffTree!.getMatches()
            })
        case 1:
            generateOperation = NSBlockOperation(block: {
                self.playOffTree = PlayOffTree(numberOfTeams: Int(self.textField.text!)!)
                self.numberOfMatchesInRound = self.playOffTree!.getNumberOfMatchesInRound()
                self.treeMatches = self.playOffTree!.getMatches()
            })
        case 2:
            generateOperation = NSBlockOperation(block: {
                self.playOffTree = PlayOffTree(numberOfMatches: Int(self.textField.text!)!)
                self.numberOfMatchesInRound = self.playOffTree!.getNumberOfMatchesInRound()
                self.treeMatches = self.playOffTree!.getMatches()
            })
        default:
            break
        }
        
        generateOperation.completionBlock = {
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.mainCollectionView.reloadData()
                self.mainCollectionView.setContentOffset(CGPointZero, animated: true)
                self.textField.resignFirstResponder()
            })
        }
        
        queue.addOperation(generateOperation)
        
    
        
    }
    
}

