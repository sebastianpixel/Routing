#if canImport(AppKit)
import AppKit
public typealias Image = NSImage
#else
import UIKit
public typealias Image = UIImage
#endif
