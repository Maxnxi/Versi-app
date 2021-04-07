//
//  RoundedBorderTxtField.swift
//  versi-app
//
//  Created by Maksim on 06.04.2021.
//

import UIKit

class RoundedBorderTxtField: UITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)])
        attributedPlaceholder = placeholder
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.cornerRadius = frame.height / 2
        layer.borderColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
        layer.borderWidth = 3
            
        
        
    }

}
