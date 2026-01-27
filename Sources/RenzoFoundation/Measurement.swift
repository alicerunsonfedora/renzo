//
//  Measurement.swift
//  Renzo
//
//  Created by Marquis Kurt on 24-01-2026.
//

import PlaydateKit

/// An object used to measure an amount of work.
///
/// The Measurement object is generally used to manually profile a given amount of work. Results can be displayed in
/// either seconds or milliseconds.
/// ```swift
/// var someWorkTime = Measurement("Performing some work", in: .milliseconds)
/// defer { someWorkTime.record() }
/// ...
/// ```
/// ## Accumulating time
/// Measurement can work under two modes: a single scoped iteration, and multiple iterations with accumulated time.
/// To show an accumulated time over a certain amount of runs, use ``checkpoint()``:
/// ```swift
/// var someWorkTime = Measurement("Performing some work", in: .milliseconds)
/// for _ in 1...99 {
///    someWorkTime.reset()
///    doSomeHeavyWork()
///    someWorkTime.checkpoint()
/// }
/// someWorkTime.record()
/// ```
public class Measurement {
    public enum DurationPrecision {
        case seconds, milliseconds

        var suffix: String {
            switch self {
            case .seconds: "s"
            case .milliseconds: "ms"
            }
        }

        var multiplier: Float {
            switch self {
            case .seconds: 1
            case .milliseconds: 1000
            }
        }
    }

    public enum OutputFormat {
        case prettyPrinted, tsv
    }

    var absoluteTimeStarted: Float
    var description: String
    var outputFormat: OutputFormat
    let precision: DurationPrecision
    var timeStarted: Float

    /// The number of checkpoints recorded in the current measurement.
    public internal(set) var checkpoints: Int = 0

    /// The current accumulated time for all checkpointed runs.
    public internal(set) var accumulatedTime: Float = 0

    /// Create a measurement tracker for a specified work item.
    /// - Parameter comment: A comment describing the work being measured.
    /// - Parameter precision: The precision of time to display in the results.
    /// - Parameter outputFormat: The format for the output when recorded.
    public init(
        _ comment: String,
        in precision: DurationPrecision = .seconds,
        outputFormat: OutputFormat = .prettyPrinted
    ) {
        absoluteTimeStarted = System.elapsedTime
        timeStarted = System.elapsedTime
        description = comment
        self.precision = precision
        self.outputFormat = outputFormat
    }

    /// Record the results of the measurement to the console.
    /// - Parameter averageTime: Whether to display the time as an average over the checkpoints instead of an
    ///   accumulation.
    public func record(displayTimesAsAverages averageTime: Bool = false) {
        if checkpoints > 0 {
            reportCheckpoints(averageTime: averageTime)
            return
        }

        let elapsedTime = abs(System.elapsedTime - absoluteTimeStarted)
        let readableOutput = elapsedTime * precision.multiplier
        let suffix = precision.suffix
        reportToConsole(time: readableOutput, suffix: suffix)
    }

    /// Create a checkpoint at the current point in time.
    public func checkpoint() {
        let elapsedTime = System.elapsedTime - timeStarted
        accumulatedTime += elapsedTime
        checkpoints += 1
    }

    /// Reset the timer.
    public func reset() {
        timeStarted = System.elapsedTime
    }

    private func reportCheckpoints(averageTime: Bool) {
        var readableOutput = accumulatedTime
        if averageTime {
            readableOutput /= Float(checkpoints)
        }
        readableOutput *= precision.multiplier
        let suffix = precision.suffix

        switch outputFormat {
        case .prettyPrinted:
            print(
                "Work for '\(description)' called \(checkpoints) times and took: \(readableOutput)\(suffix)"
            )
        case .tsv:
            print("\(description)\t\(checkpoints)\t\(readableOutput)")
        }
    }

    private func reportToConsole(time: Float, suffix: String) {
        switch outputFormat {
        case .prettyPrinted:
            print("Work for '\(description)' took: \(time, precision: 5)\(suffix)")
        case .tsv:
            print("\(description)\t\(time, precision: 5)")
        }
    }
}
