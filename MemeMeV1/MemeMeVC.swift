//
//  MemeMeVC.swift
//  MemeMeV1
//
//  Created by Pierre Younes on 1/4/21.
//

import UIKit

class MemeMeVC: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    // MARK: - Variables
    var isBottomTextField: Bool = false
    
    private let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  3.0
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        bottomTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Subscribe to Keyboard Event
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from Keyboard notification
        unsubscribeToKeyboardNotification()
    }
    
    // MARK: - Subscribing to notification
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UnSubscribe from notifications
    func unsubscribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Action when keyboard is Shown or Hidden
    @objc private func KeyboardWillShow(_ notification: Notification) {
        if isBottomTextField { view.frame.origin.y = -getKeyboardHeight(notification) }
    }
    
    // When Hidden
    @objc private func KeyboardWillHide(_ notification: Notification) {
        if isBottomTextField { view.frame.origin.y = 0 }
    }
    
    
    // get Keyboard Height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: - Picker Loader
    func loadPicker(_ type: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
        
    }
    // MARK: - Image From Camera
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        // Create and launch the image picker from Camera
        loadPicker(.camera)
    }
    
    // MARK: - Image From Gallery
    @IBAction func pickImageFromGallery(_ sender: Any) {
        // Create and launch the image picker from the gallery
        loadPicker(.photoLibrary)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        isBottomTextField = textField.tag == 1 ? true : false
        return true
    }
    
}



extension MemeMeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedGalleryImage = info[.originalImage] as? UIImage {
            imageView.image = pickedGalleryImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

