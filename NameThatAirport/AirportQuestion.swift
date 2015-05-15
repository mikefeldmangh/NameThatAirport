//
//  AirportQuestion.swift
//  NameThatAirport
//
//  Created by Michael Feldman on 5/8/15.
//  Copyright (c) 2015 Michael Feldman. All rights reserved.
//

import UIKit

class AirportQuestion: NSObject {
   
    var airportName = ""
    var answers:[String] = [String]()
    
    func setAnswerArray(answers:[String]) {
        self.answers = sorted(answers, doesFirstComeBeforeSecond)
//        self.answers.sort(doesFirstComeBeforeSecond($0, $1))
    }
    
    func doesFirstComeBeforeSecond(arg1:String, arg2:String) -> Bool {
        // orders strings based on substrings starting at second character. Should be random enough.
        let string1 = arg1.substringFromIndex(advance(arg1.startIndex, 1))
        let string2 = arg2.substringFromIndex(advance(arg2.startIndex, 1))
        return string1 < string2
    }
}
