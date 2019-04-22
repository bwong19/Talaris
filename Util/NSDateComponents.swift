//
//  DateHelpers.swift
//  Talaris
//
//  Created by Taha Baig on 4/22/19.
//  Copyright © 2019 Talaris. All rights reserved.
//

import Foundation

extension DateComponents {
    static var firstDateOfCurrentWeek: DateComponents {
        var beginningOfWeek: NSDate?
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        gregorian?.locale = Locale.current
        gregorian!.range(of: .weekOfYear, start: &beginningOfWeek, interval: nil, for: Date())
        let dateComponents = gregorian?.components([.era, .year, .month, .day],
                                                   from: beginningOfWeek! as Date)
        return dateComponents!
    }
}
