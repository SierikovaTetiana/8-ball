//
//  setHardcodedAnswerTableViewCell.swift
//  8-Ball
//
//  Created by Tetiana Sierikova on 31.01.2022.
//

import UIKit

class SetHardcodedAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var predictionsLabel: UILabel!
    
    @IBOutlet weak var predictionsTextField: UITextField!
    
    @IBOutlet weak var enterPrediction: UIButton!
    @IBAction func tapEnterPrediction(_ sender: UIButton) {
        predictionsTextField.endEditing(true)
    }

    var ballManager = BallManager()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        enterPrediction.layer.cornerRadius = 5
        predictionsLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

