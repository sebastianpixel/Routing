/// `RootItem` represents a view e.g. in a tab bar or as
/// list items in a drawer navigation.
public struct RootItem: Equatable {
    public let title: String
    public let image: Image?
    public let selectedImage: Image?

    public init(
        title: String,
        image: Image?,
        selectedImage: Image?
    ) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
    }
}
