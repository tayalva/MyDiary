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
    let searchController = UISearchController(searchResultsController: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entries: [Entry] = []
    var filteredEntries = [Entry]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        ifNoEntries()
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableViewAutomaticDimension
        dateFormatter.dateStyle = .long
        dateLabel.text = dateFormatter.string(from: Date())
      
    }
    
  
// fetches data to populate the table view
    
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
    
// segue that passes on appropriate info to the detail controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
        let indexPath = tableView.indexPathForSelectedRow
        let index = indexPath?.row
        let detailVC = segue.destination as! DetailViewController
        detailVC.index = index
            if isFiltering() {
                
                detailVC.entryArray = filteredEntries
            } else {
                
                detailVC.entryArray = entries
            }
            
        }
    }


}

//all my tableView methods are here

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return filteredEntries.count
        }
        return entries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiaryCustomCell
        let date = entries.reversed()[indexPath.row].date

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        let stringDate = formatter.string(from: date!)
        let entry: Entry
        if isFiltering() {
            entry = filteredEntries.reversed()[indexPath.row]
        } else {
            entry = entries.reversed()[indexPath.row]
        }
        
        
        cell.cellImage.contentMode = .scaleAspectFill
        cell.entryLabel?.text = entry.subject
        cell.cellImage.image = UIImage(data: entry.image!)
        cell.dateLabel.text = "Date created: \(stringDate)"
        return cell
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
// sets up the search bar
    
    func setUpSearchBar() {
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Entries"
        searchController.searchBar.searchBarStyle = .minimal
        tableView.tableHeaderView = searchController.searchBar
        
        self.definesPresentationContext = true
    }
    
}

// updates the table view as you type and filters results

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarIsEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredEntries = entries.filter({( entry : Entry ) -> Bool in
          
            return entry.subject!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

