//
//  RouterProtocol.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import Foundation
import UIKit

protocol Router {
    func build() -> UIViewController
    func start()
}
