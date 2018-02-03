//
//  ViewController.swift
//  MyDiary
//
//  Created by Taylor Smith on 1/25/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noEntryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entries: [Entry] = []
    var test: [NSManagedObject] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        ifNoEntries()
        
        dateFormatter.dateStyle = .long
        dateLabel.text = dateFormatter.string(from: Date())
        
    }
    
    func fetchData() {
        do {
            entries = try context.fetch(Entry.fetchRequest())
            print(entries)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("couldn't find yo data yo")
        }
    }
    
    func ifNoEntries() {
        if entries == [] {
            
            noEntryLabel.isHidden = false
            tableView.isHidden = true
        } else {
            
            noEntryLabel.isHidden = true
            tableView.isHidden = false
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
        let indexPath = tableView.indexPathForSelectedRow
        let index = indexPath?.row
        let detailVC = segue.destination as! DetailViewController
        detailVC.index = index
        detailVC.entryArray = entries
        }
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.rowHeight = 100
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiaryCustomCell
        let item = entries.reversed()[indexPath.row].text
        let date = entries.reversed()[indexPath.row].date
        
       
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        let stringDate = formatter.string(from: date!)
        
        
        
        cell.textLabel?.text = item
        cell.dateLabel.text = "Date created: \(stringDate)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            
            let item = self.entries[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.ifNoEntries()
        }
        
         return [delete]
        
    }
    
}

