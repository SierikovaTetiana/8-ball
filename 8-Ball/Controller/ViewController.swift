//
//  ViewController.swift
//  8-Ball
//
//  Created by Tetiana Sierikova on 30.01.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var answerLabel: UILabel!
    
    private let ballManager = BallManager.ballInstance
    private let rotatingCirclesView = RotatingActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        becomeFirstResponder()
        ballManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ballManager.hardcodedAnswer = ["Reply hazy, try again later"]
        fetchPredictions()
    }
    
    private func fetchPredictions() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BallModel")
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [Item] {
                for res in result {
                    if let prediction = res.answer {
                        ballManager.hardcodedAnswer.append(prediction)
                    }
                }
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func configureRotatingCircles() {
        view.addSubview(rotatingCirclesView)
        NSLayoutConstraint.activate([
            rotatingCirclesView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rotatingCirclesView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rotatingCirclesView.heightAnchor.constraint(equalToConstant: 100),
            rotatingCirclesView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}


// MARK: - BallManagerDelegate

extension ViewController: BallManagerDelegate {
    
    func didUpdateAnswer(_ ballManager: BallManager, ballData: BallModel) {
        DispatchQueue.main.async {
            self.rotatingCirclesView.removeFromSuperview()
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
            answerLabel.text = ""
            configureRotatingCircles()
            rotatingCirclesView.animate(rotatingCirclesView.planet1, counter: 1)
            rotatingCirclesView.animate(rotatingCirclesView.planet2, counter: 3)
            if Reachability.isConnectedToNetwork() {
                ballManager.performRequest(ballUrl: ballManager.ballURL)
                print("Network is connected")
            } else {
                if let randomPrediction = ballManager.hardcodedAnswer.randomElement() {
                    rotatingCirclesView.removeFromSuperview()
                    answerLabel.text = randomPrediction
                }
                print("Network is not connected")
            }
        }
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            answerLabel.text = "We've been interrupted😱 Please, shake once more for accurate result"
        }
    }
}
