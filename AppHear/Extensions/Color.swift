//
//  Color.swift
//  AppHear
//
//  Created by Ganesh Ekatata Buana on 13/10/22.
//

import Foundation
import SwiftUI

extension CGColor {
    public static var screenColor: CGColor {
        return CGColor(red: 253.0/255.0, green: 250.0/255.0 , blue: 250.0/255.0, alpha: 1.0)
    }
    public static var buttonBorder: CGColor {
        return CGColor(red: 217.0/255.0, green: 217.0/255.0 , blue: 217.0/255.0, alpha: 0.5)
    }
    public static var buttonShadow: CGColor {
        return CGColor(red: 180.0/255.0, green: 180.0/255.0 , blue: 180.0/255.0, alpha: 0.8)
    }
    public static var appHearBlue: CGColor {
        return CGColor(red: 66.0/255.0, green: 84.0/255.0 , blue: 182.0/255.0, alpha: 1.0)
    }
    public static var gradient1: CGColor {
        return CGColor(red: 72.0/255.0, green: 86.0/255.0 , blue: 177.0/255.0, alpha: 1.0)
    }
    public static var gradient2: CGColor {
        return CGColor(red: 124.0/255.0, green: 137.0/255.0 , blue: 226.0/255.0, alpha: 1.0)
    }
    public static var appHearOrange: CGColor {
        return CGColor(red: 255.0/255.0, green: 176.0/255.0 , blue: 61.0/255.0, alpha: 1.0)
    }
}
