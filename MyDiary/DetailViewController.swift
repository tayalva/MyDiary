//
//  DetailViewController.swift
//  MyDiary
//
//  Created by Taylor Smith on 1/31/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class DetailViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var index: Int!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var diaryEntry: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.cornerRadius = imageView.bounds.height/2
        imageView.clipsToBounds = true
        diaryEntry.layer.borderWidth = 1
        diaryEntry.layer.borderColor = UIColor.darkGray.cgColor
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.darkGray.cgColor
    
        //label.text = "You tapped the cell at index \(index)"
    }

    @IBAction func saveButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        guard let enteredText = diaryEntry?.text else {
            return
        }
        
        if enteredText.isEmpty {
            let alert = UIAlertController(title: "Boring day?", message: "Write something in order to save!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                
                
            })
            
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let entryText = diaryEntry?.text else {
                return
            }
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newEntry = Entry(context: context)
            newEntry.text = entryText
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.navigationController?.popViewController(animated: true)
        
        }
        
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
