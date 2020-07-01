//
//  StateManager.swift
//  QuizzU
//
//  Created by Carlos Cardona on 19/05/20.
//  Copyright © 2020 D O G. All rights reserved.
//

import Foundation

class StateManager {
    
    static var numCorrectKey = "NumberCorrectKey"
    static var questionIndexKey = "QuestionIndexKey"
    
    static func saveState(numCorrect: Int, questionIndex: Int) {
        
        // Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        // Save the state data
        defaults.set(numCorrect, forKey: numCorrectKey)
        defaults.set(questionIndex, forKey: questionIndexKey)
        
        
    }
    
    static func retrievedValue(key: String) -> Any? {
        
        // Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        return defaults.value(forKey: key)
    }
    
    static func clearState() {
        
        // Get a reference to user defaults
        let defaults = UserDefaults.standard
        
        // clear the state data in user defaults
        defaults.removeObject(forKey: numCorrectKey)
        defaults.removeObject(forKey: questionIndexKey)
        
    }
}

