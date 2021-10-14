//
//  NotificationClient.swift
//  DevicePerformanceApp
//
//  Created by RN on 13/05/21.
//

import Foundation
import UIKit

public protocol TimerClient {

    func start()
    func stop()
}

public class TimerService: TimerClient {

    private let periodicInterval: TimeInterval
    private var timer: Timer?
    private let action: () -> Void

    public init(periodicInterval: TimeInterval, action: @escaping () -> Void) {
        self.periodicInterval = periodicInterval
        self.action = action
    }

    public func start() {
        timer = Timer.scheduledTimer(withTimeInterval: periodicInterval, repeats: true) {[weak self] timer in
            guard let self = self else {
                return
            }
            self.action()
        }
        timer?.tolerance = periodicInterval // to optimize battery
    }

    public func stop() {
        if let isTimerValid = timer?.isValid,
           isTimerValid == true {
            timer?.invalidate()
            timer = nil
        }
    }

    deinit {
        stop()
    }
}


