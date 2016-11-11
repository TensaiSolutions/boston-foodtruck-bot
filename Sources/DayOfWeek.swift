//
//  DayOfWeek.swift
//
//Copyright (c) 2015-2016 Tensai Solutions LLC.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.

import Foundation

enum DayOfWeek: String {
    case Monday = "Monday"
    case Tuesday = "Tuesday"
    case Wednesday = "Wednesday"
    case Thursday = "Thursday"
    case Friday = "Friday"
    case Saturday = "Saturday"
    case Sunday = "Sunday"
    
    var dayNumber: Int {
        get {
            return self.hashValue
        }
    }
    
    private static let days = [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]
    
    static func fromNumber(number: Int) -> DayOfWeek {
        // FIXME check number index out of bounds
        return days[number-1]
    }
    
    static func getNextDay(day: DayOfWeek) -> DayOfWeek {
        
        //print(DayOfWeek.Tuesday.dayNumber)

        return days[(day.dayNumber + 1)%7]
        
    }
    
    static func today() -> DayOfWeek {
        let date = Date()
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 0
        let components = calendar.component(.weekday, from: date)
        return fromNumber(number: components)
    }
    
    static func tomorrow() -> DayOfWeek {
        return getNextDay(day: today())
    }
}


extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
