//
//  ViewController.swift
//  MyDiary
//
//  Created by Taylor Smith on 1/25/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    
    var testArray = ["Taylor", "Michelle", "Finley"]
    //var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.rowHeight = 100
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiaryCustomCell
        let item = testArray[indexPath.row]
        
        cell.textLabel?.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //  index = indexPath.row
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
             let indexPath = tableView.indexPathForSelectedRow
             let index = indexPath?.row
             let detailVC = segue.destination as! DetailViewController
             detailVC.index = index
            
       
    }
    
    
}

