//
//  SettingsViewController.swift
//  8-Ball
//
//  Created by Tetiana Sierikova on 30.01.2022.
//
import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsTable: UITableView!
    
//    let ballManager = BallManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.delegate = self
        settingsTable.dataSource = self
        settingsTable.register(UINib(nibName: "setHardcodedAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "setHardcodedAnswer")
    }
    
    
}


// MARK: - TableViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setHardcodedAnswer", for: indexPath) as! SetHardcodedAnswerTableViewCell
        cell.predictionsTextField.delegate = self
        
//        cell.predictionsLabel.text = ballManager.hardcodedAnswer.compactMap({ return " •  " + $0 }).joined(separator: "\n")
        cell.predictionsLabel.text = ballInstance.hardcodedAnswer.compactMap({ return " •  " + $0 }).joined(separator: "\n")
        
        return cell
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let predictionText = textField.text {
            if predictionText != "" {
//                ballManager.hardcodedAnswer.append(predictionText)
                ballInstance.hardcodedAnswer.append(predictionText)
                settingsTable.reloadData()
            } else {
                textField.placeholder = "Enter some text"
            }
        }
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
}

