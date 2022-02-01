//
//  BallManager.swift
//  8-Ball
//
//  Created by Tetiana Sierikova on 30.01.2022.
//

import Foundation

protocol BallManagerDelegate {
    func didUpdateAnswer(_ ballManager: BallManager, ballData: BallModel)
    func didFailWithError(error: Error)
    
}

class BallManager {
    
    let ballURL = "https://8ball.delegator.com/magic/JSON/what"
    var hardcodedAnswer = [String]()
    
    init(hardcodedAnswer: [String]) {
        self.hardcodedAnswer = hardcodedAnswer
      }
    
    var delegate: BallManagerDelegate?
    
    func performRequest(ballUrl: String) {
        if let urlBallURL = URL(string: ballUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlBallURL) { data, response, error in
                if error != nil {
                    print("Error in BallManager performRequest", error!)
                    self.delegate?.didUpdateAnswer(self, ballData: BallModel(answer: self.hardcodedAnswer.randomElement()!))
                    return
                }
                
                if let safeData = data {
                    if let answer = self.parseJson(safeData) {
                        self.delegate?.didUpdateAnswer(self, ballData: answer)
                    }
                }
                
            }
            task.resume()
        }
        
    }
    
    func parseJson(_ ballData: Data) -> BallModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BallData.self, from: ballData)
            let answer = BallModel(answer: decodedData.magic.answer)
            return answer
        } catch {
            print("Error in BallManager parseJson", error)
            let hardAnswer = BallModel(answer: hardcodedAnswer.randomElement()!)
            return hardAnswer
        }
        
    }
}

var ballInstance = BallManager(hardcodedAnswer: ["Reply hazy, try again later"])
