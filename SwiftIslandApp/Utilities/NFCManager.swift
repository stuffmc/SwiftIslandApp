//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

#if !os(visionOS)
import Foundation
import CoreNFC

enum NFCManager {
    static func deviceHasNFCSupport() -> Bool {
        NFCNDEFReaderSession.readingAvailable
    }
}
#endif
