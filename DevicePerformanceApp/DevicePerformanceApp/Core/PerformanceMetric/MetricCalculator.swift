//
//  CPUMetricCalculator.swift
//  DevicePerformanceApp
//
//  Created by RN on 12/05/21.
//

import Foundation
import UIKit

public protocol MetricCalculatorClient {
    func getUsedCPULoadPercentage() -> Int
    func getUsedMemoryPercentage() -> Int
    func getUsedBatteryPercentage() -> Int
}

struct MetricCalculatorService: MetricCalculatorClient {

    func getUsedCPULoadPercentage() -> Int {
        let HOST_CPU_LOAD_INFO_COUNT = MemoryLayout<host_cpu_load_info>.stride/MemoryLayout<integer_t>.stride
        var size = mach_msg_type_number_t(HOST_CPU_LOAD_INFO_COUNT)
        var cpuLoadInfo = host_cpu_load_info()

        let result = withUnsafeMutablePointer(to: &cpuLoadInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: HOST_CPU_LOAD_INFO_COUNT) {
                host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
            }
        }
        if result != KERN_SUCCESS{
            print("Error  - \(#file): \(#function) - kern_result_t = \(result)")
            return 0
        }
        // user, system, idle, nice
        let totalUsedTicks = Int(cpuLoadInfo.cpu_ticks.0 + cpuLoadInfo.cpu_ticks.1 + cpuLoadInfo.cpu_ticks.3)
        let totalTicks = Int(totalUsedTicks) + Int(cpuLoadInfo.cpu_ticks.2) // add idle ticks
        return ((totalUsedTicks * 100) / totalTicks)
    }

    func getUsedMemoryPercentage() -> Int {
        let usedMemory = getUsedMemory()
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        let usedPercentage = ((usedMemory * 100) / totalMemory)
        return Int(usedPercentage)
    }

    private func getUsedMemory () -> UInt64
    {
        var pagesize: vm_size_t = 0

        let host_port: mach_port_t = mach_host_self()
        var host_size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
        host_page_size(host_port, &pagesize)

        var vm_stat: vm_statistics = vm_statistics_data_t()
        withUnsafeMutablePointer(to: &vm_stat) { (vmStatPointer) -> Void in
            vmStatPointer.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
                if (host_statistics(host_port, HOST_VM_INFO, $0, &host_size) != KERN_SUCCESS) {
                    print("Error: Failed to fetch vm statistics")
                }
            }
        }

        /* Stats in bytes */
        let totalUsedMemory: UInt64 = UInt64(vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * UInt64(pagesize)
        return totalUsedMemory

    }

    func getUsedBatteryPercentage() -> Int {
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = Double(UIDevice.current.batteryLevel * 100)
        return Int((100 - batteryLevel))
    }
}
