//
//  CommentTextView.swift
//  Wallet
//
//  Created by Milan Zezelj on 31/10/2019.
//  Copyright © 2019 Milan Zezelj. All rights reserved.
//

import UIKit

class CommentTextView: UITextView {
    
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 0.2
        self.clipsToBounds = true;
        self.layer.cornerRadius = 5.0;
        if self.traitCollection.userInterfaceStyle == .dark
        {
             self.layer.borderColor = UIColor.darkGray.cgColor
        }
        else
        {
             self.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

}
