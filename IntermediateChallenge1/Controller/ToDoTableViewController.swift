//
//  ToDoTableViewController.swift
//  IntermediateChallenge1
//
//  Created by Fawzi Rifai on 07/08/2022.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let managedContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        let fetchRequest = Item.fetchRequest()
        do {
            items = try managedContext.fetch(fetchRequest)
        } catch {}
    }
    
    @IBAction func presentAddItemViewController() {
        if let newItemViewController = storyboard?.instantiateViewController(withIdentifier: "Add Item") as? AddItemTableViewController {
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
        let item = items[indexPath.row]
        cell.textLabel?.text = item.value(forKey: #keyPath(Item.title)) as? String
        if let date = item.value(forKey: #keyPath(Item.date)) as? Date {
            cell.detailTextLabel?.text = date.formatted()
        } else {
            cell.detailTextLabel?.text = ""
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.delete(items[indexPath.row])
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [items[indexPath.row].identifier?.uuidString ?? ""])
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension ToDoTableViewController: AddItemDelegate {
    func addItem(_ item: Item) {
        items.append(item)
        tableView.reloadData()
    }
}
