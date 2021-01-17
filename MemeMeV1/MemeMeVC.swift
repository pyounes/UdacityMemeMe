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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Image From Camera
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {

    }
    
    // MARK: - Image From Gallery
    @IBAction func pickImageFromGallery(_ sender: Any) {
        // Create and launch the image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
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

