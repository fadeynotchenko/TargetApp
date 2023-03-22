import CoreGraphics

public protocol BlockWithTraits: BlockWithWidthTrait, BlockWithHeightTrait {}

public protocol BlockWithWidthTrait: Block {
  var widthTrait: LayoutTrait { get }
}

public protocol BlockWithHeightTrait: Block {
  var heightTrait: LayoutTrait { get }
}

extension BlockWithWidthTrait {
  public var isHorizontallyResizable: Bool { widthTrait.isResizable }

  public var isHorizontallyConstrained: Bool { widthTrait.isConstrained }

  public var widthOfHorizontallyNonResizableBlock: CGFloat {
    if case LayoutTrait.weighted = widthTrait {
      fatalError()
    }
    return intrinsicContentWidth
  }

  public var weightOfHorizontallyResizableBlock: LayoutTrait.Weight {
    guard case let .weighted(value) = widthTrait else { fatalError() }
    return value
  }
}

extension BlockWithHeightTrait {
  public var isVerticallyResizable: Bool { heightTrait.isResizable }

  public var isVerticallyConstrained: Bool { heightTrait.isConstrained }

  public func heightOfVerticallyNonResizableBlock(forWidth width: CGFloat) -> CGFloat {
    if case LayoutTrait.weighted = heightTrait {
      fatalError()
    }
    return intrinsicContentHeight(forWidth: width)
  }

  public var weightOfVerticallyResizableBlock: LayoutTrait.Weight {
    guard case let .weighted(value) = heightTrait else { fatalError() }
    return value
  }
}
