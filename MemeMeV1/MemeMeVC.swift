//
//  MemeMeVC.swift
//  MemeMeV1
//
//  Created by Pierre Younes on 1/4/21.
//

import UIKit

class MemeMeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
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
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    // When Hidden
    @objc private func KeyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    
    // get Keyboard Height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    // MARK: - Image From Camera
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        // Create and launch the image picker from Camera
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - Image From Gallery
    @IBAction func pickImageFromGallery(_ sender: Any) {
        // Create and launch the image picker from the gallery
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
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

