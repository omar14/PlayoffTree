//
//  MatchCell.swift
//  PlayoffTree
//
//  Created by Omar AlEssa on 9/8/16.
//  Copyright © 2016 omaressa. All rights reserved.
//

import UIKit

// The match cell of the UITableView, we can add more UI to the cell to enhance the design 

class MatchCell: UITableViewCell {

    @IBOutlet weak var matchView: UIView!
    @IBOutlet weak var matchTitle: UILabel!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var vsLabel: UILabel!
    @IBOutlet weak var matchBtn: UIButton!
    
}
