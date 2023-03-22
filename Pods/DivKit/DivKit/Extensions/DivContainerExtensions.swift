import CommonCore
import LayoutKit

extension DivContainer: DivBlockModeling {
  public func makeBlock(context: DivBlockModelingContext) throws -> Block {
    try applyBaseProperties(
      to: { try makeBaseBlock(context: context) },
      context: modified(context) {
        $0.childrenA11yDescription = makeChildrenA11yDescription(context: $0)
      },
      actions: makeActions(context: context.actionContext),
      actionAnimation: actionAnimation.makeActionAnimation(with: context.expressionResolver),
      doubleTapActions: makeDoubleTapActions(context: context.actionContext),
      longTapActions: makeLongTapActions(context: context.actionContext)
    )
  }

  private func makeBaseBlock(context: DivBlockModelingContext) throws -> Block {
    let childContext = modified(context) {
      $0.parentPath = $0.parentPath + (id ?? DivContainer.type)
    }
    let orientation = resolveOrientation(context.expressionResolver)
    let layoutMode = resolveLayoutMode(context.expressionResolver)
    switch orientation {
    case .overlap:
      return try makeLayeredBlock(with: childContext, orientation: orientation)
    case .horizontal, .vertical:
      return try makeContainerBlock(with: childContext, orientation: orientation, layoutMode: layoutMode)
    }
  }

  private func makeChildrenA11yDescription(context: DivBlockModelingContext) -> String? {
    var result = ""
    func traverse(div: Div) {
      result = [result, div.makeA11yDecription(context: context)].compactMap { $0 }
        .joined(separator: " ")
      div.children.forEach(traverse(div:))
    }
    items.forEach(traverse)
    return result.isEmpty ? nil : result
  }

  private func checkConstraints(
    for children: [Block],
    path: UIElementPath
  ) throws {
    guard !children.isEmpty else {
      throw DivBlockModelingError("DivContainer is empty", path: path)
    }
  }

  private func getFallbackWidth(
    orientation: Orientation,
    layoutMode: LayoutMode = .noWrap
  ) -> DivOverridenSize? {
    if layoutMode == .wrap {
      switch orientation {
      case .vertical:
        if items.hasHorizontallyMatchParent {
          DivKitLogger.error("Vertical DivContainer with wrap layout mode contains item with match_parent width")
          return defaultFallbackSize
        }
      case .horizontal, .overlap:
        break
      }
    }

    if width.isIntrinsic {
      switch orientation {
      case .horizontal:
        if items.hasHorizontallyMatchParent {
          DivKitLogger.error("Horizontal DivContainer with wrap_content width contains item with match_parent width")
          return defaultFallbackSize
        }
      case .vertical, .overlap:
        if items.allHorizontallyMatchParent {
          DivKitLogger.error("All items in DivContainer with wrap_content width has match_parent width")
          return defaultFallbackSize
        }
      }
    }

    return nil
  }

  private func getFallbackHeight(
    orientation: Orientation,
    layoutMode: LayoutMode = .noWrap
  ) -> DivOverridenSize? {
    if layoutMode == .wrap {
      switch orientation {
      case .horizontal:
        if items.hasVerticallyMatchParent {
          DivKitLogger.error("Horizontal DivContainer with wrap layout mode contains item with match_parent height")
          return defaultFallbackSize
        }
      case .vertical, .overlap:
        break
      }
    }

    if height.isIntrinsic {
      switch orientation {
      case .horizontal, .overlap:
        if items.allVerticallyMatchParent {
          DivKitLogger.error("All items in DivContainer with wrap_content height has match_parent height")
          return defaultFallbackSize
        }
      case .vertical:
        if items.hasVerticallyMatchParent {
          DivKitLogger.error("Vertical DivContainer with wrap_content height contains item with match_parent height")
          return defaultFallbackSize
        }
      }
    }
    return nil
  }

  private func makeLayeredBlock(
    with childContext: DivBlockModelingContext,
    orientation: Orientation
  ) throws -> LayeredBlock {
    let defaultAlignment = BlockAlignment2D(
      horizontal: resolveContentAlignmentHorizontal(childContext.expressionResolver)
        .alignment,
      vertical: resolveContentAlignmentVertical(childContext.expressionResolver).alignment
    )

    let fallbackWidth = getFallbackWidth(orientation: orientation)
    let fallbackHeight = getFallbackHeight(orientation: orientation)
    
    let children = try items.makeBlocks(
      context: childContext,
      overridenWidth: fallbackWidth,
      overridenHeight: fallbackHeight,
      mappedBy: { div, block in
        LayeredBlock.Child(
          content: block,
          alignment: div.value.alignment2D(
            withDefault: defaultAlignment,
            expressionResolver: childContext.expressionResolver
          )
        )
      }
    )

    try checkConstraints(
      for: children.map { $0.content },
      path: childContext.parentPath
    )

    return LayeredBlock(
      widthTrait: makeContentWidthTrait(with: childContext),
      heightTrait: makeContentHeightTrait(with: childContext),
      children: children
    )
  }

  private func makeContainerBlock(
    with childContext: DivBlockModelingContext,
    orientation: Orientation,
    layoutMode: LayoutMode
  ) throws -> ContainerBlock {
    let layoutDirection = orientation.layoutDirection
    let axialAlignment: Alignment
    let defaultCrossAlignment: Alignment
    switch layoutDirection {
    case .horizontal:
      axialAlignment = resolveContentAlignmentHorizontal(childContext.expressionResolver)
        .alignment
      defaultCrossAlignment = resolveContentAlignmentVertical(
        childContext.expressionResolver
      )
      .alignment
    case .vertical:
      axialAlignment = resolveContentAlignmentVertical(childContext.expressionResolver)
        .alignment
      defaultCrossAlignment = resolveContentAlignmentHorizontal(
        childContext.expressionResolver
      )
      .alignment
    }

    let fallbackWidth = getFallbackWidth(orientation: orientation, layoutMode: layoutMode)
    let fallbackHeight = getFallbackHeight(orientation: orientation, layoutMode: layoutMode)

    let children = try items.makeBlocks(
      context: childContext,
      overridenWidth: fallbackWidth,
      overridenHeight: fallbackHeight,
      mappedBy: { div, block in
        ContainerBlock.Child(
          content: block,
          crossAlignment: div.value.crossAlignment(
            for: layoutDirection,
            expressionResolver: childContext.expressionResolver
          ) ?? defaultCrossAlignment
        )
      }
    )

    try checkConstraints(
      for: children.map { $0.content },
      path: childContext.parentPath
    )

    return try ContainerBlock(
      layoutDirection: layoutDirection,
      layoutMode: layoutMode.system,
      widthTrait: makeContentWidthTrait(with: childContext),
      heightTrait: makeContentHeightTrait(with: childContext),
      axialAlignment: axialAlignment,
      children: children
    )
  }
}

extension DivBase {
  fileprivate func crossAlignment(
    for direction: ContainerBlock.LayoutDirection,
    expressionResolver: ExpressionResolver
  ) -> Alignment? {
    switch direction {
    case .horizontal: return resolveAlignmentVertical(expressionResolver)?.alignment
    case .vertical: return resolveAlignmentHorizontal(expressionResolver)?.alignment
    }
  }
}

extension DivContainer.Orientation {
  fileprivate var layoutDirection: ContainerBlock.LayoutDirection {
    switch self {
    case .vertical:
      return .vertical
    case .horizontal:
      return .horizontal
    case .overlap:
      fatalError()
    }
  }
}

extension DivAlignmentHorizontal {
  var alignment: Alignment {
    switch self {
    case .left:
      return .leading
    case .center:
      return .center
    case .right:
      return .trailing
    }
  }
}

extension DivAlignmentVertical {
  var alignment: Alignment {
    switch self {
    case .top:
      return .leading
    case .center:
      return .center
    case .bottom:
      return .trailing
    }
  }
}

extension DivContainer.LayoutMode {
  fileprivate var system: ContainerBlock.LayoutMode {
    switch self {
    case .noWrap:
      return .noWrap
    case .wrap:
      return .wrap
    }
  }
}

extension Div {
  fileprivate func makeA11yDecription(context: DivBlockModelingContext) -> String? {
    guard value.accessibility.resolveMode(context.expressionResolver) != .exclude
    else { return nil }
    switch self {
    case .divImage, .divGifImage, .divSeparator, .divContainer, .divGrid, .divGallery, .divPager,
         .divTabs, .divState, .divCustom, .divIndicator, .divSlider, .divInput:
      return value.accessibility.resolveDescription(context.expressionResolver)
    case let .divText(divText):
      let handlerDescription = context
        .getExtensionHandlers(for: divText)
        .compactMap { $0.accessibilityElement?.strings.label }
        .reduce(nil) { $0?.appending(" " + $1) ?? $1 }
      return handlerDescription ??
        divText.accessibility.resolveDescription(context.expressionResolver) ??
        divText.resolveText(context.expressionResolver) as String?
    }
  }
}

private let defaultFallbackSize = DivOverridenSize(
  original: .divMatchParentSize(DivMatchParentSize()),
  overriden: .divWrapContentSize(DivWrapContentSize(constrained: .value(true)))
)
