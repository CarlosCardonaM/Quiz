//
//  QuizModel.swift
//  QuizzU
//
//  Created by Carlos Cardona on 18/05/20.
//  Copyright © 2020 D O G. All rights reserved.
//

import Foundation

protocol QuizProtocol {
    
    func quiestionsRetrieved(_ question:[Question])
}

class QuizModel {
    
    var delegate:QuizProtocol?
    
    func getQuestions() {
        
        // Fetch the questions
        getRemoteJsonFile()
    }
    
    
    func getLocalJsonFile() {
        // Get bundle path to JSON file
        let path = Bundle.main.path(forResource: "QuestionData", ofType: "json")
        
        
        // Double check if the path isn't nil
        guard path != nil  else {
            print("Couldn't find the JSON data file")
            return
        }
        
        // Create URL object from the path
        let url = URL(fileURLWithPath: path!)
        
        do {
            // get the data from the url
            let data = try Data(contentsOf: url)
            
            // try to decode de data into objects
            let decoder = JSONDecoder()
            let array  = try decoder.decode([Question].self, from: data)
            
            // notify the delegate of the parsed objects
            delegate?.quiestionsRetrieved(array)
        }
        catch {
            // Error: couldn't download the data al url
            
        }
        
    }
    
    func getRemoteJsonFile() {
        
        // Get a url object
        let urlString = "https://codewithchris.com/code/QuestionData.json"
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            print("Couldn't create the url object")
            return
        }
        // Get a url session object
        
        let session = URLSession.shared
        
        // Get data task object
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            // check that there wasn't an error
            if error == nil && data != nil {
                
                do {
                    // Create a Json Decoder object
                    let decoder = JSONDecoder()
                        
                    // Parse the Json
                    let array = try decoder.decode([Question].self, from: data!)
                    
                    // Use the main thread to notify the view controller for UI Work
                    DispatchQueue.main.async {
                        // Notify the delegate
                        self.delegate?.quiestionsRetrieved(array)
                    }
                    
                    
                    
                    
                }
                catch {
                    print("Couldn't parse json")
                }
                
                
            
                
                }
            }
            
            
        
        // call resume on the data task
        dataTask.resume()
        
    }
}
