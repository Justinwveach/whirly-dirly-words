//
//  AutoUpdateTimeLabel.swift
//  WhirlyDirlyWords
//
//  Created by Justin Veach on 2/20/18.
//  Copyright © 2018 justinveach. All rights reserved.
//

import UIKit
import CocoaLumberjack

// TODO: Refactor this mess

/// This class provides a label that will automatically update the time elapsed for a provided date.
class AutoUpdateTimeLabel: UILabel {
    
    var delegate: TimerDelegate?
    
    var autoUpdateTimer: Timer?
    var initialTimer: Timer?
    var date: Date!
    var dateComponentsFormatter: DateComponentsFormatter!
    var interval: NSCalendar.Unit!
    var row: Int?
    
    var startColor: UIColor?
    var endColor: UIColor?
    var textColorTime: Double?
    var colorExpirationDate: Date?
    var isCountdown = false
    
    /// Creates timers to update the label at the given interval.
    ///
    /// - Parameters:
    ///   - sinceDate: The date used to calculate the time elapsed from right now.
    ///   - interval: How often to update the label in seconds.
    ///   - formatter: Used to format the string representation of the time elapsed.
    public func autoUpdate(sinceDate: Date!, interval: NSCalendar.Unit!, formatter: DateComponentsFormatter!) {
        isCountdown = false
        setValues(date: sinceDate, interval: interval, dateComponentsFormatter: formatter)
        setTimer()
    }
    
    public func countdown(endDate: Date, interval: NSCalendar.Unit, formatter: DateComponentsFormatter) {
        isCountdown = true
        colorExpirationDate = endDate
        setValues(date: endDate, interval: interval, dateComponentsFormatter: formatter)
        setTimer()
    }
    
    /// Updates the color of the label based on the time elapsed.
    /// For example, the label could be green but turns red after 30 minutes has elapsed
    ///
    /// - Parameters:
    ///   - startColor: Starting color
    ///   - endColor: Color after desired time has elapsed
    ///   - timeElapsed: Expiration for the first color in seconds
    public func changeColor(from startColor: UIColor, to endColor: UIColor, after timeElapsed: Double) {
        self.startColor = startColor
        self.endColor = endColor
        self.textColorTime = timeElapsed
        
        if date != nil {
            self.colorExpirationDate = date.addingTimeInterval(timeElapsed)
        } else {
            DDLogWarn("changeColor may have been called before autoUpdate because the date was nil.")
        }
        
        self.textColor = startColor
    }
    
    fileprivate func setValues(date: Date!, interval: NSCalendar.Unit!, dateComponentsFormatter: DateComponentsFormatter!) {
        self.date = date
        self.interval = interval
        self.dateComponentsFormatter = dateComponentsFormatter
    }
    
    // Sets the initial timer that will be fired at the top of the minute or hour.
    // This is only called once because we will create a new timer for the specified time interval.
    fileprivate func setTimer() {
        // Represents the number of seconds left before top of the minute or hour.
        // For example, if the amount of time between a given date and right now is 1 hour 23 minutes and 41 seconds, and the interval provided was every minute, the remainder would be 19 seconds so that we can start our repeating timer at the correct time.  We don't want to update the label's minute representation at the 41st second of the minute.
        var intervalInSeconds: Double = 1
        let now = Date()
        
        switch self.interval {
        case NSCalendar.Unit.hour:
            let minutes = now.minutes(from: self.date)
            let remainder = minutes % 60
            intervalInSeconds = Double((60 - remainder) * 60)
            break
        case NSCalendar.Unit.minute:
            let seconds = now.seconds(from: self.date)
            intervalInSeconds = Double(60 - (seconds % 60))
            break
        default:
            // Default is every second
            intervalInSeconds = 1
            break
        }
        
        invalidate()
        
        updateLabel()
        
        self.initialTimer = Timer.scheduledTimer(timeInterval: intervalInSeconds, target: self, selector: #selector(updateFirstTime), userInfo: nil, repeats: false)
    }
    
    // Updates the label at the top of the hour or minute and creates a new timer that will repeat at this point.
    @objc private func updateFirstTime() {
        updateLabel()
        
        //Since we know that we are at the correct time, we just need to set the appropriate interval.
        let intervalInSeconds = secondsFrom(interval: interval)
        
        // Create a repeating timer that will update the label appropriately.
        self.autoUpdateTimer = Timer.scheduledTimer(timeInterval: intervalInSeconds, target: self, selector: #selector(updateSubsequentTimes), userInfo: nil, repeats: true)
        if (self.interval == .second) {
            // Since our label updates more often and we still want to the see the updates occur while scrolling
            RunLoop.current.add(self.autoUpdateTimer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    @objc private func updateSubsequentTimes() {
        updateLabel()
    }
    
    // Calculates the time between right now and the provided date and updates the label's text.
    @objc private func updateLabel() {
        var stringFromDates = dateComponentsFormatter.string(from: self.date, to: Date())
        if isCountdown {
            stringFromDates = stringFromDates?.replacingOccurrences(of: "-", with: "")
        }
        self.text = stringFromDates
        
        if let changeColorDate = colorExpirationDate {
            if Date() > changeColorDate {
                if endColor != nil {
                    self.textColor = endColor
                }
                delegate?.exceededTimeLimit()
            }
        }
    }
    
    public func invalidate() {
        self.autoUpdateTimer?.invalidate()
        self.initialTimer?.invalidate()
    }
    
    fileprivate func secondsFrom(interval: NSCalendar.Unit) -> Double {
        var intervalInSeconds: Double = 1
        
        switch self.interval {
        case NSCalendar.Unit.hour:
            intervalInSeconds = 60 * 60
            break
        case NSCalendar.Unit.minute:
            intervalInSeconds = 60
            break
        default:
            // Default is every second
            intervalInSeconds = 1
        }
    
        return intervalInSeconds
    }
}

// This class provides a way to provide multiple formatters for different lengths of time.
// For example, you may want to display the seconds for the first minute, but only hours and minutes after that.
class AutoUpdateTimeMultiFormatLabel: AutoUpdateTimeLabel {
    
    private var subsequentInterval: NSCalendar.Unit!
    private var subsequentFormatter: DateComponentsFormatter!
    
    
    /// Creates timers to update the label.
    ///
    /// - Parameters:
    ///   - sinceDate: The date used to calculate the time elapsed from right now.
    ///   - initialInterval: How often to update the first phase of the label in seconds.
    ///   - initialFormatter: The first formatter to be used until the duration has expired.
    ///   - initialFormatterDuration: How long you want the initial interval and formatter to be used in seconds.  This value will be added to the provided date. For example, if you wanted to display the inital formatter for 1 minute after the date provided, this value would be 60.
    ///   - subsequentInterval: How often to update the label in seconds after the initial phase has expired.
    ///   - subsequentFormatter: The formatter to use after the initial phase has expired.
    public func autoUpdate(sinceDate: Date!, initialInterval: NSCalendar.Unit!, initialFormatter: DateComponentsFormatter!, initialFormatterDuration: Double!, subsequentInterval: NSCalendar.Unit!, subsequentFormatter: DateComponentsFormatter!) {
        self.date = sinceDate
        self.subsequentInterval = subsequentInterval
        self.subsequentFormatter = subsequentFormatter
        
        // The date when the initial format should no longer be used.
        let initialFormatterEndDate = self.date.addingTimeInterval(initialFormatterDuration)
        let now = Date()
        
        if (now <= initialFormatterEndDate) {
            setValues(date: sinceDate, interval: initialInterval, dateComponentsFormatter: initialFormatter)
            setTimer()
            
            // The number of seconds remaining before the intial format should not be used.
            let remainingTime = initialFormatterEndDate.timeIntervalSince(now)
            Timer.scheduledTimer(timeInterval: remainingTime, target: self, selector: #selector(cancelInitialFormat), userInfo: nil, repeats: false)
        } else {
            setSubsequentTimer()
        }
    }
    
    private func setSubsequentTimer() {
        setValues(date: self.date, interval: self.subsequentInterval, dateComponentsFormatter: self.subsequentFormatter)
        setTimer()
    }
    
    @objc private func cancelInitialFormat() {
        setSubsequentTimer()
    }
}

