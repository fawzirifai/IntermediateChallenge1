//
//  ToDoTableViewController.swift
//  IntermediateChallenge1
//
//  Created by Fawzi Rifai on 07/08/2022.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func presentNewItemViewController() {
        if let newItemViewController = storyboard?.instantiateViewController(withIdentifier: "New Item") as? NewItemTableViewController {
            newItemViewController.delegate = self
            present(UINavigationController(rootViewController: newItemViewController), animated: true)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        if let formattedDate = items[indexPath.row].formattedDate {
            cell.detailTextLabel?.text = formattedDate
        } else {
            cell.detailTextLabel?.text = ""
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [items[indexPath.row].identifier.uuidString])
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ToDoTableViewController: NewItemDelegate {
    func addNewItem(_ item: Item) {
        items.append(item)
        tableView.reloadData()
    }
}
