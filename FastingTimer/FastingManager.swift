//
//  FastingManager.swift
//  FastingTimer
//
//  Created by rafiul hasan on 23/11/22.
//

import Foundation

class FastingManager: ObservableObject {
    @Published private(set) var fastingState: FastingState = .notStarted
    @Published private(set) var fastingPlan: FastingPlan = .intermediate
    @Published private(set) var elapsed: Bool = false
    @Published private(set) var elapsedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0
    @Published private(set) var startTime: Date {
        didSet {
            print("Start Time", startTime.formatted(.dateTime.month().day().hour().minute().second()))
            if fastingState == .fasting {
                endTime = startTime.addingTimeInterval(fastingTime)
            } else {
                endTime = startTime.addingTimeInterval(feedingTime)
            }
        }
    }
    @Published private(set) var endTime: Date {
        didSet {
            print("End Time", endTime.formatted(.dateTime.month().day().hour().minute().second()))
        }
    }
    
    var fastingTime: Double {
        return fastingPlan.fastingPeriod * 60 * 60
    }
    var feedingTime: Double {
        return (24 - fastingPlan.fastingPeriod) * 60 * 60
    }
    
    init() {
        let calender = Calendar.current
        
        let components = DateComponents(hour: 20)
        let scheduledTime = calender.nextDate(after: .now, matching: components, matchingPolicy: .nextTime)!
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(FastingPlan.intermediate.fastingPeriod * 60 * 60)
    }
    
    func toggleFastingState() {
        fastingState = fastingState == .fasting ? .feeding : .fasting
        startTime = Date()
        elapsedTime = 0.0
    }
    
    func track() {
        guard fastingState != .notStarted else { return }
        print("Now", Date().formatted(.dateTime.month().day().hour().minute().second()))
            
        if endTime >= Date() {
            print("Not elapsed")
            elapsed = false
        } else {
            print("Elapsed")
            elapsed = true
        } 
        
        elapsedTime += 1
        print("ElapsedTime", elapsedTime)
        
        let totalTime = fastingState == .fasting ? fastingTime : feedingTime
        progress = (elapsedTime / totalTime * 100).rounded() / 100
        print("progress", progress)
    }
}
