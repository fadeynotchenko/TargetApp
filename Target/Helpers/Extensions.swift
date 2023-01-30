//
//  Extensions.swift
//  Target
//
//  Created by Fadey Notchenko on 29.01.2023.
//

import Foundation
import SwiftUI

extension View {
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(OnFirstAppear(perform: perform))
    }
}

extension UIColor {
    class func color(withData data: Data) -> UIColor {
         NSKeyedUnarchiver.unarchiveObject(with: data) as! UIColor
    }

    func encode() -> Data {
         NSKeyedArchiver.archivedData(withRootObject: self)
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
