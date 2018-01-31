//
//  DetailViewController.swift
//  MyDiary
//
//  Created by Taylor Smith on 1/31/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var index: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "You tapped the cell at index \(index)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
