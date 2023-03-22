import Foundation

import Base
import BaseUI
import LayoutKit
import Networking
import Serialization

public final class DivKitComponents {
  public let actionHandler: DivActionHandler
  public let blockStateStorage = DivBlockStateStorage()
  public let divCustomBlockFactory: DivCustomBlockFactory
  public var extensionHandlers: [DivExtensionHandler]
  public let flagsInfo: DivFlagsInfo
  public let fontSpecifiers: FontSpecifiers
  public let imageHolderFactory: ImageHolderFactory
  public let patchProvider: DivPatchProvider
  public let stateManagement: DivStateManagement
  public let triggersStorage: DivTriggersStorage
  public let urlOpener: UrlOpener
  public let variablesStorage: DivVariablesStorage
  public let visibilityCounter = DivVisibilityCounter()
  
  public init(
    divCustomBlockFactory: DivCustomBlockFactory = EmptyDivCustomBlockFactory(),
    extensionHandlers: [DivExtensionHandler] = [],
    flagsInfo: DivFlagsInfo = .default,
    fontSpecifiers: FontSpecifiers = BaseUI.fontSpecifiers,
    imageHolderFactory: ImageHolderFactory? = nil,
    patchProvider: DivPatchProvider? = nil,
    requestPerformer: URLRequestPerforming? = nil,
    stateManagement: DivStateManagement = DefaultDivStateManagement(),
    trackVisibility: @escaping DivActionHandler.TrackVisibility = { _, _ in },
    updateCardAction: DivActionURLHandler.UpdateCardAction?,
    urlOpener: @escaping UrlOpener,
    variablesStorage: DivVariablesStorage = DivVariablesStorage()
  ) {
    self.divCustomBlockFactory = divCustomBlockFactory
    self.extensionHandlers = extensionHandlers
    self.flagsInfo = flagsInfo
    self.fontSpecifiers = fontSpecifiers
    self.stateManagement = stateManagement
    self.urlOpener = urlOpener
    self.variablesStorage = variablesStorage

    let requestPerformer = requestPerformer ?? URLRequestPerformer(urlTransform: nil)

    self.imageHolderFactory = imageHolderFactory
      ?? makeImageHolderFactory(requestPerformer: requestPerformer)

    self.patchProvider = patchProvider
      ?? DivPatchDownloader(requestPerformer: requestPerformer)

    actionHandler = DivActionHandler(
      stateUpdater: stateManagement,
      blockStateStorage: blockStateStorage,
      patchProvider: self.patchProvider,
      variablesStorage: variablesStorage,
      updateCard: { updateCardAction?($0, $1) },
      showTooltip: { _ in },
      logger: DefaultDivActionLogger(
        requestPerformer: requestPerformer
      ),
      trackVisibility: trackVisibility
    )

    triggersStorage = DivTriggersStorage(
      variablesStorage: variablesStorage,
      actionHandler: actionHandler,
      urlOpener: urlOpener
    )
  }

  public func reset() {
    patchProvider.cancelRequests()

    blockStateStorage.reset()
    stateManagement.reset()
    variablesStorage.reset()
    visibilityCounter.reset()
  }

  public func parseDivData(
    _ jsonDict: [String: Any],
    cardId: DivCardID
  ) throws -> DeserializationResult<DivData> {
    try parseDivDataWithTemplates(["card": jsonDict], cardId: cardId)
  }

  /// Parses DivData from JSON in following format:
  /// {
  ///   "card": { ... },
  ///   "templates": { ... }
  /// }
  public func parseDivDataWithTemplates(
    _ jsonDict: [String: Any],
    cardId: DivCardID
  ) throws -> DeserializationResult<DivData> {
    let rawDivData = try RawDivData(dictionary: jsonDict)
    let result = DivData.resolve(
      card: rawDivData.card,
      templates: rawDivData.templates
    )
    if let divData = result.value {
      setVariablesAndTriggers(divData: divData, cardId: cardId)
    }
    return result
  }

  /// Parses DivData from JSON in following format:
  /// {
  ///   "card": { ... },
  ///   "templates": { ... }
  /// }
  public func parseDivDataWithTemplates(
    _ jsonData: Data,
    cardId: DivCardID
  ) throws -> DeserializationResult<DivData> {
    guard let jsonObj = try? JSONSerialization.jsonObject(with: jsonData),
          let jsonDict = jsonObj as? [String: Any] else {
      throw DeserializationError.invalidJSONData(data: jsonData)
    }
    return try parseDivDataWithTemplates(jsonDict, cardId: cardId)
  }

  public func makeContext(
    cardId: DivCardID,
    cachedImageHolders: [ImageHolder],
    debugParams: DebugParams = DebugParams(),
    parentScrollView: ScrollView? = nil
  ) -> DivBlockModelingContext {
    DivBlockModelingContext(
      cardId: cardId,
      stateManager: stateManagement.getStateManagerForCard(cardId: cardId),
      blockStateStorage: blockStateStorage,
      visibilityCounter: visibilityCounter,
      imageHolderFactory: imageHolderFactory
        .withInMemoryCache(cachedImageHolders: cachedImageHolders),
      divCustomBlockFactory: divCustomBlockFactory,
      fontSpecifiers: fontSpecifiers,
      flagsInfo: flagsInfo,
      extensionHandlers: extensionHandlers,
      variables: variablesStorage.makeVariables(for: cardId),
      debugParams: debugParams,
      parentScrollView: parentScrollView
    )
  }

  public func handleActions(params: UserInterfaceAction.DivActionParams) {
    actionHandler.handle(params: params, urlOpener: urlOpener)
  }

  private func setVariablesAndTriggers(divData: DivData?, cardId: DivCardID) {
    let divDataVariables = divData?.variables?.extractDivVariableValues() ?? [:]
    variablesStorage.append(
      variables: divDataVariables,
      for: cardId,
      replaceExisting: false
    )

    triggersStorage.set(
      cardId: cardId,
      triggers: divData?.variableTriggers ?? []
    )
  }
}

func makeImageHolderFactory(requestPerformer: URLRequestPerforming) -> ImageHolderFactory {
  ImageHolderFactory(
    requester: NetworkURLResourceRequester(
      performer: requestPerformer
    ),
    imageProcessingQueue: OperationQueue(
      name: "tech.divkit.image-processing",
      qos: .userInitiated
    )
  )
}
