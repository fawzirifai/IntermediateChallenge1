//
//  AddItemTableViewController.swift
//  IntermediateChallenge1
//
//  Created by Fawzi Rifai on 07/08/2022.
//

import UIKit
import CoreData

protocol AddItemDelegate {
    func addItem(_ item: Item)
}

class AddItemTableViewController: UITableViewController {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateSwitch: UISwitch!
    @IBOutlet var datePicker: UIDatePicker!
    var delegate: AddItemDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        dateSwitch.addTarget(self, action: #selector(toggleDate), for: .valueChanged)
    }
    
    @objc func toggleDate() {
        if dateSwitch.isOn {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        }
        tableView.reloadData()
    }
    
    @IBAction func addItem() {
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let item = Item(context: managedContext)
        if let title = titleTextField.text {
            if dateSwitch.isOn {
                item.setValue(title, forKey: #keyPath(Item.title))
                item.setValue(UUID(), forKey: #keyPath(Item.identifier))
                item.setValue(datePicker.date, forKey: #keyPath(Item.date))
                let content = UNMutableNotificationContent()
                content.title = "Intermediate Challenge 1"
                content.body = title
                content.sound = UNNotificationSound.default
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date), repeats: false)
                let request = UNNotificationRequest(identifier: item.identifier?.uuidString ?? "", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            } else {
                item.setValue(title, forKey: #keyPath(Item.title))
            }
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            delegate?.addItem(item)
        }
        dismiss(animated: true)
    }
    
    @IBAction func dismissViewController() {
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if dateSwitch.isOn {
                return 2
            } else {
                return 1
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            titleTextField.becomeFirstResponder()
        }
    }

}

extension AddItemTableViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

