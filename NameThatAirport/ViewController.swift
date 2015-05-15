//
//  ViewController.swift
//  NameThatAirport
//
//  Created by Michael Feldman on 5/3/15.
//  Copyright (c) 2015 Michael Feldman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var airportImageView: UIImageView!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    
    @IBOutlet weak var correctButton: UILabel!
    
    @IBOutlet weak var resultLabelLandscapeTopMargin: NSLayoutConstraint!
    
    @IBOutlet weak var resultLabelPortraitTopMargin: NSLayoutConstraint!
    
    let model = AirportModel()
    var questions = [AirportQuestion]()
    
    var currentQuestion:AirportQuestion?
    //var answerButtonArray = [AnswerButtonView]()
    
    var numberCorrect:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get the questions from the quiz model
        self.questions = self.model.getAirportQuestions()
        
        // Check if there's at least 1 question
        if self.questions.count > 0 {
            currentQuestion = questions[0]
            self.displayCurrentAirport()
        }
    }

    func displayCurrentAirport() {
        
        if let actualCurrentQuestion = self.currentQuestion {
            let filename = actualCurrentQuestion.airportName.lowercaseString
            
            self.airportImageView.image = UIImage(named: filename)
            
            UIView.animateWithDuration(0.25, animations: {
                self.airportImageView.alpha = 1.0
            })

            
            self.answerButton1.setTitle(actualCurrentQuestion.answers[0], forState: UIControlState.Normal)
            self.answerButton2.setTitle(actualCurrentQuestion.answers[1], forState: UIControlState.Normal)
            self.answerButton3.setTitle(actualCurrentQuestion.answers[2], forState: UIControlState.Normal)
        }
    }
    
    
    @IBAction func answerTapped(sender: UIButton) {
    
        // check if answer is correct
        if sender.titleLabel?.text == self.currentQuestion?.airportName {
            // correct!
            correctButton.backgroundColor = UIColor.greenColor()
            correctButton.text = "Correct!"
            numberCorrect++
        } else {
            // wrong!
            correctButton.backgroundColor = UIColor.redColor()
            correctButton.text = "Incorrect!"
        }
        
        self.resultLabelLandscapeTopMargin.constant = 900
        self.resultLabelPortraitTopMargin.constant = 900
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.resultLabelLandscapeTopMargin.constant = 115
            self.resultLabelPortraitTopMargin.constant = 55
            self.view.layoutIfNeeded()
            
            self.correctButton.alpha = 1.0
        })
        
        var timer1 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("changeAirport"), userInfo: nil, repeats: false)
        
        
        // go to next airport
//        changeAirport()
    }
    
    
    func changeAirport() {
        
        UIView.animateWithDuration(0.5, animations: {
            self.correctButton.alpha = 0.0
            self.airportImageView.alpha = 0.0
        })
        
        // Find the current index of question
        let indexOfCurrentQuestion:Int? = find(self.questions, self.currentQuestion!)
        
        // check if it found the current index
        if let actualCurrentIndex = indexOfCurrentQuestion {
            
            // Found the index! Advance the index
            let nextQuestionIndex = actualCurrentIndex + 1
            
            // Check if next question index is beyond capacity of our questions array
            if nextQuestionIndex < self.questions.count {
                // We can display another airport
                self.currentQuestion = self.questions[nextQuestionIndex]
                self.displayCurrentAirport()
            } else {
                // end of game
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

