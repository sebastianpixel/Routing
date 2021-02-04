/// Typealias for the Image type in either AppKit or UIKit.
#if os(macOS)
import AppKit
public typealias Image = NSImage
#else
import UIKit
public typealias Image = UIImage
#endif
