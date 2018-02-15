//
//  MyDiaryTests.swift
//  MyDiaryTests
//
//  Created by Taylor Smith on 2/14/18.
//  Copyright © 2018 Taylor Smith. All rights reserved.
//

import XCTest
import CoreData
import CoreLocation
import MapKit
@testable import MyDiary

class MyDiaryTests: XCTestCase {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entries: [Entry] = []
    var entryArray: [Entry]!
    let subjectText = "test subject line"
    let entryText = "test entry text"
    let photo = #imageLiteral(resourceName: "JournalLogo")
    
    
    override func setUp() {
        super.setUp()
       
        testFetchData()
    }
    
    func testFetchData() {
        do {
            entries = try context.fetch(Entry.fetchRequest())
          
        } catch {
            print("couldn't find yo data yo")
        }
        
        XCTAssertNotNil(entries, "Could not fetch data")
    }
    
    func testCreateEntry() {
        let imageData: Data = UIImageJPEGRepresentation(photo, 1.0)!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newEntry = Entry(context: context)
        newEntry.text = entryText
        newEntry.date = Date()
        newEntry.image = imageData
        newEntry.subject = subjectText
        
        // saves new entry
        appDelegate.saveContext()
        
        XCTAssertNotNil(newEntry, "no data was created!")
     
    }
    
    func testEditExistingEntry() {
        
        let newText = "edited text"
        
        let imageData: Data = UIImageJPEGRepresentation(photo, 1.0)!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       entries.reversed()[0].text = newText
       entries.reversed()[0].subject = subjectText
       entries.reversed()[0].image = imageData
        appDelegate.saveContext()
        
        // tests if the text was indeed updated
        XCTAssert(entries.reversed()[0].text == newText, "Error. Could not update entry" )
        
    }
    
    
    func testDeleteEntry() {
        
            let entryCount = entries.count
            let item = self.entries[0]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.entries.remove(at: 0)
        
        XCTAssert(entries.count < entryCount, "Did not delete")

    }
    
    func testDateStamp() {
        let date = entries.reversed()[0].date
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        let stringDate = formatter.string(from: date!)
        let entry: Entry
        
        
        // I used not equal because it proves that the date stamp was added appropriately to an existing post. If it equated to the current date, it did not time stamp correctly
        
        XCTAssertNotEqual(date, currentDate)
        
        
    }
    
}
