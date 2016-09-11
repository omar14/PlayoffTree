//
//  ViewController.swift
//  PlayoffTree
//
//  Created by Omar AlEssa on 9/7/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var hintMessage: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var generateBtn: UIButton!
    
    //MARK: Variables and properties
    var roundNumber = 0
    var playOffTree = PlayOffTree()
    var generateOperation = NSOperation()
    let operationQueue = NSOperationQueue()
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Example of an array of matches to generate the tree from
        let myMatches = [Match(title: "Match1", homeTeam: "LEC", awayTeam: "ARS"), Match(title: "Match2", homeTeam: "BRC", awayTeam: "MAL"), Match(title: "Match3", homeTeam: "DOR", awayTeam: "FCB"), Match(title: "Match4", homeTeam: "FCB", awayTeam: "SWE"), Match(title: "Match5", homeTeam: "MCU", awayTeam: "RAC"), Match(title: "Match6", homeTeam: "POR", awayTeam: "RMD"),  Match(title: "Match7", homeTeam: "VAL", awayTeam: "LIV")]
        
        playOffTree = PlayOffTree(treeMatches: myMatches)
        mainCollectionView.allowsSelection = false
        
        
        self.hideKeyboardWhenTappedAround()
    }
    
    
    //MARK: UICollectionView Functions
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return playOffTree.getNumberOfRounds()
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
        
        // To disable the header to stick while scrolling
        let viewHieght = CGFloat(80)
        let dummeyView = UIView(frame: CGRectMake(0,0,MainCell.matchTableView.bounds.size.width, viewHieght))
        MainCell.matchTableView.tableHeaderView = dummeyView
        MainCell.matchTableView.contentInset = UIEdgeInsetsMake(-viewHieght, 0, 0, 0)
        
        MainCell.matchTableView.separatorColor = UIColor.clearColor()
        MainCell.matchTableView.tableFooterView = UIView()
        MainCell.matchTableView.allowsSelection = false
        
        MainCell.matchTableView.reloadData()
        
    }
    
    
    //MARK: UITableView Functions
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let roundView = UIView(frame: CGRectMake(0,0, tableView.frame.width, 40))
        roundView.backgroundColor = UIColor.clearColor()
        
        let roundTitle = UILabel(frame: roundView.frame)
        roundTitle.text = playOffTree.getRoundName(playOffTree.numberOfMatchesInRound(roundNumber))
        roundTitle.textAlignment = .Center
        roundTitle.textColor = UIColor.whiteColor()
        
        roundView.addSubview(roundTitle)
        
        return roundView
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playOffTree.numberOfMatchesInRound(roundNumber)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("matchCell") as! MatchCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        let matchIndex = (playOffTree.getMatches().count) - (playOffTree.numberOfMatchesInRound(roundNumber)) - indexPath.row
        
        
        if matchIndex % 2 == 0 {
            cell.vsLabel.hidden = true
        }
        else {
            cell.vsLabel.hidden = false
        }
        
        cell.matchTitle.text = playOffTree.getMatch(matchIndex).title
        cell.homeTeam.text = playOffTree.getMatch(matchIndex).homeTeam
        cell.awayTeam.text = playOffTree.getMatch(matchIndex).awayTeam
        
        cell.matchBtn.tag = matchIndex
        cell.matchBtn.addTarget(self, action: #selector(ViewController.matchSelected(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    
    //MARK: Match Selected Response
    func matchSelected(sender: UIButton){
        let matchIndex = sender.tag
        
        let matchAlert = UIAlertController(title: playOffTree.getMatch(matchIndex).title, message:
            "Go to match page", preferredStyle: UIAlertControllerStyle.Alert)
        matchAlert.addAction(UIAlertAction(title: ":)", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(matchAlert, animated: true, completion: nil)
    }
    
    
    //MARK: UISegmentedControl Change Type Response
    @IBAction func changeTypeOfTree(sender: UISegmentedControl) {
        
        textField.text = ""
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            textField.placeholder = "Add number of rounds"
        case 1:
            textField.placeholder = "2,4,8,16,32,.. (2^x)"
        case 2:
            textField.placeholder = "1,3,7,15,31,.. (2^x - 1)"
        default:
            break
        }
    }
    
    
    //MARK: Generate Tree Button Response
    @IBAction func generateTreeClick(sender: UIButton) {
        
        guard let text = textField.text where !text.isEmpty else {
            return
        }
        
        sender.setTitle("", forState: UIControlState.Normal)
        loadingIndicator.startAnimating()
        
        let enteredNumber = Int(self.textField.text!)!
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            generateOperation = NSBlockOperation(block: {
                self.playOffTree = PlayOffTree(numberOfRounds: enteredNumber)
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.updateCollection()
                })
            })
        case 1:
            if !isValidPowerOfTwo(enteredNumber) || enteredNumber == 1{
                hintMessage.alpha = 1
                hintMessage.text = "2,4,8,16,32,.. (2^x) for full tree"
            }
            generateOperation = NSBlockOperation(block: {
                self.playOffTree = PlayOffTree(numberOfTeams: enteredNumber)
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.updateCollection()
                })
            })
        case 2:
            if !isValidPowerOfTwo(enteredNumber+1){
                hintMessage.alpha = 1
                hintMessage.text = "1,3,7,15,31,.. (2^x - 1) for full tree"
            }
            generateOperation = NSBlockOperation(block: {
                self.playOffTree = PlayOffTree(numberOfMatches: enteredNumber)
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.updateCollection()
                })
            })
        default:
            break
        }
        
        
        operationQueue.addOperation(generateOperation)
        
    }
    
    func updateCollection(){
        mainCollectionView.reloadData()
        mainCollectionView.setContentOffset(CGPointZero, animated: true)
        textField.resignFirstResponder()
        self.generateBtn.setTitle("Generate", forState: UIControlState.Normal)
        loadingIndicator.stopAnimating()
        UIView.animateWithDuration(6, animations: {
            self.hintMessage.alpha = 0
        })
    }
    
}

