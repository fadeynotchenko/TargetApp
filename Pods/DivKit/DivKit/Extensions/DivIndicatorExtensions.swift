import CoreGraphics
import Foundation

import CommonCore
import LayoutKit

extension DivIndicator: DivBlockModeling {
  public func makeBlock(context: DivBlockModelingContext) throws -> Block {
    try applyBaseProperties(
      to: { try makeBaseBlock(context: context) },
      context: context,
      actions: nil,
      actionAnimation: nil,
      doubleTapActions: nil,
      longTapActions: nil
    )
  }

  private func makeBaseBlock(context: DivBlockModelingContext) throws -> Block {
    guard let rectangle = shape.rectangle else {
      DivKitLogger.error("circle shape unsupported.")
      return EmptyBlock()
    }
    let pagerPath = pagerId.map {
      PagerPath(
        cardId: context.cardId.rawValue,
        pagerId: $0
      )
    }

    let state = context.blockStateStorage.states.pagerViewState(for: pagerPath) ?? .default

    let expressionResolver = context.expressionResolver
    let pageSize =
      CGSize(
        width: rectangle.itemWidth.resolveValue(expressionResolver) ?? 0,
        height: rectangle.itemHeight.resolveValue(expressionResolver) ?? 0
      )
    let configuration =
      PageIndicatorConfiguration(
        highlightedColor: resolveActiveItemColor(expressionResolver),
        normalColor: resolveInactiveItemColor(expressionResolver),
        highlightingScale: CGFloat(resolveActiveItemSize(expressionResolver)),
        disappearingScale: CGFloat(resolveMinimumItemSize(expressionResolver)),
        spaceBetweenCenters: CGFloat(
          spaceBetweenCenters.resolveValue(expressionResolver) ?? 0
        ),
        pageSize: pageSize,
        pageCornerRadius: CGFloat(
          rectangle.cornerRadius.resolveValue(expressionResolver) ?? 0
        ),
        animation: resolveAnimation(expressionResolver).asBlockAnimation
      )

    return
      PageControlBlock(
        pagerPath: pagerPath,
        widthTrait: makeContentWidthTrait(with: context),
        heightTrait: makeContentHeightTrait(with: context),
        configuration: configuration,
        state: state
      )
  }
}

extension DivShape {
  fileprivate var rectangle: DivRoundedRectangleShape? {
    switch self {
    case let .divRoundedRectangleShape(rectangle):
      return rectangle
    case .divCircleShape:
      return nil
    }
  }
}

extension DivIndicator.Animation {
  fileprivate var asBlockAnimation: PageIndicatorConfiguration.Animation {
    switch self {
    case .scale:
      return .scale
    case .worm:
      return .worm
    case .slider:
      return .slider
    }
  }
}
