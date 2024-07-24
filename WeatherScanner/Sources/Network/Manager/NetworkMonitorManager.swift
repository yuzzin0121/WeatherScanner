//
//  NetworkMonitorManager.swift
//  WeatherScanner
//
//  Created by 조유진 on 7/24/24.
//

import Foundation
import Network

final class NetworkMonitorManager {
    static let shared = NetworkMonitorManager()
    
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                statusUpdateHandler(path.status)
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
