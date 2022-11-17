//
//  View.swift
//  AppHear
//
//  Created by Piter Wongso on 17/11/22.
//

import Foundation
import SwiftUI

extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}
