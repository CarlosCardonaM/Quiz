
//
//  ResultViewController.swift
//  QuizzU
//
//  Created by Carlos Cardona on 19/05/20.
//  Copyright © 2020 D O G. All rights reserved.
//

import UIKit
protocol ResultViewControllerProtocol {
    func dialogDismissed()
}

class ResultViewController: UIViewController {
    
    
    
    // MARK: @IBOutlets
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    var delegate:ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round the dialog box corners
        dialogView.layer.cornerRadius = 50
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Now that the elements have loaded, set the text
        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)
        
        // Hide the UI elemts
        dimView.alpha = 0
        titleLabel.alpha = 0
        feedbackLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Fade in the dim elements
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            
            self.dimView.alpha = 1
            self.titleLabel.alpha = 1
            self.feedbackLabel.alpha = 1
            
        }, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        // fade out the dim view and then dismiss the popup
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            
            self.dimView.alpha = 0
        }) { (completed) in
            // Dismiss the popup
            self.dismiss(animated: true, completion: nil)
                    
            // Notify to delegate that popup was dismissed
            self.delegate?.dialogDismissed()
        }
    }
        
        
}
