//
//  TextField.swift
//  Tracker
//
//  Created by Marina Kolbina on 02/04/2023.
//

import Foundation

import UIKit

class TextField: UITextField {
    let dx: CGFloat = 16
    let dy: CGFloat = 27

    // placeholder position
    override func textRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.dx , dy: self.dy)
    }

    // text position
    override func editingRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.dx , dy: self.dy)
    }

    override func placeholderRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: self.dx, dy: self.dy)
    }
}
