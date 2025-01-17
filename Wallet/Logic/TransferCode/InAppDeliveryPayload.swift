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

public class InAppDeliveryPayload: Codable {
    var algorithm: String?
    var publicKey: String?
    var signature: String?
    var signaturePayload: String?
    var code: String?

    public init() {
        algorithm = "EC256"
    }
}

public class InAppDeliveryCertificateBody: Codable {
    var covidCerts: [EncryptedCertificates]
}

public class EncryptedCertificates: Codable {
    var encryptedHcert: String
    var encryptedPdf: String
}

public class DecryptedCertificate {
    var pdf: Data
    var cert: String?

    init(_ cert: Data, _ pdf: Data) {
        self.pdf = pdf
        self.cert = String(data: cert, encoding: .utf8)
    }
}
