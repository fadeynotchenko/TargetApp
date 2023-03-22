import CommonCore

extension ImageBlock {
  public func makeCopy(with imageHolder: ImageHolder) -> ImageBlock {
    ImageBlock(
      imageHolder: imageHolder,
      widthTrait: widthTrait,
      height: height,
      contentMode: contentMode,
      tintColor: tintColor,
      accessibilityElement: accessibilityElement
    )
  }
}
