//
//  SettingsViewController.swift
//  8-Ball
//
//  Created by Tetiana Sierikova on 30.01.2022.
//
import UIKit
import CoreData

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsTable: UITableView!
    private var predictionsCoreData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.delegate = self
        settingsTable.dataSource = self
        settingsTable.register(UINib(nibName: "setHardcodedAnswerTableViewCell", bundle: nil), forCellReuseIdentifier: "setHardcodedAnswer")
        settingsTable.register(UINib(nibName: "PredictionsTableViewCell", bundle: nil), forCellReuseIdentifier: "predictionCell")
        fetchPredictions()
        hideKeyboardWhenTappedAround() 
    }
    
    // MARK: - Manage data from CoreData
    
    private func savePredictions(predictionToSave: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "BallModel", in: managedContext)!
        let answer = NSManagedObject(entity: entity, insertInto: managedContext)
        answer.setValue(predictionToSave, forKeyPath: "answer")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func fetchPredictions() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BallModel")
        do {
            if let result = try managedContext.fetch(fetchRequest) as? [Item] {
                for res in result {
                    if let prediction = res.answer {
                        predictionsCoreData.append(prediction)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func removePrediction(index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BallModel")
        if let result = try? managedContext.fetch(fetchRequest) as? [Item] {
            managedContext.delete(result[index])
        }
        do {
            try managedContext.save()
            predictionsCoreData.remove(at: index)
            settingsTable.reloadData()
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - TableViewDelegate

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionsCoreData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "setHardcodedAnswer", for: indexPath) as? SetHardcodedAnswerTableViewCell else { return UITableViewCell() }
            cell.predictionsTextField.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "predictionCell", for: indexPath) as? PredictionsTableViewCell else { return UITableViewCell() }
            if !predictionsCoreData.isEmpty {
                cell.predictionLabel.text = " •  \(predictionsCoreData[indexPath.row - 1])"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removePrediction(index: indexPath.row - 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let predictionText = textField.text {
            if predictionText != "" {
                savePredictions(predictionToSave: predictionText)
                predictionsCoreData.append(predictionText)
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

// MARK: - Dismiss keyboard

extension SettingsViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
