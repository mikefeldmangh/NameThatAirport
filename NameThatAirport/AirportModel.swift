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
    
    func getAirportQuestions() -> [AirportQuestion] {
        
        var generatedQuestions:[AirportQuestion] = [AirportQuestion]()
        
        for index in 0...airportNames.count-1 {
        
            var airportQuestion = AirportQuestion()
            airportQuestion.airportName = airportNames[index]
            
            // randomly pick other two answers
            airportQuestion.setAnswerArray([airportNames[index], "222", "333"])
            
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
}
