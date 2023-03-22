import CoreGraphics
import Foundation

import CommonCore

public final class TabsBlock: BlockWithTraits {
  public enum Error: NonEmptyString, BlockError {
    case unsupportedWidthTrait

    public var errorMessage: NonEmptyString { rawValue }
  }

  public let model: TabViewModel
  public let state: TabViewState
  public let widthTrait: LayoutTrait
  public let heightTrait: LayoutTrait

  public init(
    model: TabViewModel,
    state: TabViewState,
    widthTrait: LayoutTrait = .resizable,
    heightTrait: LayoutTrait = .intrinsic
  ) throws {
    self.model = model
    self.state = state
    self.widthTrait = widthTrait
    self.heightTrait = heightTrait

    try checkConstraints()
  }

  public var intrinsicContentWidth: CGFloat {
    switch widthTrait {
    case let .fixed(value):
      return value
    case .intrinsic, .weighted:
      let layout = TabViewLayout(
        model: model,
        selectedPageIndex: state.selectedPageIndex,
        height: .greatestFiniteMagnitude
      )
      return layout.size.width
    }
  }

  public func intrinsicContentHeight(forWidth width: CGFloat) -> CGFloat {
    switch heightTrait {
    case let .fixed(value):
      return value
    case .intrinsic, .weighted:
      let layout = TabViewLayout(
        model: model,
        selectedPageIndex: state.selectedPageIndex,
        width: width
      )
      return layout.size.height
    }
  }

  // Tabs block is allowed to have all-vertically-resizable tab contents
  // while being vertically non-resizable, as it's the only way
  // to make tab contents affect each other's height while allowing their resizing
  public func heightOfVerticallyNonResizableBlock(forWidth width: CGFloat) -> CGFloat {
    intrinsicContentHeight(forWidth: width)
  }

  public func equals(_ other: Block) -> Bool {
    guard let other = other as? TabsBlock else { return false }
    return self == other
  }

  private func checkConstraints() throws {
    let blocks = model.contentsModel.pages.map { $0.block }

    if widthTrait == .intrinsic, !blocks.hasHorizontallyNonResizable {
      throw Error.unsupportedWidthTrait
    }
  }
}

extension TabsBlock: Equatable {
  public static func ==(lhs: TabsBlock, rhs: TabsBlock) -> Bool {
    lhs.model == rhs.model &&
      lhs.widthTrait == rhs.widthTrait &&
      lhs.heightTrait == rhs.heightTrait &&
      lhs.state == rhs.state
  }
}

extension TabsBlock: ImageContaining {
  public func getImageHolders() -> [ImageHolder] {
    model.contentsModel.pages.flatMap { $0.block.getImageHolders() }
  }
}

extension TabsBlock: ElementStateUpdating {
  public func updated(withStates states: BlocksState) throws -> TabsBlock {
    let newPages = try model.contentsModel.pages
      .map { try $0.block.updated(withStates: states).makeTabPage(with: $0.path) }
    let pagesAreNotEqual = zip(model.contentsModel.pages, newPages)
      .contains(where: { $0.block !== $1.block })

    let newModel = pagesAreNotEqual
      ? try TabViewModel(
        listModel: model.listModel,
        contentsModel: modified(model.contentsModel) { $0.pages = newPages },
        separatorStyle: model.separatorStyle
      )
      : model

    let newState = states.getState(at: model.contentsModel.path) ?? state

    if newState != state || newModel !== model {
      return try TabsBlock(
        model: newModel,
        state: newState,
        widthTrait: widthTrait,
        heightTrait: heightTrait
      )
    }

    return self
  }
}

extension TabsBlock: LayoutCachingDefaultImpl {}
