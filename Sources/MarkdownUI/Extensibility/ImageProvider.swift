import SwiftUI

/// A type that provides a view that asynchronously loads and displays an image in a Markdown view.
///
/// To configure the current image provider for a view hierarchy, use the `markdownImageProvider(_:)` modifier.
///
/// The following example shows how to configure the ``AssetImageProvider`` to load images from the main bundle.
///
/// ```swift
/// Markdown {
///   "![A dog](dog)"
///   "― Photo by André Spieker"
/// }
/// .markdownImageProvider(.asset)
/// ```
public protocol ImageProvider {
  /// A view that loads and displays an image.
  associatedtype Body: View

  /// Creates a view that asynchronously loads and displays the image on a given URL.
  ///
  /// The ``Markdown`` views in a view hierarchy where this provider is the current image provider
  /// will call this method for each image in their contents.
  ///
  /// - Parameter url: The URL of the image to display.
  @ViewBuilder func makeImage(url: URL?, alt: String?, destination: String?) -> Body
}

struct AnyImageProvider: ImageProvider {
  private let _makeImage: (URL?, String?, String?) -> AnyView

  init<I: ImageProvider>(_ imageProvider: I) {
    self._makeImage = {
      AnyView(imageProvider.makeImage(url: $0, alt: $1, destination: $2))
    }
  }

  func makeImage(url: URL?, alt: String? = nil, destination: String? = nil) -> some View {
    self._makeImage(url, alt, destination)
  }
}
