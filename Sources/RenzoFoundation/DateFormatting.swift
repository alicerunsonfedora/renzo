//
//  DateFormatting.swift
//  Renzo
//
//  Created by Marquis Kurt on 22-01-2026.
//

import PlaydateKit

public typealias Date = System.DateTime

extension Date {
    public init(secondsSinceEpoch epoch: UInt32) {
        self = System.convertEpochToDateTime(epoch)
    }

    /// The current date and time.
    public static var now: Date {
        let currentTime = System.secondsSinceEpoch
        return Date(secondsSinceEpoch: currentTime)
    }
}

/// A formatter used to convert dates into the ISO-8601 date time format.
public class ISO8601DateFormatter {
    /// Whether to include the time in the date string.
    public var includeTime = true

    /// Whether to include the time zone offset in the date string.
    ///
    /// If `includeTime` is false, this value does nothing.
    public var includeTimezoneOffset = true

    public init() {
        // NOTE(marquiskurt): Nothing to initialize here.
    }

    /// Creates a string by formatting a given date time.
    /// - Parameter date: The date to format.
    public func string(from date: Date) -> String {
        let monthString = NSPrependingZero(value: date.month)
        let dayString = NSPrependingZero(value: date.day)

        var dateString = [String(date.year), monthString, dayString].joined(separator: "-")

        if includeTime {
            let hourString = NSPrependingZero(value: date.hour)
            let minuteString = NSPrependingZero(value: date.minute)
            let secondString = NSPrependingZero(value: date.second)

            let timeString = [hourString, minuteString, secondString].joined(separator: ":")
            dateString += "T\(timeString)"
        }

        if includeTime, includeTimezoneOffset {
            let offset = System.timezoneOffset / 3600
            let offsetString = NSPrependingZero(value: offset)
            let signifier = offset >= 0 ? "+" : "-"
            dateString += "\(signifier)\(offsetString):00"
        }
        return dateString
    }
}

// NOTE(marquiskurt): Uuuuuugly! There's gotta be a better way to show these date times.

func NSPrependingZero(value: UInt) -> String {
    var valueString = String(value)
    if value < 10 {
        valueString = "0" + valueString
    }
    return valueString
}

func NSPrependingZero(value: UInt8) -> String {
    var valueString = String(value)
    if value < 10 {
        valueString = "0" + valueString
    }
    return valueString
}

func NSPrependingZero(value: Int) -> String {
    var valueString = String(abs(value))
    if abs(value) < 10 {
        valueString = "0" + valueString
    }
    return valueString
}
