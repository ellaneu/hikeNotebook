//
//  AddHikesViewController.swift
//  HikeNotebook
//
//  Created by Ella  Neumarker on 4/1/20.
//  Copyright © 2020 Ella Neumarker. All rights reserved.
//

import UIKit
import os.log

class AddHikesViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var difficultyTextField: UITextField!
    @IBOutlet weak var photoImageview: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var hikeDistanceTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var hikeNameTextField: UITextField!
    
    var hike: Hikes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text Field Delegate
        hikeNameTextField.delegate = self
        
        // Text View Placeholder
        noteTextView.text = "Notes from the hike..."
        noteTextView.textColor = UIColor.lightGray
        noteTextView.font = UIFont(name: "verdana", size: 13.0)
        noteTextView.returnKeyType = .done
        noteTextView.delegate = self
        
        // Assign label to hike name
        if let hike = hike {
            navigationItem.title = hike.hikeName
            hikeNameTextField.text = hike.hikeName
            noteTextView.text = hike.hikeNote
            hikeDistanceTextField.text = hike.hikeDistance
            ratingControl.rating = hike.rating
            photoImageview.image = hike.imageData
            difficultyTextField.text = hike.hikeDifficulty
        }
        
        // Functions
        
        difficultyPicker()
        createToolBar()
        updateSaveButtonState()
        
        // View Design Details
        noteTextView.layer.cornerRadius = 20
        view.photoImageView(imageView: photoImageview)
    }
    
    // MARK: Picker View
    
    let difficulty = ["Easy", "Moderate", "Hard"]
    var selectedDifficulty: String?
    
    func difficultyPicker() {
        
        let difficultyPicker = UIPickerView()
        difficultyPicker.delegate = self
        
        difficultyTextField.inputView = difficultyPicker
    }
    
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(AddHikesViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        difficultyTextField.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    //MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notes from the hike..." {
            textView.text = ""
            textView.textColor = UIColor.darkText
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    func  textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Notes from the hike..."
            textView.textColor = UIColor.darkText
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    


     // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = hikeNameTextField.text ?? ""
        let note = noteTextView.text ?? ""
        let imageData = photoImageview.image
        let distance = hikeDistanceTextField.text ?? ""
        let rating = ratingControl.rating
        let difficulty = difficultyTextField.text ?? ""
        
        hike = Hikes(hikeName: name, hikeNote: note, imageData: imageData, hikeDistance: distance, rating: rating, hikeDifficulty: difficulty)
        
    }
    
    // MARK: Navigation Title Change
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == hikeNameTextField {
            navigationItem.title = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        }
        return true
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        
        guard let selectedImage = info[.originalImage] as?
            UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageview to display the selected image
        photoImageview.image = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: Actions
    
   
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        hikeNameTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    
    private func updateSaveButtonState() {
        let text = hikeNameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

    
}

extension AddHikesViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return difficulty[row]
       }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difficulty.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedDifficulty = difficulty[row]
        difficultyTextField.text = selectedDifficulty
    }
}

