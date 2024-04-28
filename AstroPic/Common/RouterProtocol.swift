//
//  RouterProtocol.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import Foundation
import UIKit

/// Router protocol to be implemented by all the routers in the app
protocol Router {
    
    /// Returns the intial view controller of the particular router which will be used by the start method
    func build() -> UIViewController
    
    
    /// Either presents or adds the view controller to the container view controller which is returned by build()
    func start()
}
