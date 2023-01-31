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
    
    func formInlineStyle() -> some View {
        self.offset(y: -30)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .offset(y: 30)
            }
    }
    
    @ViewBuilder
    func setCurrentNavigationViewStyle() -> some View {
        if Constants.isPhone {
            self.navigationViewStyle(.stack)
        } else {
            self.navigationViewStyle(.automatic)
        }
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

extension Picker {
    @ViewBuilder
    func currentPickerStyle() -> some View {
        if #available(iOS 16.0, *) {
            self.pickerStyle(.navigationLink)
        } else {
            self.pickerStyle(.inline)
        }
    }
}

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
    
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
}
