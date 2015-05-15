//
//  AirportModel.swift
//  NameThatAirport
//
//  Created by Michael Feldman on 5/8/15.
//  Copyright (c) 2015 Michael Feldman. All rights reserved.
//

import UIKit

class AirportModel: NSObject {
   
    var airportNames = ["ATL", "BOS", "BWI", "CLT", "DCA", "DEN", "DFW", "DTW", "EWR", "FLL",
        "HNL", "IAD", "IAH", "JFK", "LAS", "LAX", "LGA", "MCO", "MDW", "MEM",
        "MIA", "MSP", "ORD", "PHL", "PHX", "SAN", "SEA", "SFO", "SLC", "TPA"]
    
    var otherAirports = ["FLG", "LIT", "BUR", "ONT", "COS", "BDL", "MLB", "DAL", "IND", "SDF",
        "MSY", "SHV", "DLH", "OMA", "RNO", "ABQ", "BUF", "SYR", "FAY", "DAY", "OKC", "PDX",
        "PIT", "BNA", "AUS", "HOU"]
    
    func getAirportQuestions() -> [AirportQuestion] {
        
        var generatedQuestions:[AirportQuestion] = [AirportQuestion]()
        
        for index in 0...airportNames.count-1 {
        
            var airportQuestion = AirportQuestion()
            airportQuestion.airportName = airportNames[index]
            
            // randomly pick other two answers
            var (answerTwo, answerThree) = generateWrongAnswers(index)
            airportQuestion.setAnswerArray([airportNames[index], answerTwo, answerThree])
            
            generatedQuestions.append(airportQuestion)
        }
        
        for index in 0...airportNames.count-1 {
            var randomIndex:Int = Int(arc4random_uniform(UInt32(airportNames.count)))
            
            var randomQuestion = generatedQuestions[randomIndex]
            generatedQuestions[randomIndex] = generatedQuestions[index]
            generatedQuestions[index] = randomQuestion
        }
        
        return generatedQuestions
    }
    
    func generateWrongAnswers(index:Int) -> (answerOne:String, answerTwo:String) {
        var tmpAnswerArray = [String]()
        tmpAnswerArray += self.airportNames
        tmpAnswerArray += self.otherAirports
        
        tmpAnswerArray.removeAtIndex(index)
        var randomIndex = Int(arc4random_uniform(UInt32(tmpAnswerArray.count)))
        
        var answer1 = tmpAnswerArray[randomIndex]
        
        tmpAnswerArray.removeAtIndex(randomIndex)
        randomIndex = Int(arc4random_uniform(UInt32(tmpAnswerArray.count)))
        
        var answer2 = tmpAnswerArray[randomIndex]
        
        return (answer1, answer2)
    }
}
