//
//  AudioFiles.swift
//  AppHear
//
//  Created by Ganesh Ekatata Buana on 08/11/22.
//

import CloudKit
import UIKit

class AudioFiles: NSObject {
    var recordID: CKRecord.ID!
    var transcript: String!
    var audio: URL!
}
