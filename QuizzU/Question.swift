//
//  Question.swift
//  QuizzU
//
//  Created by Carlos Cardona on 18/05/20.
//  Copyright © 2020 D O G. All rights reserved.
//

import Foundation

struct Question: Codable {
    
    var question:String?
    var answers:[String]?
    var correctAnswerIndex:Int?
    var feedback:String?
    
    
}
