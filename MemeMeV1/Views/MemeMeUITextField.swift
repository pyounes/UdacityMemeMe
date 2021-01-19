//
//  MemeMeUITextField.swift
//  MemeMeV1
//
//  Created by Pierre Younes on 1/19/21.
//

import UIKit

class MemeMeUITextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Setting the default text Attributes
        self.defaultTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  -3.0
        ]
        
        // Setting the text alignment
        self.textAlignment = .center
        
        // Shrink to fit
        self.adjustsFontSizeToFitWidth = true
    }

}
