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
    
    @IBOutlet weak var correctLabel: UILabel!
    
    @IBOutlet weak var resultLabelLandscapeTopMargin: NSLayoutConstraint!
    @IBOutlet weak var resultLabelPortraitTopMargin: NSLayoutConstraint!
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // Timer properties
    let maxTime = 10
    var timer:NSTimer!
    var countdown:Int = 10
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    let model = AirportModel()
    var questions = [AirportQuestion]()
    
    var currentQuestion:AirportQuestion?
    //var answerButtonArray = [AnswerButtonView]()
    
    var numberCorrect:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.startGame()
    }
    
    func startGame() {
        // Hide the dim and result views
        self.dimView.alpha = 0
        self.scoreView.alpha = 0
        
        // Get the questions from the quiz model
        self.questions = self.model.getAirportQuestions()
        
        // Check if there's at least 1 question
        if self.questions.count > 0 {
            currentQuestion = questions[0]
            
            // Load state
            self.loadState()
            
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

            self.resetAllButtonColors()
            
            self.answerButton1.setTitle(actualCurrentQuestion.answers[0], forState: UIControlState.Normal)
            self.answerButton2.setTitle(actualCurrentQuestion.answers[1], forState: UIControlState.Normal)
            self.answerButton3.setTitle(actualCurrentQuestion.answers[2], forState: UIControlState.Normal)
            
            // enable all answer buttons
            self.enableAnswerButtons(true)
            
            self.countdown = self.maxTime
            self.progressBar.setProgress(0.0, animated: false)
            self.timerLabel.text = String(countdown)
            
            // Start the timer
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("timerUpdate"), userInfo: nil, repeats: true)
            
            // Save state
            self.saveState()
        }
    }
    
    func timerUpdate() {
        self.countdown--
        
        // Update the countdown label
        self.timerLabel.text = String(countdown)
        
        self.progressBar.setProgress(calcProgress(countdown), animated:true)
        
        if countdown == 0 {
            
            // Stop the timer
            self.timer.invalidate()
            
            correctLabel.backgroundColor = UIColor.redColor()
            correctLabel.text = "Times Up!"
            
            // find correct answer button
            styleCorrectButton()
            
            self.questionDone()
        }
    }
    
    func calcProgress(time:Int) -> Float {
        return Float(self.maxTime) - Float(time)/Float(self.maxTime)
    }
    
    @IBAction func answerTapped(sender: UIButton) {
    
        // Stop the timer
        self.timer.invalidate()
        
        // disable all answer buttons
        self.enableAnswerButtons(false)
        
        // check if answer is correct
        if isButtonCorrect(sender) {
            // correct!
            correctLabel.backgroundColor = UIColor.greenColor()
            correctLabel.text = "Correct!"
            
            sender.backgroundColor = UIColor.greenColor()
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            numberCorrect++
        } else {
            // wrong!
            correctLabel.backgroundColor = UIColor.redColor()
            correctLabel.text = "Incorrect!"
            
            sender.backgroundColor = UIColor.redColor()
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            // find correct answer button
            styleCorrectButton()
        }
        
        self.questionDone()
    }
    
    func questionDone() {
        self.resultLabelLandscapeTopMargin.constant = 900
        self.resultLabelPortraitTopMargin.constant = 900
        self.view.layoutIfNeeded()
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.resultLabelLandscapeTopMargin.constant = 115
            self.resultLabelPortraitTopMargin.constant = 100
            self.view.layoutIfNeeded()
            
            self.correctLabel.alpha = 1.0
        })
        
        // Go to next airport
        var timer1 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("changeAirport"), userInfo: nil, repeats: false)
        
    }
    
    func styleCorrectButton() {
        if let correctButton = findCorrectAnswerButton() {
            correctButton.backgroundColor = UIColor.greenColor()
            correctButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    func findCorrectAnswerButton() -> UIButton? {
        if isButtonCorrect(self.answerButton1) {
            return self.answerButton1
        }
        if isButtonCorrect(self.answerButton2) {
            return self.answerButton2
        }
        if isButtonCorrect(self.answerButton3) {
            return self.answerButton3
        }
        return nil;
    }
    
    func isButtonCorrect(button:UIButton) -> Bool {
        if button.titleLabel?.text == self.currentQuestion?.airportName {
            return true
        }
        return false
    }
    
    func enableAnswerButtons(enable:Bool) {
        self.answerButton1.enabled = enable;
        self.answerButton2.enabled = enable;
        self.answerButton3.enabled = enable;
    }
    
    func resetAllButtonColors() {
        resetButtonColors(answerButton1)
        resetButtonColors(answerButton2)
        resetButtonColors(answerButton3)
    }
    
    func resetButtonColors(button:UIButton) {
        button.backgroundColor = UIColor.yellowColor()
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
    }
    
    func changeAirport() {
        
        UIView.animateWithDuration(0.5, animations: {
            self.correctLabel.alpha = 0.0
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
                // Erase any saved data
                self.eraseState()
                
                showFinalScore()
            }
        }
    }
    
    func showFinalScore() {
        
        scoreLabel.text = String(format: "%i / %i", self.numberCorrect, self.questions.count)
        
        // Show the dim and result views
        UIView.animateWithDuration(1.0, animations: {
            self.dimView.alpha = 1
            self.scoreView.alpha = 1
        })
    }
    
    @IBAction func restartTapped(sender: UIButton) {
    
        // Reset the score
        self.numberCorrect = 0
        
        self.startGame()
    }
    
    func eraseState() {
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(0, forKey: "numberCorrect")
        userDefaults.setInteger(0, forKey: "questionIndex")
        userDefaults.setObject(nil, forKey: "questions")
        
        userDefaults.synchronize()
    }
    
    func saveState() {
        
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // Save the current score, current question
        userDefaults.setInteger(self.numberCorrect, forKey: "numberCorrect")
        
        // Find the current index of question
        let indexOfCurrentQuestion:Int? = find(self.questions, self.currentQuestion!)
        
        if let actualIndex = indexOfCurrentQuestion {
            userDefaults.setInteger(actualIndex, forKey: "questionIndex")
        }
        
        let questionData = NSKeyedArchiver.archivedDataWithRootObject(self.questions)
        userDefaults.setObject(questionData, forKey: "questions")
        
        // Save the changes
        userDefaults.synchronize()
       
    }
    
    func loadState() {
        
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // Retrieve the list of questions
        let questionData = userDefaults.objectForKey("questions") as? NSData
        
        if let questionData = questionData {
        
            self.questions = NSKeyedUnarchiver.unarchiveObjectWithData(questionData) as! [AirportQuestion]
            
            // Load the saved question into the current question
            let currentQuestionIndex = userDefaults.integerForKey("questionIndex")
        
            if currentQuestionIndex < self.questions.count {
                self.currentQuestion = self.questions[currentQuestionIndex]
            }
            // Load the score
            let score = userDefaults.integerForKey("numberCorrect")
            self.numberCorrect = score
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

