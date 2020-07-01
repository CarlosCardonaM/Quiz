//
//  ViewController.swift
//  QuizzU
//
//  Created by Carlos Cardona on 18/05/20.
//  Copyright © 2020 D O G. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizProtocol, UITableViewDelegate, UITableViewDataSource, ResultViewControllerProtocol {
    
    
    // MARK: IBOutlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rootStackView: UIStackView!
    
    var model = QuizModel()
    var questions = [Question]()
    var currenQuestionIndex = 0
    var numCorrect = 0
    
    var resultDialog:ResultViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set self as the delegate and datasource for the tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set up the model
        model.delegate = self
        model.getQuestions()
    }
    
    func slideInQuestion() {
        
        // Set the initial state
        stackViewTrailingConstraint.constant = -1000
        stackViewLeadingConstraint.constant = +1000
        rootStackView.alpha = 0
        view.layoutIfNeeded()
        // Animate it to the end state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.stackViewLeadingConstraint.constant = 0
            self.stackViewTrailingConstraint.constant = 0
            self.rootStackView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func slideOutQuestion() {
        
        // Set the initial state
        stackViewTrailingConstraint.constant = 0
        stackViewLeadingConstraint.constant = 0
        rootStackView.alpha = 1
        view.layoutIfNeeded()
        // Animate it to the end state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            self.stackViewLeadingConstraint.constant = -1000
            self.stackViewTrailingConstraint.constant = 1000
            self.rootStackView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func displayQuestion() {
        
        // check if there are questions and check that the currentQuestionndex is not out of bounds
        guard questions.count > 0 && currenQuestionIndex < questions.count else {
            return
        }
        
        // Display the question text
        questionLabel.text = questions[currenQuestionIndex].question
        
        // Reload the answers table
        tableView.reloadData()
        
        // Animate the question in
        slideInQuestion()
        
        // Initialize the result dialog
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
        resultDialog?.modalPresentationStyle = .overCurrentContext
        resultDialog?.delegate = self
        
    }
    
    
    // MARK: Quiz Protocol Methods
    
    func quiestionsRetrieved(_ questions: [Question]) {
        
        // Get a reference for the questions
        self.questions = questions
        
        // check if we should restore the state, before showing question #1
        let savedIndex = StateManager.retrievedValue(key: StateManager.questionIndexKey) as? Int
        
        if savedIndex != nil && savedIndex! < self.questions.count {
            
            // Set the current question to saved index
            currenQuestionIndex = savedIndex!
            
            //Retrieve the number correct from storage
            let savedNumCorrect = StateManager.retrievedValue(key: StateManager.numCorrectKey) as? Int
            
            if savedNumCorrect != nil {
                numCorrect = savedNumCorrect!
            }
        }
        
        // Display the first question
        displayQuestion()
        
        
    }

    // MARK: UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // make sure that the questions array actually contains at least a question
        guard questions.count > 0 else {
            return 0
        }
        
        // return the number of answers for this question
        let currentQuestion = questions[currenQuestionIndex]
        
        if currentQuestion.answers != nil {
            return currentQuestion.answers!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        // Customize it
        let label = cell.viewWithTag(1) as? UILabel
        
        if label != nil {
            
            let question = questions[currenQuestionIndex]
            
            if question.answers != nil && indexPath.row < question.answers!.count{
                
                // TODO: Set the answer tex for the label
                label!.text = question.answers![indexPath.row]
            }
            
        }
        
        // Return the cell
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var titleText = ""
        
        // User has tapped on a row, check if it's the right answer
        let question = questions[currenQuestionIndex]
        
        if question.correctAnswerIndex! == indexPath.row {
            
            // User got it right
            titleText = "Correct!"
            numCorrect += 1
        }
        else {
            
            // User got it wrong
            titleText = "Incorrect"
            
        }
        // Slide out the question
        DispatchQueue.main.async {
            self.slideOutQuestion()
        }
        
        // show the popup
        if resultDialog != nil {
            
            // Customize the dialog 
            resultDialog!.titleText = titleText
            resultDialog!.feedbackText = question.feedback!
            resultDialog!.buttonText = "Next"
            
            DispatchQueue.main.async {
                self.present(self.resultDialog!, animated: true, completion: nil)

            }
            
        }
        
    }
    
    // MARK: ResultViewControllerProtocol Methods
    
    func dialogDismissed() {
        
        // Increment the currenQuestionIndex
        currenQuestionIndex += 1
        
        if currenQuestionIndex == questions.count {
            
            // the user has answered all the questions
            // Show the summary dialog
            if resultDialog != nil {
                
                // Customize the dialog
                resultDialog!.titleText = "Summary"
                resultDialog!.feedbackText = "You got \(numCorrect) correct out of \(questions.count) questions"
                resultDialog!.buttonText = "Restart"
                
                present(resultDialog!, animated: true, completion: nil)
                
                StateManager.clearState()
            }
            
        } else if currenQuestionIndex > questions.count {
            // Restart
            numCorrect = 0
            currenQuestionIndex = 0
            
            // Display and animate in the question
            displayQuestion()
        }
        else if currenQuestionIndex < questions.count {
            // we have more questions to show
            
            // Diplay the next question
            displayQuestion()
            
            // Save state
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currenQuestionIndex)
        }
        
    }
}

