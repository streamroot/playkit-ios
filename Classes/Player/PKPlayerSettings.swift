// ===================================================================================================
// Copyright (C) 2017 Kaltura Inc.
//
// Licensed under the AGPLv3 license, unless a different license for a 
// particular library is specified in the applicable library path.
//
// You may obtain a copy of the License at
// https://www.gnu.org/licenses/agpl-3.0.html
// ===================================================================================================

import Foundation

typealias SettingsChange = ((PlayerSettingsType) -> Void)

@objc public class PKNetworkSettings: NSObject {
    
    var onChange: SettingsChange?
    
    @objc public var preferredPeakBitRate: Double = 0 {
        didSet {
            self.onChange?(.preferredPeakBitRate(preferredPeakBitRate))
        }
    }
}

@objc public enum TrackSelectionMode: Int, CustomStringConvertible {
    case off
    case auto
    case selection
    
    public init(_ mode: String) {
        switch mode {
        case "OFF": self = .off
        case "AUTO": self = .auto
        case "SELECTION": self = .selection
        default: self = .off
        }
    }
    
    public var description: String {
        switch self {
        case .off: return "OFF"
        case .auto: return "AUTO"
        case .selection: return "SELECTION"
        }
    }
    
    @available(*, deprecated, message: "Use description instead")
    public var asString: String {
        return self.description
    }
}

@objc public class PKTrackSelectionSettings: NSObject {
    // text selection settings
    @objc public var textSelectionMode: TrackSelectionMode = .off
    @objc public var textSelectionLanguage: String?
    // audio selection settings
    @objc public var audioSelectionMode: TrackSelectionMode = .off
    @objc public var audioSelectionLanguage: String?
}

enum PlayerSettingsType {
    case preferredPeakBitRate(Double)
    case preferredForwardBufferDuration(Double)
}

/************************************************************/
// MARK: - PKPlayerSettings
/************************************************************/

/// `PKPlayerSettings` object used as default configuration values for players.
@objc public class PKPlayerSettings: NSObject {
    
    var onChange: SettingsChange? {
        didSet {
            self.network.onChange = onChange
        }
    }
    
    @objc public var cea608CaptionsEnabled = false

    @objc public var preferredForwardBufferDuration: Double = 0 {
        didSet {
            self.onChange?(.preferredForwardBufferDuration(preferredForwardBufferDuration))
        }
    }

    /// The settings for network data consumption.
    @objc public var network = PKNetworkSettings()
    @objc public var trackSelection = PKTrackSelectionSettings()
    @objc public var textTrackStyling = PKTextTrackStyling()
    
    @objc public var contentRequestAdapter: PKRequestParamsAdapter?
    @objc public var licenseRequestAdapter: PKRequestParamsAdapter?
    
    @objc public var fairPlayLicenseProvider: FairPlayLicenseProvider?
    
    @objc public func createCopy() -> PKPlayerSettings {
        let copy = PKPlayerSettings()
        copy.cea608CaptionsEnabled = self.cea608CaptionsEnabled
        copy.preferredForwardBufferDuration = self.preferredForwardBufferDuration
        copy.network = self.network
        copy.trackSelection = self.trackSelection
        copy.textTrackStyling = self.textTrackStyling
        copy.contentRequestAdapter = self.contentRequestAdapter
        copy.licenseRequestAdapter = self.licenseRequestAdapter
        return copy
    }
}

extension PKPlayerSettings: NSCopying {
    
    @objc public func copy(with zone: NSZone? = nil) -> Any {
        return self.createCopy()
    }
}

