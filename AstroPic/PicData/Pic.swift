//
//  AstroPic.swift
//  AstroPic
//
//  Created by arjuna on 26/04/24.
//

import Foundation

/// Model representing the Picture of the day
struct Pic: Equatable {
    /// Picture Title
    let title: String?
    
    /// Picture Explanation
    let explanation: String?
    
    /// Picture captured date
    let date: Date?
    
    /// Url of the Pic the to download.. For video it will contain thumbnail url
    let url: URL?
    
    /// HD url of the pic. For the video it will contain video URL
    let hdurl: URL?
    
    /// True if the type the Pic was Video
    let isVideo: Bool
}
