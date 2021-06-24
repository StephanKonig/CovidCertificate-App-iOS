//
/*
 * Copyright (c) 2021 Ubique Innovation AG <https://www.ubique.ch>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * SPDX-License-Identifier: MPL-2.0
 */

import Foundation
import UIKit

class PushHandler: UBPushHandler {
    override func showInAppPushDetails(for _: UBPushNotification) {}

    override func showInAppPushAlert(withTitle _: String, proposedMessage _: String, notification _: UBPushNotification) {}

    private var backgroundTask = UIBackgroundTaskIdentifier.invalid

    override func updateLocalData(withSilent isSilent: Bool, remoteNotification _: UBPushNotification, completionHandler: @escaping () -> Void) {
        guard isSilent else {
            completionHandler()
            return
        }

        if backgroundTask == .invalid {
            backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "PushHandler") { [weak self] in
                guard let self = self else {
                    return
                }

                if self.backgroundTask != .invalid {
                    UIApplication.shared.endBackgroundTask(self.backgroundTask)
                    self.backgroundTask = .invalid
                }
            }
        }

        #if DEBUG || RELEASE_DEV
            LocalPush.shared.showDebugNotification(title: "Debug", body: "Silent Push triggered sync at \(Date().description)")
        #endif

        DispatchQueue.global().async {
            TransferManager.updateAllOpenCodes { _ in
                // DispatchQueue.main.async {
                /*
                 if downloadedCertificates.count > 0 {
                     LocalPush.shared.scheduleNotification(identifier: downloadedCertificates.joined())
                 }

                 if CertificateStorage.shared.openTransferCodes.count == 0 {
                     UBPushManager.shared.setActive(false)
                 }

                 completionHandler()
                 */
                if self.backgroundTask != .invalid {
                    UIApplication.shared.endBackgroundTask(self.backgroundTask)
                    self.backgroundTask = .invalid
                }
                // }
            }
        }
    }
}
