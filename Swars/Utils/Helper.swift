//
//  Helper.swift
//  Swars
//
//  Created by Endre Mikal Synnes on 09/11/2018.
//  Copyright © 2018 Endre Mikal Synnes. All rights reserved.
//

// Referanse: https://medium.com/infancyit/start-using-helper-class-now-part-2-3669e13ffacf


import UIKit
import SystemConfiguration

class Helper {
    static var app: Helper = {
        return Helper()
    }()

    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
}
