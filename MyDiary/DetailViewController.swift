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


class DetailViewController: UIViewController, UITextViewDelegate {
    
    var index: Int!
    var entryArray: [Entry]!
    var isNewEntry = true
  

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var diaryEntry: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
        
        if diaryEntry.text.isEmpty {
            isNewEntry = true
        } else {isNewEntry = false}
        
        diaryEntry?.delegate = self
        dateFormatter.dateStyle = .long
        dateLabel.text = dateFormatter.string(from: Date())

    }

    @IBAction func saveButton(_ sender: Any) {
        guard let enteredText = diaryEntry?.text else {
            return
        }
        
      //  let stringDate = dateFormatter.string(from: Date())
        //let currentDate = dateFormatter.date(from: stringDate)
        
        if enteredText.isEmpty {
            let alert = UIAlertController(title: "Boring day?", message: "Write something in order to save!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let entryText = diaryEntry?.text else {
                return
            }
            
            if isNewEntry == true {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newEntry = Entry(context: context)
            newEntry.text = entryText
            newEntry.date = Date()
                print("this is the date: \(newEntry.date)")
           appDelegate.saveContext()
            
            self.navigationController?.popViewController(animated: true)
                
            } else {
                
                guard let entryText = diaryEntry.text else {
                    return
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                entryArray[index].text = entryText
                appDelegate.saveContext()
                self.navigationController?.popViewController(animated: true)

            }
        }
        
    }
    
    func loadInfo() {
        
    //sets up some UI elements
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.cornerRadius = imageView.bounds.height/2
        imageView.clipsToBounds = true
        diaryEntry.layer.borderWidth = 1
        diaryEntry.layer.borderColor = UIColor.darkGray.cgColor
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.darkGray.cgColor
        
        guard let index = index, let entryArray = entryArray else {
            print("good to go!")
            return
        }
        diaryEntry.text = entryArray[index].text
        
    }
// dismisses the keyboard after pressing "return"
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
            
        }
        return true
    }
    
    

}
