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
import CoreLocation


class DetailViewController: UIViewController, UITextViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var index: Int!
    var entryArray: [Entry]!
    var isNewEntry = true
    let photoPicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    let locationPin = MKPointAnnotation()
    let geoCoder = CLGeocoder()
    
    
 
    @IBOutlet weak var addLocationIcon: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var diaryEntry: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var imageViewerConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
        
        if diaryEntry.text.isEmpty {
            isNewEntry = true
        } else {isNewEntry = false}
        
        photoPicker.delegate = self
        diaryEntry?.delegate = self
        dateFormatter.dateStyle = .long
        dateLabel.text = dateFormatter.string(from: Date())
        
        
        locationManager.delegate = self
        addLocation()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if CLLocationManager.authorizationStatus() == .denied {
            print("no location!")
        } else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction func imageClicked(_ sender: Any) {
        imageViewerConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func imageCancelButton(_ sender: Any) {
        imageViewerConstraint.constant = 400
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func camerRollButton(_ sender: Any) {
        imageViewerConstraint.constant = 400
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        photoPicker.allowsEditing = false
        photoPicker.sourceType = .photoLibrary
        photoPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(photoPicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        imageViewerConstraint.constant = 400
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        photoPicker.allowsEditing = false
        photoPicker.sourceType = UIImagePickerControllerSourceType.camera
        photoPicker.cameraCaptureMode = .photo
        photoPicker.modalPresentationStyle = .fullScreen
        present(photoPicker, animated: true, completion: nil)
        
        
    }
    
    @IBAction func addLocationButton(_ sender: Any) {

         addLocation()
        
        let location = CLLocation(latitude: locationPin.coordinate.latitude, longitude: locationPin.coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.lookUpCurrentLocation(placemarks, error: error)
        }
        mapView.isHidden = false
        addLocationIcon.isHidden = true
     
        
    }
    
    @IBAction func saveButton(_ sender: Any) {

        guard let enteredText = diaryEntry?.text, let subjectText = subjectTextField?.text else {
            return
        }

        if enteredText.isEmpty || subjectText.isEmpty {
            let alert = UIAlertController(title: "Boring day?", message: "Write something in order to save!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let entryText = diaryEntry?.text, let subjectText = subjectTextField?.text, let photo = imageView.image else {
                return
            }
            
            
            let imageData: Data = UIImageJPEGRepresentation(photo, 1.0)!
            
            if isNewEntry == true {
    
           
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let newEntry = Entry(context: context)
            newEntry.text = entryText
            newEntry.date = Date()
            newEntry.image = imageData
            newEntry.subject = subjectText
            newEntry.locationLat = locationPin.coordinate.latitude
            newEntry.locationLong = locationPin.coordinate.longitude
           appDelegate.saveContext()
            
            self.navigationController?.popViewController(animated: true)
                
            } else {
                
                guard let entryText = diaryEntry.text, let subjectText = subjectTextField?.text else {
                    return
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                entryArray.reversed()[index].text = entryText
                entryArray.reversed()[index].subject = subjectText
                entryArray.reversed()[index].image = imageData
                entryArray.reversed()[index].locationLat = locationPin.coordinate.latitude
                entryArray.reversed()[index].locationLong = locationPin.coordinate.longitude
                appDelegate.saveContext()
                self.navigationController?.popViewController(animated: true)

            }
        }
        
    }
    
    func loadInfo() {
        
    //sets up some UI elements
        mapView.isHidden = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.cornerRadius = imageView.bounds.height/2
        imageView.clipsToBounds = true
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.darkGray.cgColor
        
        guard let index = index, let entryArray = entryArray, let image = UIImage(data: entryArray.reversed()[index].image!) else {
            print("good to go!")
            return
        }
        
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
       
        diaryEntry.text = entryArray.reversed()[index].text
        subjectTextField.text = entryArray.reversed()[index].subject
        let locationLat = entryArray.reversed()[index].locationLat
        let locationLong = entryArray.reversed()[index].locationLong
        if locationLat != 0.0 && locationLong != 0.0 {
            
            print("I have a stored location!")
            
            
            let location = CLLocation(latitude: locationLat, longitude: locationLong)
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                self.lookUpCurrentLocation(placemarks, error: error)
            }
            mapView.isHidden = false
            addLocationIcon.isHidden = true
        }
    }
    
    func addLocation() {
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .follow
        locationManager.startUpdatingLocation()
        
    }
    

// dismisses the keyboard after pressing "return"
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
            
        }
        return true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        locationPin.coordinate = location.coordinate
        mapView.addAnnotation(locationPin)
    }
    
    func lookUpCurrentLocation(_ placemarks: [CLPlacemark]?, error: Error?) {
        
    
                if error == nil {
                    let firstLocation = placemarks?[0]
                    let city = firstLocation?.locality
                    let state = firstLocation?.administrativeArea
                    self.locationLabel.text = "\(city!), \(state!)"
   
                    
                } else {
                    self.locationLabel.text = "No matching city found"
                }
        
    }
    
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
