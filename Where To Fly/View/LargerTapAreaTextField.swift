//
//  LargerTapAreaTextField.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import UIKit

class largerTapAreaTextField: UITextField {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
            super.init(frame: frame)
        }

    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    // MARK: - Overrides
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newArea = CGRect(
                    x: self.bounds.origin.x - 5.0,
                    y: self.bounds.origin.y - 5.0,
                    width: self.bounds.size.width + 100.0,
                    height: self.bounds.size.height + 200.0
                )
        return newArea.contains(point)
    }
}
