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


class DetailViewController: UIViewController, UITextViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var index: Int!
    var entryArray: [Entry]!
    var isNewEntry = true
    let photoPicker = UIImagePickerController()
    let locationManager = CLLocationManager()
    let locationPin = MKPointAnnotation()
    let geoCoder = CLGeocoder()
    var wantsLocation: Bool = false

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

// setting all the delegate methods
        
        subjectTextField.delegate = self
        photoPicker.delegate = self
        diaryEntry?.delegate = self
        dateFormatter.dateStyle = .long
        dateLabel.text = dateFormatter.string(from: Date())
        locationManager.delegate = self
        mapView.delegate = self
        
        if diaryEntry.text.isEmpty {
            isNewEntry = true
        } else {isNewEntry = false}
        
        loadInfo()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {

// security for core location
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if CLLocationManager.authorizationStatus() == .denied {
            print("no location!")
        } else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

// swoops in camera/camera roll view
    @IBAction func imageClicked(_ sender: Any) {
        imageViewerConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
 // dismisses selection view
    @IBAction func imageCancelButton(_ sender: Any) {
        imageViewerConstraint.constant = 400
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
 // allows user to select a photo
    @IBAction func camerRollButton(_ sender: Any) {
        imageViewerConstraint.constant = 400
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        photoPicker.allowsEditing = false
        photoPicker.sourceType = .photoLibrary
        photoPicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        present(photoPicker, animated: true, completion: nil)
    }
 // allows user to take a photo, and protects against devices that don't have a camera
    
    @IBAction func cameraButton(_ sender: Any) {
        imageViewerConstraint.constant = 400
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        photoPicker.allowsEditing = false
        photoPicker.sourceType = UIImagePickerControllerSourceType.camera
        photoPicker.cameraCaptureMode = .photo
        photoPicker.modalPresentationStyle = .fullScreen
        present(photoPicker, animated: true, completion: nil)
        } else {
            
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
        }
        
    }
  
// adds the location
    
    @IBAction func addLocationButton(_ sender: Any) {
         wantsLocation = true
         addLocation()
        mapView.isHidden = false
        addLocationIcon.isHidden = true
     
        
    }
// all saving functions are in here
    
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
                
                if wantsLocation == true {
            newEntry.locationLat = locationPin.coordinate.latitude
            newEntry.locationLong = locationPin.coordinate.longitude
                }
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
    
    
    
//sets up some UI elements
    
    func loadInfo() {
        

        
        mapView.isHidden = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.cornerRadius = imageView.bounds.height/2
        imageView.clipsToBounds = true
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = UIColor.darkGray.cgColor
        
        guard let index = index, let entryArray = entryArray, let image = UIImage(data: entryArray.reversed()[index].image!) else {
            print("new entry!")
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
            
            
            locationPin.coordinate = CLLocationCoordinate2D(latitude: locationLat, longitude: locationLong)
            let region = MKCoordinateRegion(center: locationPin.coordinate, span: MKCoordinateSpanMake(0.01, 0.01))
            mapView.addAnnotation(locationPin)
            mapView.setRegion(region, animated: true)
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                self.lookUpCurrentLocation(placemarks, error: error)
            }
            
            
            mapView.isHidden = false
            addLocationIcon.isHidden = true
        } else if locationLat == 0.0 && locationLong == 0.0 {
            
            mapView.isHidden = true
            addLocationIcon.isHidden = false
            locationLabel.text = "Add location to entry"
        }
    }
// method to add location as well as calls the geocoder method
    
    func addLocation() {
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .follow
        locationManager.startUpdatingLocation()
        
        let location = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            self.lookUpCurrentLocation(placemarks, error: error)
        }
        
    }
    

// dismisses the keyboard after pressing "return"
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
            
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false 
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        locationManager.stopUpdatingLocation()
        let location = locations.last! as CLLocation
        locationPin.coordinate = location.coordinate
        mapView.addAnnotation(locationPin)
    }
    
 // geocoder method that translates coordinates into city and state
    
    func lookUpCurrentLocation(_ placemarks: [CLPlacemark]?, error: Error?) {
        
        print(placemarks![0])
        
                if error == nil {
                    
                    let firstLocation = placemarks?[0]
                    

                    guard let city = firstLocation?.locality, let state = firstLocation?.administrativeArea else {
                        self.locationLabel.text = "No matching city found"
                        return
                    }
                    
                    self.locationLabel.text = "\(city), \(state)"
   
                    
                } else {
                    self.locationLabel.text = "No matching city found"
                }
        
    }
    
}

//image picker methods

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = chosenImage
            dismiss(animated: true, completion: nil)
        } else {
            
            dismiss(animated: true, completion: nil)
            let alertVC = UIAlertController(
                title: "Photos Only",
                message: "Sorry, only photos can be added to an entry. Please try again!",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
            
           }
     
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
