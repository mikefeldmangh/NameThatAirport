//
//  AnswerButtonView.swift
//  NameThatAirport
//
//  Created by Michael Feldman on 5/9/15.
//  Copyright (c) 2015 Michael Feldman. All rights reserved.
//

import UIKit

class AnswerButtonView: UIView {

    let answerLabel:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set background and alpha
        self.backgroundColor = UIColor.darkGrayColor()
        self.alpha = 0.5
        
        // Add the label to the view
        self.addSubview(self.answerLabel)
        self.answerLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setAnswerText(text:String) {
        self.answerLabel.text = text
        
        // Set properties for the label and constraints
        self.answerLabel.numberOfLines = 1
        self.answerLabel.textColor = UIColor.whiteColor()
        self.answerLabel.textAlignment = NSTextAlignment.Center
        self.answerLabel.adjustsFontSizeToFitWidth = true
        
        // Set constraints
        
    }
    
}
