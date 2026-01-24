//
//  Logging.swift
//  Renzo
//
//  Created by Marquis Kurt on 22-01-2026.
//

import PlaydateKit

public func RFReportWarning(_ message: String) {
    let dateTime = Date.now
    let formatter = ISO8601DateFormatter()
    let formattedString = formatter.string(from: dateTime)
    System.log("[WARN] (\(formattedString)): \(message)")
}

public func RFReportError(_ message: String) {
    let dateTime = Date.now
    let formatter = ISO8601DateFormatter()
    let formattedString = formatter.string(from: dateTime)
    System.log("[ERR] (\(formattedString)): \(message)")
}

public func RFReportFatalError(_ message: String) {
    let dateTime = Date.now
    let formatter = ISO8601DateFormatter()
    let formattedString = formatter.string(from: dateTime)
    System.error("[FATAL] (\(formattedString)): \(message)")
}
