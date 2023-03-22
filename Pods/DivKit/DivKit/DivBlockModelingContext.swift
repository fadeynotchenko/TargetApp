import CoreGraphics

import Base
import BaseUI
import LayoutKit
import Networking

public struct DivBlockModelingContext {
  public let cardId: DivCardID
  internal var cardLogId: String?
  public internal(set) var parentPath: UIElementPath
  internal var parentDivStatePath: DivStatePath?
  public var stateManager: DivStateManager
  public let blockStateStorage: DivBlockStateStorage
  public let visibilityCounter: DivVisibilityCounting
  public var galleryResizableInsets: InsetMode.Resizable?
  public let imageHolderFactory: ImageHolderFactory
  public let highPriorityImageHolderFactory: ImageHolderFactory?
  public let divCustomBlockFactory: DivCustomBlockFactory
  public let fontSpecifiers: FontSpecifiers
  public let flagsInfo: DivFlagsInfo
  public let extensionHandlers: [String: DivExtensionHandler]
  public let stateInterceptors: [String: DivStateInterceptor]
  public let expressionResolver: ExpressionResolver
  public let debugParams: DebugParams
  public var childrenA11yDescription: String?
  public weak var parentScrollView: ScrollView?
  let expressionErrorsStorage = ExpressionErrorsStorage()
  var overridenWidth: DivOverridenSize? = nil
  var overridenHeight: DivOverridenSize? = nil

  public init(
    cardId: DivCardID,
    cardLogId: String? = nil,
    parentPath: UIElementPath? = nil,
    parentDivStatePath: DivStatePath? = nil,
    stateManager: DivStateManager,
    blockStateStorage: DivBlockStateStorage = DivBlockStateStorage(),
    visibilityCounter: DivVisibilityCounting = DivVisibilityCounter(),
    galleryResizableInsets: InsetMode.Resizable? = nil,
    imageHolderFactory: ImageHolderFactory,
    highPriorityImageHolderFactory: ImageHolderFactory? = nil,
    divCustomBlockFactory: DivCustomBlockFactory = EmptyDivCustomBlockFactory(),
    fontSpecifiers: FontSpecifiers = BaseUI.fontSpecifiers,
    flagsInfo: DivFlagsInfo = .default,
    extensionHandlers: [DivExtensionHandler] = [],
    stateInterceptors: [DivStateInterceptor] = [],
    variables: DivVariables = [:],
    debugParams: DebugParams = DebugParams(),
    childrenA11yDescription: String? = nil,
    parentScrollView: ScrollView? = nil
  ) {
    self.cardId = cardId
    self.cardLogId = cardLogId
    self.parentPath = parentPath ?? UIElementPath(cardId.rawValue)
    self.parentDivStatePath = parentDivStatePath
    self.stateManager = stateManager
    self.blockStateStorage = blockStateStorage
    self.visibilityCounter = visibilityCounter
    self.galleryResizableInsets = galleryResizableInsets
    self.imageHolderFactory = imageHolderFactory
    self.highPriorityImageHolderFactory = highPriorityImageHolderFactory
    self.divCustomBlockFactory = divCustomBlockFactory
    self.flagsInfo = flagsInfo
    self.fontSpecifiers = fontSpecifiers
    self.debugParams = debugParams
    self.childrenA11yDescription = childrenA11yDescription
    self.parentScrollView = parentScrollView

    if debugParams.isDebugInfoEnabled {
      self.expressionResolver = ExpressionResolver(
        variables: variables,
        errorTracker: { [weak expressionErrorsStorage] error in
          expressionErrorsStorage?.add(error: error)
        }
      )
    } else {
      self.expressionResolver = ExpressionResolver(variables: variables)
    }

    var extensionsHandlersDictionary = [String: DivExtensionHandler]()
    extensionHandlers.forEach {
      let id = $0.id
      if extensionsHandlersDictionary[id] != nil {
        DivKitLogger.failure("Duplicate DivExtensionHandler for: \(id)")
        return
      }
      extensionsHandlersDictionary[id] = $0
    }
    self.extensionHandlers = extensionsHandlersDictionary

    var stateInterceptorsDictionary = [String: DivStateInterceptor]()
    stateInterceptors.forEach {
      let id = $0.id
      if stateInterceptorsDictionary[id] != nil {
        DivKitLogger.failure("Duplicate DivStateInterceptor for: \(id)")
        return
      }
      stateInterceptorsDictionary[id] = $0
    }
    self.stateInterceptors = stateInterceptorsDictionary
  }

  public func getExtensionHandlers(for div: DivBase) -> [DivExtensionHandler] {
    guard let extensions = div.extensions else {
      return []
    }
    return extensions.compactMap {
      let id = $0.id
      let handler = extensionHandlers[id]
      if handler == nil {
        DivKitLogger.error("No DivExtensionHandler for: \(id)")
      }
      return handler
    }
  }

  public func getStateInterceptor(for divState: DivState) -> DivStateInterceptor? {
    divState.extensions?.compactMap { stateInterceptors[$0.id] }.first
  }

  func override(width: DivSize) -> DivSize {
    guard let overridenWidth = overridenWidth else {
      return width
    }
    if overridenWidth.original == width {
      return overridenWidth.overriden
    }
    return width
  }

  func override(height: DivSize) -> DivSize {
    guard let overridenHeight = overridenHeight else {
      return height
    }
    if overridenHeight.original == height {
      return overridenHeight.overriden
    }
    return height
  }
}
