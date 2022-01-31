//
//  ViewController.swift
//  8-Ball
//
//  Created by Tetiana Sierikova on 30.01.2022.
//

import UIKit
import Network

class ViewController: UIViewController {

    @IBOutlet weak var answerLabel: UILabel!
    
    var ballManager = BallManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ballManager.delegate = self
    }
    
}


// MARK: - BallManagerDelegate

extension ViewController: BallManagerDelegate {
    
    func didUpdateAnswer(_ ballManager: BallManager, ballData: BallModel) {
        DispatchQueue.main.async {
            self.answerLabel.text = ballData.answer
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }


// MARK: - UIResponder

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if Reachability.isConnectedToNetwork() {
                ballManager.performRequest(ballUrl: ballManager.ballURL)
                print("Network is connected")
            } else {
                self.answerLabel.text = ballManager.hardcodedAnswer.randomElement()!
                print("Network is not connected")
            }
        }
        
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.answerLabel.text = "We've been interrupted😱 Please, shake once more for accurate result"
        }
    }

}


