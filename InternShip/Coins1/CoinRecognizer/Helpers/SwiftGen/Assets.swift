// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Assets {
    internal static let accentColor = ColorAsset(name: "AccentColor")
    internal static let _1tips = ImageAsset(name: "1tips")
    internal static let _2tips = ImageAsset(name: "2tips")
    internal static let _3tips = ImageAsset(name: "3tips")
    internal static let blurTips = ImageAsset(name: "blurTips")
    internal static let button = ImageAsset(name: "button")
    internal static let checkTips = ImageAsset(name: "checkTips")
    internal static let close = ImageAsset(name: "close")
    internal static let closeMini = ImageAsset(name: "closeMini")
    internal static let cross = ImageAsset(name: "cross")
    internal static let darkTips = ImageAsset(name: "darkTips")
    internal static let gallery = ImageAsset(name: "gallery")
    internal static let inport = ImageAsset(name: "inport")
    internal static let line = ImageAsset(name: "line")
    internal static let mainTips = ImageAsset(name: "mainTips")
    internal static let manyTips = ImageAsset(name: "manyTips")
    internal static let redCLose = ImageAsset(name: "redCLose")
    internal static let turnOff = ImageAsset(name: "turn-off")
    internal static let turnOn = ImageAsset(name: "turnOn")
    internal static let dwatff = ImageAsset(name: "dwatff")
    internal static let sendArrow = ImageAsset(name: "sendArrow")
    internal static let crest = ImageAsset(name: "crest")
    internal static let delete = ImageAsset(name: "delete")
    internal static let folder = ImageAsset(name: "folder")
    internal static let folderBlue = ImageAsset(name: "folderBlue")
    internal static let folderGreen = ImageAsset(name: "folderGreen")
    internal static let folderPink = ImageAsset(name: "folderPink")
    internal static let folderViolet = ImageAsset(name: "folderViolet")
    internal static let folderYellow = ImageAsset(name: "folderYellow")
    internal static let trash = ImageAsset(name: "trash")
    internal static let back = ImageAsset(name: "back")
    internal static let catalogCoins = ImageAsset(name: "catalogCoins")
    internal static let check = ImageAsset(name: "check")
    internal static let closeMiniGray = ImageAsset(name: "closeMiniGray")
    internal static let coinCeel = ImageAsset(name: "coinCeel")
    internal static let crown = ImageAsset(name: "crown")
    internal static let ellipse = ImageAsset(name: "ellipse")
    internal static let filtr = ImageAsset(name: "filtr")
    internal static let filtrFill = ImageAsset(name: "filtrFill")
    internal static let homeCoins = ImageAsset(name: "homeCoins")
    internal static let messageCoin = ImageAsset(name: "messageCoin")
    internal static let searchText = ImageAsset(name: "searchText")
    internal static let settings = ImageAsset(name: "settings")
    internal static let wallet1 = ImageAsset(name: "wallet 1")
    internal static let bgImage = ImageAsset(name: "bgImage")
    internal static let circles = ImageAsset(name: "circles")
    internal static let dollarLog = ImageAsset(name: "dollarLog")
    internal static let folders = ImageAsset(name: "folders")
    internal static let onb4 = ImageAsset(name: "onb4")
    internal static let onbFolder = ImageAsset(name: "onbFolder")
    internal static let onb1 = ImageAsset(name: "onb_1")
    internal static let onb2 = ImageAsset(name: "onb_2")
    internal static let shine = ImageAsset(name: "shine")
    internal static let coinsCollect = ImageAsset(name: "coinsCollect")
    internal static let elements = ImageAsset(name: "elements")
    internal static let heart = ImageAsset(name: "heart")
    internal static let heartFill = ImageAsset(name: "heartFill")
    internal static let phiscoin = ImageAsset(name: "phiscoin")
    internal static let premiumCoins = ImageAsset(name: "premiumCoins")
    internal static let arrowRight = ImageAsset(name: "arrowRight")
    internal static let bag = ImageAsset(name: "bag")
    internal static let circle = ImageAsset(name: "circle")
    internal static let edit = ImageAsset(name: "edit")
    internal static let funlock = ImageAsset(name: "funlock")
    internal static let person = ImageAsset(name: "person")
    internal static let star = ImageAsset(name: "star")
    internal static let tabbg = ImageAsset(name: "Tabbg")
    internal static let cameraLogo = ImageAsset(name: "cameraLogo")
    internal static let collection = ImageAsset(name: "collection")
    internal static let home = ImageAsset(name: "home")
    internal static let inCollect = ImageAsset(name: "inCollect")
    internal static let inHome = ImageAsset(name: "inHome")
  }
  internal enum Color {
    internal static let dark = ColorAsset(name: "Dark")
    internal static let gold1 = ColorAsset(name: "gold1")
    internal static let gold2 = ColorAsset(name: "gold2")
    internal static let gold3 = ColorAsset(name: "gold3")
    internal static let mainBej = ColorAsset(name: "mainBej")
    internal static let mainBlue = ColorAsset(name: "mainBlue")
    internal static let mainGreen = ColorAsset(name: "mainGreen")
    internal static let mainPink = ColorAsset(name: "mainPink")
    internal static let mainPurple = ColorAsset(name: "mainPurple")
    internal static let mainYellow = ColorAsset(name: "mainYellow")
    internal static let midBlue = ColorAsset(name: "midBlue")
    internal static let midGreen = ColorAsset(name: "midGreen")
    internal static let midNativ = ColorAsset(name: "midNativ")
    internal static let midPink = ColorAsset(name: "midPink")
    internal static let midPurple = ColorAsset(name: "midPurple")
    internal static let midYellow = ColorAsset(name: "midYellow")
    internal static let original = ColorAsset(name: "original")
    internal static let shadow = ColorAsset(name: "shadow")
    internal static let black = ColorAsset(name: "black")
    internal static let endColor = ColorAsset(name: "endColor")
    internal static let grey = ColorAsset(name: "grey")
    internal static let lightBlue = ColorAsset(name: "lightBlue")
    internal static let lightGray = ColorAsset(name: "lightGray")
    internal static let natiivGray = ColorAsset(name: "natiivGray")
    internal static let nativ = ColorAsset(name: "nativ")
    internal static let orange = ColorAsset(name: "orange")
    internal static let originalBlue = ColorAsset(name: "originalBlue")
    internal static let startColor = ColorAsset(name: "startColor")
    internal static let textGray = ColorAsset(name: "textGray")
    internal static let white = ColorAsset(name: "white")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
