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
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    
    // MARK: Variables
    var memes = [Meme]()
    
    // Set as true when an image is set in the imageView Outlet
    var isImageSelected: Bool = false {
        didSet {
            shareButton.isEnabled = isImageSelected
            cancelButton.isEnabled = isImageSelected
        }
    }
    
    
    // MARK: - App Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        isImageSelected = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check if Camera is available - If Simulator or Device
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
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Action when keyboard is Shown or Hidden
    @objc private func KeyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing { view.frame.origin.y = -getKeyboardHeight(notification) }
    }
    
    // When Hidden
    @objc private func KeyboardWillHide(_ notification: Notification) {
        if bottomTextField.isEditing { view.frame.origin.y = 0 }
    }
    
    
    // Get Keyboard Height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: - Image Picker Loader
    func loadImagePicker(_ type: UIImagePickerController.SourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // MARK: - Hide and Show top and Bottom ToolBar when saving picture
    func hideToolBars(_ flag: Bool = true) {
        self.topToolBar.isHidden = flag
        self.bottomToolBar.isHidden = flag
    }
    
    // MARK: - Image From Camera
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        // Create and launch the image picker from Camera
        loadImagePicker(.camera)
    }
    
    // MARK: - Image From Gallery
    @IBAction func pickImageFromGallery(_ sender: Any) {
        // Create and launch the image picker from the gallery
        loadImagePicker(.photoLibrary)
    }
    
    // MARK: - Share the Meme
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (type, completed, item, error) in
            if completed { self.save(memedImage: memedImage) }
        }
        
        present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        self.imageView.image = nil
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        self.isImageSelected = false
    }
    
    // MARK: - Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            if textField.text == "BOTTOM" { textField.text = "" }
        } else {
            if textField.text == "TOP" { textField.text = "" }
        }

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if textField.text == "" { textField.text = "BOTTOM" }
        } else {
            if textField.text == "" { textField.text = "TOP" }
        }
    }
    
    
    // MARK: - Generate Memed Image from Frame
    private func generateMemedImage() -> UIImage {
        
        hideToolBars()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolBars(false)
        
        return memedImage
    }
    
    // MARK: - Save Memed Image
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!
                        , bottomText: bottomTextField.text!
                        , originalImage: imageView.image!
                        , memedImage: memedImage)
        
        memes.append(meme)
    }

    
}


// MARK: - Extension MemeMeVC ImagePicker Delegate
extension MemeMeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedGalleryImage = info[.originalImage] as? UIImage {
            imageView.image = pickedGalleryImage
            isImageSelected = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

