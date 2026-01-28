import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {

        NSLog("🟢 [NSE] didReceive CALLED")

        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard let bestAttemptContent = bestAttemptContent else {
            NSLog("🔴 [NSE] bestAttemptContent is NIL")
            contentHandler(request.content)
            return
        }

        // PROOF EXTENSION RAN
        bestAttemptContent.title = "🟢 IMAGE EXTENSION ACTIVE"

        // Dump entire payload
        NSLog("🟢 [NSE] userInfo = \(request.content.userInfo)")

        // 🔑 VERY IMPORTANT: check ALL possible image locations
        var imageUrlString: String?

        // 1️⃣ data.image (Flutter / FCM data)
        if let img = request.content.userInfo["image"] as? String {
            imageUrlString = img
            NSLog("🟢 [NSE] Found image in userInfo[image]")
        }

        // 2️⃣ fcm_options.image (APNS)
        if imageUrlString == nil,
           let fcm = request.content.userInfo["fcm_options"] as? [String: Any],
           let img = fcm["image"] as? String {
            imageUrlString = img
            NSLog("🟢 [NSE] Found image in fcm_options.image")
        }

        // 3️⃣ aps mutable payload (rare but safe)
        if imageUrlString == nil,
           let aps = request.content.userInfo["aps"] as? [String: Any],
           let img = aps["image"] as? String {
            imageUrlString = img
            NSLog("🟢 [NSE] Found image in aps.image")
        }

        guard let imageUrl = imageUrlString,
              let url = URL(string: imageUrl) else {

            NSLog("🔴 [NSE] NO IMAGE URL FOUND")
            contentHandler(bestAttemptContent)
            return
        }

        NSLog("🟢 [NSE] Image URL = \(url.absoluteString)")

        // Download image
        let task = URLSession.shared.downloadTask(with: url) { location, response, error in

            if let error = error {
                NSLog("🔴 [NSE] Download error: \(error.localizedDescription)")
                contentHandler(bestAttemptContent)
                return
            }

            guard let location = location else {
                NSLog("🔴 [NSE] Download location NIL")
                contentHandler(bestAttemptContent)
                return
            }

            NSLog("🟢 [NSE] Image downloaded to \(location.path)")

            let fileManager = FileManager.default
            let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
            let tempFile = tempDir.appendingPathComponent(url.lastPathComponent)

            do {
                if fileManager.fileExists(atPath: tempFile.path) {
                    try fileManager.removeItem(at: tempFile)
                }

                try fileManager.moveItem(at: location, to: tempFile)

                let attachment = try UNNotificationAttachment(
                    identifier: "image",
                    url: tempFile,
                    options: nil
                )

                bestAttemptContent.attachments = [attachment]

                NSLog("🟢 [NSE] Attachment added successfully")

            } catch {
                NSLog("🔴 [NSE] Attachment error: \(error.localizedDescription)")
            }

            contentHandler(bestAttemptContent)
        }

        task.resume()
    }

    override func serviceExtensionTimeWillExpire() {
        NSLog("⏰ [NSE] Time will expire")
        if let contentHandler = contentHandler,
           let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}