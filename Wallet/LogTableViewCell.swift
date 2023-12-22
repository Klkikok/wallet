//
//  LogTableViewCell.swift
//  Wallet
//
//  Created by Milan Zezelj on 6/20/19.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {

    @IBOutlet weak var ResourceLabel: UILabel!
    @IBOutlet weak var AmountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
