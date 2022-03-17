//
//  setHardcodedAnswerTableViewCell.swift
//  8-Ball
//
//  Created by Tetiana Sierikova on 31.01.2022.
//

import UIKit

class SetHardcodedAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var predictionsTextField: UITextField!
    @IBOutlet weak var enterPrediction: UIButton!
    @IBAction func tapEnterPrediction(_ sender: UIButton) {
        predictionsTextField.endEditing(true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        enterPrediction.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
