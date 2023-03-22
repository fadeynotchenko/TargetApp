// Generated code. Do not modify.

import CommonCore
import Foundation
import Serialization
import TemplatesSupport

public final class DivStateTemplate: TemplateValue, TemplateDeserializable {
  public final class StateTemplate: TemplateValue, TemplateDeserializable {
    public let animationIn: Field<DivAnimationTemplate>?
    public let animationOut: Field<DivAnimationTemplate>?
    public let div: Field<DivTemplate>?
    public let stateId: Field<String>?
    public let swipeOutActions: Field<[DivActionTemplate]>? // at least 1 elements

    public convenience init(dictionary: [String: Any], templateToType: TemplateToType) throws {
      do {
        self.init(
          animationIn: try dictionary.getOptionalField("animation_in", templateToType: templateToType),
          animationOut: try dictionary.getOptionalField("animation_out", templateToType: templateToType),
          div: try dictionary.getOptionalField("div", templateToType: templateToType),
          stateId: try dictionary.getOptionalField("state_id"),
          swipeOutActions: try dictionary.getOptionalArray("swipe_out_actions", templateToType: templateToType)
        )
      } catch let DeserializationError.invalidFieldRepresentation(field: field, representation: representation) {
        throw DeserializationError.invalidFieldRepresentation(field: "state_template." + field, representation: representation)
      }
    }

    init(
      animationIn: Field<DivAnimationTemplate>? = nil,
      animationOut: Field<DivAnimationTemplate>? = nil,
      div: Field<DivTemplate>? = nil,
      stateId: Field<String>? = nil,
      swipeOutActions: Field<[DivActionTemplate]>? = nil
    ) {
      self.animationIn = animationIn
      self.animationOut = animationOut
      self.div = div
      self.stateId = stateId
      self.swipeOutActions = swipeOutActions
    }

    private static func resolveOnlyLinks(context: Context, parent: StateTemplate?) -> DeserializationResult<DivState.State> {
      let animationInValue = parent?.animationIn?.resolveOptionalValue(context: context, validator: ResolvedValue.animationInValidator, useOnlyLinks: true) ?? .noValue
      let animationOutValue = parent?.animationOut?.resolveOptionalValue(context: context, validator: ResolvedValue.animationOutValidator, useOnlyLinks: true) ?? .noValue
      let divValue = parent?.div?.resolveOptionalValue(context: context, validator: ResolvedValue.divValidator, useOnlyLinks: true) ?? .noValue
      let stateIdValue = parent?.stateId?.resolveValue(context: context) ?? .noValue
      let swipeOutActionsValue = parent?.swipeOutActions?.resolveOptionalValue(context: context, validator: ResolvedValue.swipeOutActionsValidator, useOnlyLinks: true) ?? .noValue
      var errors = mergeErrors(
        animationInValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "animation_in", level: .warning)) },
        animationOutValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "animation_out", level: .warning)) },
        divValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "div", level: .warning)) },
        stateIdValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "state_id", level: .error)) },
        swipeOutActionsValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "swipe_out_actions", level: .warning)) }
      )
      if case .noValue = stateIdValue {
        errors.append(.right(FieldError(fieldName: "state_id", level: .error, error: .requiredFieldIsMissing)))
      }
      guard
        let stateIdNonNil = stateIdValue.value
      else {
        return .failure(NonEmptyArray(errors)!)
      }
      let result = DivState.State(
        animationIn: animationInValue.value,
        animationOut: animationOutValue.value,
        div: divValue.value,
        stateId: stateIdNonNil,
        swipeOutActions: swipeOutActionsValue.value
      )
      return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
    }

    public static func resolveValue(context: Context, parent: StateTemplate?, useOnlyLinks: Bool) -> DeserializationResult<DivState.State> {
      if useOnlyLinks {
        return resolveOnlyLinks(context: context, parent: parent)
      }
      var animationInValue: DeserializationResult<DivAnimation> = .noValue
      var animationOutValue: DeserializationResult<DivAnimation> = .noValue
      var divValue: DeserializationResult<Div> = .noValue
      var stateIdValue: DeserializationResult<String> = parent?.stateId?.value() ?? .noValue
      var swipeOutActionsValue: DeserializationResult<[DivAction]> = .noValue
      context.templateData.forEach { key, __dictValue in
        switch key {
        case "animation_in":
          animationInValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.animationInValidator, type: DivAnimationTemplate.self).merged(with: animationInValue)
        case "animation_out":
          animationOutValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.animationOutValidator, type: DivAnimationTemplate.self).merged(with: animationOutValue)
        case "div":
          divValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.divValidator, type: DivTemplate.self).merged(with: divValue)
        case "state_id":
          stateIdValue = deserialize(__dictValue).merged(with: stateIdValue)
        case "swipe_out_actions":
          swipeOutActionsValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.swipeOutActionsValidator, type: DivActionTemplate.self).merged(with: swipeOutActionsValue)
        case parent?.animationIn?.link:
          animationInValue = animationInValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.animationInValidator, type: DivAnimationTemplate.self))
        case parent?.animationOut?.link:
          animationOutValue = animationOutValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.animationOutValidator, type: DivAnimationTemplate.self))
        case parent?.div?.link:
          divValue = divValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.divValidator, type: DivTemplate.self))
        case parent?.stateId?.link:
          stateIdValue = stateIdValue.merged(with: deserialize(__dictValue))
        case parent?.swipeOutActions?.link:
          swipeOutActionsValue = swipeOutActionsValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.swipeOutActionsValidator, type: DivActionTemplate.self))
        default: break
        }
      }
      if let parent = parent {
        animationInValue = animationInValue.merged(with: parent.animationIn?.resolveOptionalValue(context: context, validator: ResolvedValue.animationInValidator, useOnlyLinks: true))
        animationOutValue = animationOutValue.merged(with: parent.animationOut?.resolveOptionalValue(context: context, validator: ResolvedValue.animationOutValidator, useOnlyLinks: true))
        divValue = divValue.merged(with: parent.div?.resolveOptionalValue(context: context, validator: ResolvedValue.divValidator, useOnlyLinks: true))
        swipeOutActionsValue = swipeOutActionsValue.merged(with: parent.swipeOutActions?.resolveOptionalValue(context: context, validator: ResolvedValue.swipeOutActionsValidator, useOnlyLinks: true))
      }
      var errors = mergeErrors(
        animationInValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "animation_in", level: .warning)) },
        animationOutValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "animation_out", level: .warning)) },
        divValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "div", level: .warning)) },
        stateIdValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "state_id", level: .error)) },
        swipeOutActionsValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "swipe_out_actions", level: .warning)) }
      )
      if case .noValue = stateIdValue {
        errors.append(.right(FieldError(fieldName: "state_id", level: .error, error: .requiredFieldIsMissing)))
      }
      guard
        let stateIdNonNil = stateIdValue.value
      else {
        return .failure(NonEmptyArray(errors)!)
      }
      let result = DivState.State(
        animationIn: animationInValue.value,
        animationOut: animationOutValue.value,
        div: divValue.value,
        stateId: stateIdNonNil,
        swipeOutActions: swipeOutActionsValue.value
      )
      return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
    }

    private func mergedWithParent(templates: Templates) throws -> StateTemplate {
      return self
    }

    public func resolveParent(templates: Templates) throws -> StateTemplate {
      let merged = try mergedWithParent(templates: templates)

      return StateTemplate(
        animationIn: merged.animationIn?.tryResolveParent(templates: templates),
        animationOut: merged.animationOut?.tryResolveParent(templates: templates),
        div: merged.div?.tryResolveParent(templates: templates),
        stateId: merged.stateId,
        swipeOutActions: merged.swipeOutActions?.tryResolveParent(templates: templates)
      )
    }
  }

  public static let type: String = "state"
  public let parent: String? // at least 1 char
  public let accessibility: Field<DivAccessibilityTemplate>?
  public let alignmentHorizontal: Field<Expression<DivAlignmentHorizontal>>?
  public let alignmentVertical: Field<Expression<DivAlignmentVertical>>?
  public let alpha: Field<Expression<Double>>? // constraint: number >= 0.0 && number <= 1.0; default value: 1.0
  public let background: Field<[DivBackgroundTemplate]>? // at least 1 elements
  public let border: Field<DivBorderTemplate>?
  public let columnSpan: Field<Expression<Int>>? // constraint: number >= 0
  public let defaultStateId: Field<Expression<String>>?
  public let divId: Field<String>?
  public let extensions: Field<[DivExtensionTemplate]>? // at least 1 elements
  public let focus: Field<DivFocusTemplate>?
  public let height: Field<DivSizeTemplate>? // default value: .divWrapContentSize(DivWrapContentSize())
  public let id: Field<String>? // at least 1 char
  public let margins: Field<DivEdgeInsetsTemplate>?
  public let paddings: Field<DivEdgeInsetsTemplate>?
  public let rowSpan: Field<Expression<Int>>? // constraint: number >= 0
  public let selectedActions: Field<[DivActionTemplate]>? // at least 1 elements
  public let states: Field<[StateTemplate]>? // at least 1 elements
  public let tooltips: Field<[DivTooltipTemplate]>? // at least 1 elements
  public let transform: Field<DivTransformTemplate>?
  public let transitionAnimationSelector: Field<Expression<DivTransitionSelector>>? // default value: state_change
  public let transitionChange: Field<DivChangeTransitionTemplate>?
  public let transitionIn: Field<DivAppearanceTransitionTemplate>?
  public let transitionOut: Field<DivAppearanceTransitionTemplate>?
  public let transitionTriggers: Field<[DivTransitionTrigger]>? // at least 1 elements
  public let visibility: Field<Expression<DivVisibility>>? // default value: visible
  public let visibilityAction: Field<DivVisibilityActionTemplate>?
  public let visibilityActions: Field<[DivVisibilityActionTemplate]>? // at least 1 elements
  public let width: Field<DivSizeTemplate>? // default value: .divMatchParentSize(DivMatchParentSize())

  static let parentValidator: AnyValueValidator<String> =
    makeStringValidator(minLength: 1)

  public convenience init(dictionary: [String: Any], templateToType: TemplateToType) throws {
    do {
      self.init(
        parent: try dictionary.getOptionalField("type", validator: Self.parentValidator),
        accessibility: try dictionary.getOptionalField("accessibility", templateToType: templateToType),
        alignmentHorizontal: try dictionary.getOptionalExpressionField("alignment_horizontal"),
        alignmentVertical: try dictionary.getOptionalExpressionField("alignment_vertical"),
        alpha: try dictionary.getOptionalExpressionField("alpha"),
        background: try dictionary.getOptionalArray("background", templateToType: templateToType),
        border: try dictionary.getOptionalField("border", templateToType: templateToType),
        columnSpan: try dictionary.getOptionalExpressionField("column_span"),
        defaultStateId: try dictionary.getOptionalExpressionField("default_state_id"),
        divId: try dictionary.getOptionalField("div_id"),
        extensions: try dictionary.getOptionalArray("extensions", templateToType: templateToType),
        focus: try dictionary.getOptionalField("focus", templateToType: templateToType),
        height: try dictionary.getOptionalField("height", templateToType: templateToType),
        id: try dictionary.getOptionalField("id"),
        margins: try dictionary.getOptionalField("margins", templateToType: templateToType),
        paddings: try dictionary.getOptionalField("paddings", templateToType: templateToType),
        rowSpan: try dictionary.getOptionalExpressionField("row_span"),
        selectedActions: try dictionary.getOptionalArray("selected_actions", templateToType: templateToType),
        states: try dictionary.getOptionalArray("states", templateToType: templateToType),
        tooltips: try dictionary.getOptionalArray("tooltips", templateToType: templateToType),
        transform: try dictionary.getOptionalField("transform", templateToType: templateToType),
        transitionAnimationSelector: try dictionary.getOptionalExpressionField("transition_animation_selector"),
        transitionChange: try dictionary.getOptionalField("transition_change", templateToType: templateToType),
        transitionIn: try dictionary.getOptionalField("transition_in", templateToType: templateToType),
        transitionOut: try dictionary.getOptionalField("transition_out", templateToType: templateToType),
        transitionTriggers: try dictionary.getOptionalArray("transition_triggers"),
        visibility: try dictionary.getOptionalExpressionField("visibility"),
        visibilityAction: try dictionary.getOptionalField("visibility_action", templateToType: templateToType),
        visibilityActions: try dictionary.getOptionalArray("visibility_actions", templateToType: templateToType),
        width: try dictionary.getOptionalField("width", templateToType: templateToType)
      )
    } catch let DeserializationError.invalidFieldRepresentation(field: field, representation: representation) {
      throw DeserializationError.invalidFieldRepresentation(field: "div-state_template." + field, representation: representation)
    }
  }

  init(
    parent: String?,
    accessibility: Field<DivAccessibilityTemplate>? = nil,
    alignmentHorizontal: Field<Expression<DivAlignmentHorizontal>>? = nil,
    alignmentVertical: Field<Expression<DivAlignmentVertical>>? = nil,
    alpha: Field<Expression<Double>>? = nil,
    background: Field<[DivBackgroundTemplate]>? = nil,
    border: Field<DivBorderTemplate>? = nil,
    columnSpan: Field<Expression<Int>>? = nil,
    defaultStateId: Field<Expression<String>>? = nil,
    divId: Field<String>? = nil,
    extensions: Field<[DivExtensionTemplate]>? = nil,
    focus: Field<DivFocusTemplate>? = nil,
    height: Field<DivSizeTemplate>? = nil,
    id: Field<String>? = nil,
    margins: Field<DivEdgeInsetsTemplate>? = nil,
    paddings: Field<DivEdgeInsetsTemplate>? = nil,
    rowSpan: Field<Expression<Int>>? = nil,
    selectedActions: Field<[DivActionTemplate]>? = nil,
    states: Field<[StateTemplate]>? = nil,
    tooltips: Field<[DivTooltipTemplate]>? = nil,
    transform: Field<DivTransformTemplate>? = nil,
    transitionAnimationSelector: Field<Expression<DivTransitionSelector>>? = nil,
    transitionChange: Field<DivChangeTransitionTemplate>? = nil,
    transitionIn: Field<DivAppearanceTransitionTemplate>? = nil,
    transitionOut: Field<DivAppearanceTransitionTemplate>? = nil,
    transitionTriggers: Field<[DivTransitionTrigger]>? = nil,
    visibility: Field<Expression<DivVisibility>>? = nil,
    visibilityAction: Field<DivVisibilityActionTemplate>? = nil,
    visibilityActions: Field<[DivVisibilityActionTemplate]>? = nil,
    width: Field<DivSizeTemplate>? = nil
  ) {
    self.parent = parent
    self.accessibility = accessibility
    self.alignmentHorizontal = alignmentHorizontal
    self.alignmentVertical = alignmentVertical
    self.alpha = alpha
    self.background = background
    self.border = border
    self.columnSpan = columnSpan
    self.defaultStateId = defaultStateId
    self.divId = divId
    self.extensions = extensions
    self.focus = focus
    self.height = height
    self.id = id
    self.margins = margins
    self.paddings = paddings
    self.rowSpan = rowSpan
    self.selectedActions = selectedActions
    self.states = states
    self.tooltips = tooltips
    self.transform = transform
    self.transitionAnimationSelector = transitionAnimationSelector
    self.transitionChange = transitionChange
    self.transitionIn = transitionIn
    self.transitionOut = transitionOut
    self.transitionTriggers = transitionTriggers
    self.visibility = visibility
    self.visibilityAction = visibilityAction
    self.visibilityActions = visibilityActions
    self.width = width
  }

  private static func resolveOnlyLinks(context: Context, parent: DivStateTemplate?) -> DeserializationResult<DivState> {
    let accessibilityValue = parent?.accessibility?.resolveOptionalValue(context: context, validator: ResolvedValue.accessibilityValidator, useOnlyLinks: true) ?? .noValue
    let alignmentHorizontalValue = parent?.alignmentHorizontal?.resolveOptionalValue(context: context, validator: ResolvedValue.alignmentHorizontalValidator) ?? .noValue
    let alignmentVerticalValue = parent?.alignmentVertical?.resolveOptionalValue(context: context, validator: ResolvedValue.alignmentVerticalValidator) ?? .noValue
    let alphaValue = parent?.alpha?.resolveOptionalValue(context: context, validator: ResolvedValue.alphaValidator) ?? .noValue
    let backgroundValue = parent?.background?.resolveOptionalValue(context: context, validator: ResolvedValue.backgroundValidator, useOnlyLinks: true) ?? .noValue
    let borderValue = parent?.border?.resolveOptionalValue(context: context, validator: ResolvedValue.borderValidator, useOnlyLinks: true) ?? .noValue
    let columnSpanValue = parent?.columnSpan?.resolveOptionalValue(context: context, validator: ResolvedValue.columnSpanValidator) ?? .noValue
    let defaultStateIdValue = parent?.defaultStateId?.resolveOptionalValue(context: context, validator: ResolvedValue.defaultStateIdValidator) ?? .noValue
    let divIdValue = parent?.divId?.resolveOptionalValue(context: context, validator: ResolvedValue.divIdValidator) ?? .noValue
    let extensionsValue = parent?.extensions?.resolveOptionalValue(context: context, validator: ResolvedValue.extensionsValidator, useOnlyLinks: true) ?? .noValue
    let focusValue = parent?.focus?.resolveOptionalValue(context: context, validator: ResolvedValue.focusValidator, useOnlyLinks: true) ?? .noValue
    let heightValue = parent?.height?.resolveOptionalValue(context: context, validator: ResolvedValue.heightValidator, useOnlyLinks: true) ?? .noValue
    let idValue = parent?.id?.resolveOptionalValue(context: context, validator: ResolvedValue.idValidator) ?? .noValue
    let marginsValue = parent?.margins?.resolveOptionalValue(context: context, validator: ResolvedValue.marginsValidator, useOnlyLinks: true) ?? .noValue
    let paddingsValue = parent?.paddings?.resolveOptionalValue(context: context, validator: ResolvedValue.paddingsValidator, useOnlyLinks: true) ?? .noValue
    let rowSpanValue = parent?.rowSpan?.resolveOptionalValue(context: context, validator: ResolvedValue.rowSpanValidator) ?? .noValue
    let selectedActionsValue = parent?.selectedActions?.resolveOptionalValue(context: context, validator: ResolvedValue.selectedActionsValidator, useOnlyLinks: true) ?? .noValue
    let statesValue = parent?.states?.resolveValue(context: context, validator: ResolvedValue.statesValidator, useOnlyLinks: true) ?? .noValue
    let tooltipsValue = parent?.tooltips?.resolveOptionalValue(context: context, validator: ResolvedValue.tooltipsValidator, useOnlyLinks: true) ?? .noValue
    let transformValue = parent?.transform?.resolveOptionalValue(context: context, validator: ResolvedValue.transformValidator, useOnlyLinks: true) ?? .noValue
    let transitionAnimationSelectorValue = parent?.transitionAnimationSelector?.resolveOptionalValue(context: context, validator: ResolvedValue.transitionAnimationSelectorValidator) ?? .noValue
    let transitionChangeValue = parent?.transitionChange?.resolveOptionalValue(context: context, validator: ResolvedValue.transitionChangeValidator, useOnlyLinks: true) ?? .noValue
    let transitionInValue = parent?.transitionIn?.resolveOptionalValue(context: context, validator: ResolvedValue.transitionInValidator, useOnlyLinks: true) ?? .noValue
    let transitionOutValue = parent?.transitionOut?.resolveOptionalValue(context: context, validator: ResolvedValue.transitionOutValidator, useOnlyLinks: true) ?? .noValue
    let transitionTriggersValue = parent?.transitionTriggers?.resolveOptionalValue(context: context, validator: ResolvedValue.transitionTriggersValidator) ?? .noValue
    let visibilityValue = parent?.visibility?.resolveOptionalValue(context: context, validator: ResolvedValue.visibilityValidator) ?? .noValue
    let visibilityActionValue = parent?.visibilityAction?.resolveOptionalValue(context: context, validator: ResolvedValue.visibilityActionValidator, useOnlyLinks: true) ?? .noValue
    let visibilityActionsValue = parent?.visibilityActions?.resolveOptionalValue(context: context, validator: ResolvedValue.visibilityActionsValidator, useOnlyLinks: true) ?? .noValue
    let widthValue = parent?.width?.resolveOptionalValue(context: context, validator: ResolvedValue.widthValidator, useOnlyLinks: true) ?? .noValue
    var errors = mergeErrors(
      accessibilityValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "accessibility", level: .warning)) },
      alignmentHorizontalValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "alignment_horizontal", level: .warning)) },
      alignmentVerticalValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "alignment_vertical", level: .warning)) },
      alphaValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "alpha", level: .warning)) },
      backgroundValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "background", level: .warning)) },
      borderValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "border", level: .warning)) },
      columnSpanValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "column_span", level: .warning)) },
      defaultStateIdValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "default_state_id", level: .warning)) },
      divIdValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "div_id", level: .warning)) },
      extensionsValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "extensions", level: .warning)) },
      focusValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "focus", level: .warning)) },
      heightValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "height", level: .warning)) },
      idValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "id", level: .warning)) },
      marginsValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "margins", level: .warning)) },
      paddingsValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "paddings", level: .warning)) },
      rowSpanValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "row_span", level: .warning)) },
      selectedActionsValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "selected_actions", level: .warning)) },
      statesValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "states", level: .error)) },
      tooltipsValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "tooltips", level: .warning)) },
      transformValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "transform", level: .warning)) },
      transitionAnimationSelectorValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "transition_animation_selector", level: .warning)) },
      transitionChangeValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "transition_change", level: .warning)) },
      transitionInValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "transition_in", level: .warning)) },
      transitionOutValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "transition_out", level: .warning)) },
      transitionTriggersValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "transition_triggers", level: .warning)) },
      visibilityValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "visibility", level: .warning)) },
      visibilityActionValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "visibility_action", level: .warning)) },
      visibilityActionsValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "visibility_actions", level: .warning)) },
      widthValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "width", level: .warning)) }
    )
    if case .noValue = statesValue {
      errors.append(.right(FieldError(fieldName: "states", level: .error, error: .requiredFieldIsMissing)))
    }
    guard
      let statesNonNil = statesValue.value
    else {
      return .failure(NonEmptyArray(errors)!)
    }
    let result = DivState(
      accessibility: accessibilityValue.value,
      alignmentHorizontal: alignmentHorizontalValue.value,
      alignmentVertical: alignmentVerticalValue.value,
      alpha: alphaValue.value,
      background: backgroundValue.value,
      border: borderValue.value,
      columnSpan: columnSpanValue.value,
      defaultStateId: defaultStateIdValue.value,
      divId: divIdValue.value,
      extensions: extensionsValue.value,
      focus: focusValue.value,
      height: heightValue.value,
      id: idValue.value,
      margins: marginsValue.value,
      paddings: paddingsValue.value,
      rowSpan: rowSpanValue.value,
      selectedActions: selectedActionsValue.value,
      states: statesNonNil,
      tooltips: tooltipsValue.value,
      transform: transformValue.value,
      transitionAnimationSelector: transitionAnimationSelectorValue.value,
      transitionChange: transitionChangeValue.value,
      transitionIn: transitionInValue.value,
      transitionOut: transitionOutValue.value,
      transitionTriggers: transitionTriggersValue.value,
      visibility: visibilityValue.value,
      visibilityAction: visibilityActionValue.value,
      visibilityActions: visibilityActionsValue.value,
      width: widthValue.value
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  public static func resolveValue(context: Context, parent: DivStateTemplate?, useOnlyLinks: Bool) -> DeserializationResult<DivState> {
    if useOnlyLinks {
      return resolveOnlyLinks(context: context, parent: parent)
    }
    var accessibilityValue: DeserializationResult<DivAccessibility> = .noValue
    var alignmentHorizontalValue: DeserializationResult<Expression<DivAlignmentHorizontal>> = parent?.alignmentHorizontal?.value() ?? .noValue
    var alignmentVerticalValue: DeserializationResult<Expression<DivAlignmentVertical>> = parent?.alignmentVertical?.value() ?? .noValue
    var alphaValue: DeserializationResult<Expression<Double>> = parent?.alpha?.value() ?? .noValue
    var backgroundValue: DeserializationResult<[DivBackground]> = .noValue
    var borderValue: DeserializationResult<DivBorder> = .noValue
    var columnSpanValue: DeserializationResult<Expression<Int>> = parent?.columnSpan?.value() ?? .noValue
    var defaultStateIdValue: DeserializationResult<Expression<String>> = parent?.defaultStateId?.value() ?? .noValue
    var divIdValue: DeserializationResult<String> = parent?.divId?.value(validatedBy: ResolvedValue.divIdValidator) ?? .noValue
    var extensionsValue: DeserializationResult<[DivExtension]> = .noValue
    var focusValue: DeserializationResult<DivFocus> = .noValue
    var heightValue: DeserializationResult<DivSize> = .noValue
    var idValue: DeserializationResult<String> = parent?.id?.value(validatedBy: ResolvedValue.idValidator) ?? .noValue
    var marginsValue: DeserializationResult<DivEdgeInsets> = .noValue
    var paddingsValue: DeserializationResult<DivEdgeInsets> = .noValue
    var rowSpanValue: DeserializationResult<Expression<Int>> = parent?.rowSpan?.value() ?? .noValue
    var selectedActionsValue: DeserializationResult<[DivAction]> = .noValue
    var statesValue: DeserializationResult<[DivState.State]> = .noValue
    var tooltipsValue: DeserializationResult<[DivTooltip]> = .noValue
    var transformValue: DeserializationResult<DivTransform> = .noValue
    var transitionAnimationSelectorValue: DeserializationResult<Expression<DivTransitionSelector>> = parent?.transitionAnimationSelector?.value() ?? .noValue
    var transitionChangeValue: DeserializationResult<DivChangeTransition> = .noValue
    var transitionInValue: DeserializationResult<DivAppearanceTransition> = .noValue
    var transitionOutValue: DeserializationResult<DivAppearanceTransition> = .noValue
    var transitionTriggersValue: DeserializationResult<[DivTransitionTrigger]> = parent?.transitionTriggers?.value(validatedBy: ResolvedValue.transitionTriggersValidator) ?? .noValue
    var visibilityValue: DeserializationResult<Expression<DivVisibility>> = parent?.visibility?.value() ?? .noValue
    var visibilityActionValue: DeserializationResult<DivVisibilityAction> = .noValue
    var visibilityActionsValue: DeserializationResult<[DivVisibilityAction]> = .noValue
    var widthValue: DeserializationResult<DivSize> = .noValue
    context.templateData.forEach { key, __dictValue in
      switch key {
      case "accessibility":
        accessibilityValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.accessibilityValidator, type: DivAccessibilityTemplate.self).merged(with: accessibilityValue)
      case "alignment_horizontal":
        alignmentHorizontalValue = deserialize(__dictValue, validator: ResolvedValue.alignmentHorizontalValidator).merged(with: alignmentHorizontalValue)
      case "alignment_vertical":
        alignmentVerticalValue = deserialize(__dictValue, validator: ResolvedValue.alignmentVerticalValidator).merged(with: alignmentVerticalValue)
      case "alpha":
        alphaValue = deserialize(__dictValue, validator: ResolvedValue.alphaValidator).merged(with: alphaValue)
      case "background":
        backgroundValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.backgroundValidator, type: DivBackgroundTemplate.self).merged(with: backgroundValue)
      case "border":
        borderValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.borderValidator, type: DivBorderTemplate.self).merged(with: borderValue)
      case "column_span":
        columnSpanValue = deserialize(__dictValue, validator: ResolvedValue.columnSpanValidator).merged(with: columnSpanValue)
      case "default_state_id":
        defaultStateIdValue = deserialize(__dictValue, validator: ResolvedValue.defaultStateIdValidator).merged(with: defaultStateIdValue)
      case "div_id":
        divIdValue = deserialize(__dictValue, validator: ResolvedValue.divIdValidator).merged(with: divIdValue)
      case "extensions":
        extensionsValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.extensionsValidator, type: DivExtensionTemplate.self).merged(with: extensionsValue)
      case "focus":
        focusValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.focusValidator, type: DivFocusTemplate.self).merged(with: focusValue)
      case "height":
        heightValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.heightValidator, type: DivSizeTemplate.self).merged(with: heightValue)
      case "id":
        idValue = deserialize(__dictValue, validator: ResolvedValue.idValidator).merged(with: idValue)
      case "margins":
        marginsValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.marginsValidator, type: DivEdgeInsetsTemplate.self).merged(with: marginsValue)
      case "paddings":
        paddingsValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.paddingsValidator, type: DivEdgeInsetsTemplate.self).merged(with: paddingsValue)
      case "row_span":
        rowSpanValue = deserialize(__dictValue, validator: ResolvedValue.rowSpanValidator).merged(with: rowSpanValue)
      case "selected_actions":
        selectedActionsValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.selectedActionsValidator, type: DivActionTemplate.self).merged(with: selectedActionsValue)
      case "states":
        statesValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.statesValidator, type: DivStateTemplate.StateTemplate.self).merged(with: statesValue)
      case "tooltips":
        tooltipsValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.tooltipsValidator, type: DivTooltipTemplate.self).merged(with: tooltipsValue)
      case "transform":
        transformValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.transformValidator, type: DivTransformTemplate.self).merged(with: transformValue)
      case "transition_animation_selector":
        transitionAnimationSelectorValue = deserialize(__dictValue, validator: ResolvedValue.transitionAnimationSelectorValidator).merged(with: transitionAnimationSelectorValue)
      case "transition_change":
        transitionChangeValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.transitionChangeValidator, type: DivChangeTransitionTemplate.self).merged(with: transitionChangeValue)
      case "transition_in":
        transitionInValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.transitionInValidator, type: DivAppearanceTransitionTemplate.self).merged(with: transitionInValue)
      case "transition_out":
        transitionOutValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.transitionOutValidator, type: DivAppearanceTransitionTemplate.self).merged(with: transitionOutValue)
      case "transition_triggers":
        transitionTriggersValue = deserialize(__dictValue, validator: ResolvedValue.transitionTriggersValidator).merged(with: transitionTriggersValue)
      case "visibility":
        visibilityValue = deserialize(__dictValue, validator: ResolvedValue.visibilityValidator).merged(with: visibilityValue)
      case "visibility_action":
        visibilityActionValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.visibilityActionValidator, type: DivVisibilityActionTemplate.self).merged(with: visibilityActionValue)
      case "visibility_actions":
        visibilityActionsValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.visibilityActionsValidator, type: DivVisibilityActionTemplate.self).merged(with: visibilityActionsValue)
      case "width":
        widthValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.widthValidator, type: DivSizeTemplate.self).merged(with: widthValue)
      case parent?.accessibility?.link:
        accessibilityValue = accessibilityValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.accessibilityValidator, type: DivAccessibilityTemplate.self))
      case parent?.alignmentHorizontal?.link:
        alignmentHorizontalValue = alignmentHorizontalValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.alignmentHorizontalValidator))
      case parent?.alignmentVertical?.link:
        alignmentVerticalValue = alignmentVerticalValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.alignmentVerticalValidator))
      case parent?.alpha?.link:
        alphaValue = alphaValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.alphaValidator))
      case parent?.background?.link:
        backgroundValue = backgroundValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.backgroundValidator, type: DivBackgroundTemplate.self))
      case parent?.border?.link:
        borderValue = borderValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.borderValidator, type: DivBorderTemplate.self))
      case parent?.columnSpan?.link:
        columnSpanValue = columnSpanValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.columnSpanValidator))
      case parent?.defaultStateId?.link:
        defaultStateIdValue = defaultStateIdValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.defaultStateIdValidator))
      case parent?.divId?.link:
        divIdValue = divIdValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.divIdValidator))
      case parent?.extensions?.link:
        extensionsValue = extensionsValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.extensionsValidator, type: DivExtensionTemplate.self))
      case parent?.focus?.link:
        focusValue = focusValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.focusValidator, type: DivFocusTemplate.self))
      case parent?.height?.link:
        heightValue = heightValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.heightValidator, type: DivSizeTemplate.self))
      case parent?.id?.link:
        idValue = idValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.idValidator))
      case parent?.margins?.link:
        marginsValue = marginsValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.marginsValidator, type: DivEdgeInsetsTemplate.self))
      case parent?.paddings?.link:
        paddingsValue = paddingsValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.paddingsValidator, type: DivEdgeInsetsTemplate.self))
      case parent?.rowSpan?.link:
        rowSpanValue = rowSpanValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.rowSpanValidator))
      case parent?.selectedActions?.link:
        selectedActionsValue = selectedActionsValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.selectedActionsValidator, type: DivActionTemplate.self))
      case parent?.states?.link:
        statesValue = statesValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.statesValidator, type: DivStateTemplate.StateTemplate.self))
      case parent?.tooltips?.link:
        tooltipsValue = tooltipsValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.tooltipsValidator, type: DivTooltipTemplate.self))
      case parent?.transform?.link:
        transformValue = transformValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.transformValidator, type: DivTransformTemplate.self))
      case parent?.transitionAnimationSelector?.link:
        transitionAnimationSelectorValue = transitionAnimationSelectorValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.transitionAnimationSelectorValidator))
      case parent?.transitionChange?.link:
        transitionChangeValue = transitionChangeValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.transitionChangeValidator, type: DivChangeTransitionTemplate.self))
      case parent?.transitionIn?.link:
        transitionInValue = transitionInValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.transitionInValidator, type: DivAppearanceTransitionTemplate.self))
      case parent?.transitionOut?.link:
        transitionOutValue = transitionOutValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.transitionOutValidator, type: DivAppearanceTransitionTemplate.self))
      case parent?.transitionTriggers?.link:
        transitionTriggersValue = transitionTriggersValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.transitionTriggersValidator))
      case parent?.visibility?.link:
        visibilityValue = visibilityValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.visibilityValidator))
      case parent?.visibilityAction?.link:
        visibilityActionValue = visibilityActionValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.visibilityActionValidator, type: DivVisibilityActionTemplate.self))
      case parent?.visibilityActions?.link:
        visibilityActionsValue = visibilityActionsValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.visibilityActionsValidator, type: DivVisibilityActionTemplate.self))
      case parent?.width?.link:
        widthValue = widthValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.widthValidator, type: DivSizeTemplate.self))
      default: break
      }
    }
    if let parent = parent {
      accessibilityValue = accessibilityValue.merged(with: parent.accessibility?.resolveOptionalValue(context: context, validator: ResolvedValue.accessibilityValidator, useOnlyLinks: true))
      backgroundValue = backgroundValue.merged(with: parent.background?.resolveOptionalValue(context: context, validator: ResolvedValue.backgroundValidator, useOnlyLinks: true))
      borderValue = borderValue.merged(with: parent.border?.resolveOptionalValue(context: context, validator: ResolvedValue.borderValidator, useOnlyLinks: true))
      extensionsValue = extensionsValue.merged(with: parent.extensions?.resolveOptionalValue(context: context, validator: ResolvedValue.extensionsValidator, useOnlyLinks: true))
      focusValue = focusValue.merged(with: parent.focus?.resolveOptionalValue(context: context, validator: ResolvedValue.focusValidator, useOnlyLinks: true))
      heightValue = heightValue.merged(with: parent.height?.resolveOptionalValue(context: context, validator: ResolvedValue.heightValidator, useOnlyLinks: true))
      marginsValue = marginsValue.merged(with: parent.margins?.resolveOptionalValue(context: context, validator: ResolvedValue.marginsValidator, useOnlyLinks: true))
      paddingsValue = paddingsValue.merged(with: parent.paddings?.resolveOptionalValue(context: context, validator: ResolvedValue.paddingsValidator, useOnlyLinks: true))
      selectedActionsValue = selectedActionsValue.merged(with: parent.selectedActions?.resolveOptionalValue(context: context, validator: ResolvedValue.selectedActionsValidator, useOnlyLinks: true))
      statesValue = statesValue.merged(with: parent.states?.resolveValue(context: context, validator: ResolvedValue.statesValidator, useOnlyLinks: true))
      tooltipsValue = tooltipsValue.merged(with: parent.tooltips?.resolveOptionalValue(context: context, validator: ResolvedValue.tooltipsValidator, useOnlyLinks: true))
      transformValue = transformValue.merged(with: parent.transform?.resolveOptionalValue(context: context, validator: ResolvedValue.transformValidator, useOnlyLinks: true))
      transitionChangeValue = transitionChangeValue.merged(with: parent.transitionChange?.resolveOptionalValue(context: context, validator: ResolvedValue.transitionChangeValidator, useOnlyLinks: true))
      transitionInValue = transitionInValue.merged(with: parent.transitionIn?.resolveOptionalValue(context: context, validator: ResolvedValue.transitionInValidator, useOnlyLinks: true))
      transitionOutValue = transitionOutValue.merged(with: parent.transitionOut?.resolveOptionalValue(context: context, validator: ResolvedValue.transitionOutValidator, useOnlyLinks: true))
      visibilityActionValue = visibilityActionValue.merged(with: parent.visibilityAction?.resolveOptionalValue(context: context, validator: ResolvedValue.visibilityActionValidator, useOnlyLinks: true))
      visibilityActionsValue = visibilityActionsValue.merged(with: parent.visibilityActions?.resolveOptionalValue(context: context, validator: ResolvedValue.visibilityActionsValidator, useOnlyLinks: true))
      widthValue = widthValue.merged(with: parent.width?.resolveOptionalValue(context: context, validator: ResolvedValue.widthValidator, useOnlyLinks: true))
    }
    var errors = mergeErrors(
      accessibilityValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "accessibility", level: .warning)) },
      alignmentHorizontalValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "alignment_horizontal", level: .warning)) },
      alignmentVerticalValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "alignment_vertical", level: .warning)) },
      alphaValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "alpha", level: .warning)) },
      backgroundValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "background", level: .warning)) },
      borderValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "border", level: .warning)) },
      columnSpanValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "column_span", level: .warning)) },
      defaultStateIdValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "default_state_id", level: .warning)) },
      divIdValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "div_id", level: .warning)) },
      extensionsValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "extensions", level: .warning)) },
      focusValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "focus", level: .warning)) },
      heightValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "height", level: .warning)) },
      idValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "id", level: .warning)) },
      marginsValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "margins", level: .warning)) },
      paddingsValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "paddings", level: .warning)) },
      rowSpanValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "row_span", level: .warning)) },
      selectedActionsValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "selected_actions", level: .warning)) },
      statesValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "states", level: .error)) },
      tooltipsValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "tooltips", level: .warning)) },
      transformValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "transform", level: .warning)) },
      transitionAnimationSelectorValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "transition_animation_selector", level: .warning)) },
      transitionChangeValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "transition_change", level: .warning)) },
      transitionInValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "transition_in", level: .warning)) },
      transitionOutValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "transition_out", level: .warning)) },
      transitionTriggersValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "transition_triggers", level: .warning)) },
      visibilityValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "visibility", level: .warning)) },
      visibilityActionValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "visibility_action", level: .warning)) },
      visibilityActionsValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "visibility_actions", level: .warning)) },
      widthValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "width", level: .warning)) }
    )
    if case .noValue = statesValue {
      errors.append(.right(FieldError(fieldName: "states", level: .error, error: .requiredFieldIsMissing)))
    }
    guard
      let statesNonNil = statesValue.value
    else {
      return .failure(NonEmptyArray(errors)!)
    }
    let result = DivState(
      accessibility: accessibilityValue.value,
      alignmentHorizontal: alignmentHorizontalValue.value,
      alignmentVertical: alignmentVerticalValue.value,
      alpha: alphaValue.value,
      background: backgroundValue.value,
      border: borderValue.value,
      columnSpan: columnSpanValue.value,
      defaultStateId: defaultStateIdValue.value,
      divId: divIdValue.value,
      extensions: extensionsValue.value,
      focus: focusValue.value,
      height: heightValue.value,
      id: idValue.value,
      margins: marginsValue.value,
      paddings: paddingsValue.value,
      rowSpan: rowSpanValue.value,
      selectedActions: selectedActionsValue.value,
      states: statesNonNil,
      tooltips: tooltipsValue.value,
      transform: transformValue.value,
      transitionAnimationSelector: transitionAnimationSelectorValue.value,
      transitionChange: transitionChangeValue.value,
      transitionIn: transitionInValue.value,
      transitionOut: transitionOutValue.value,
      transitionTriggers: transitionTriggersValue.value,
      visibility: visibilityValue.value,
      visibilityAction: visibilityActionValue.value,
      visibilityActions: visibilityActionsValue.value,
      width: widthValue.value
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  private func mergedWithParent(templates: Templates) throws -> DivStateTemplate {
    guard let parent = parent, parent != Self.type else { return self }
    guard let parentTemplate = templates[parent] as? DivStateTemplate else {
      throw DeserializationError.unknownType(type: parent)
    }
    let mergedParent = try parentTemplate.mergedWithParent(templates: templates)

    return DivStateTemplate(
      parent: nil,
      accessibility: accessibility ?? mergedParent.accessibility,
      alignmentHorizontal: alignmentHorizontal ?? mergedParent.alignmentHorizontal,
      alignmentVertical: alignmentVertical ?? mergedParent.alignmentVertical,
      alpha: alpha ?? mergedParent.alpha,
      background: background ?? mergedParent.background,
      border: border ?? mergedParent.border,
      columnSpan: columnSpan ?? mergedParent.columnSpan,
      defaultStateId: defaultStateId ?? mergedParent.defaultStateId,
      divId: divId ?? mergedParent.divId,
      extensions: extensions ?? mergedParent.extensions,
      focus: focus ?? mergedParent.focus,
      height: height ?? mergedParent.height,
      id: id ?? mergedParent.id,
      margins: margins ?? mergedParent.margins,
      paddings: paddings ?? mergedParent.paddings,
      rowSpan: rowSpan ?? mergedParent.rowSpan,
      selectedActions: selectedActions ?? mergedParent.selectedActions,
      states: states ?? mergedParent.states,
      tooltips: tooltips ?? mergedParent.tooltips,
      transform: transform ?? mergedParent.transform,
      transitionAnimationSelector: transitionAnimationSelector ?? mergedParent.transitionAnimationSelector,
      transitionChange: transitionChange ?? mergedParent.transitionChange,
      transitionIn: transitionIn ?? mergedParent.transitionIn,
      transitionOut: transitionOut ?? mergedParent.transitionOut,
      transitionTriggers: transitionTriggers ?? mergedParent.transitionTriggers,
      visibility: visibility ?? mergedParent.visibility,
      visibilityAction: visibilityAction ?? mergedParent.visibilityAction,
      visibilityActions: visibilityActions ?? mergedParent.visibilityActions,
      width: width ?? mergedParent.width
    )
  }

  public func resolveParent(templates: Templates) throws -> DivStateTemplate {
    let merged = try mergedWithParent(templates: templates)

    return DivStateTemplate(
      parent: nil,
      accessibility: merged.accessibility?.tryResolveParent(templates: templates),
      alignmentHorizontal: merged.alignmentHorizontal,
      alignmentVertical: merged.alignmentVertical,
      alpha: merged.alpha,
      background: merged.background?.tryResolveParent(templates: templates),
      border: merged.border?.tryResolveParent(templates: templates),
      columnSpan: merged.columnSpan,
      defaultStateId: merged.defaultStateId,
      divId: merged.divId,
      extensions: merged.extensions?.tryResolveParent(templates: templates),
      focus: merged.focus?.tryResolveParent(templates: templates),
      height: merged.height?.tryResolveParent(templates: templates),
      id: merged.id,
      margins: merged.margins?.tryResolveParent(templates: templates),
      paddings: merged.paddings?.tryResolveParent(templates: templates),
      rowSpan: merged.rowSpan,
      selectedActions: merged.selectedActions?.tryResolveParent(templates: templates),
      states: try merged.states?.resolveParent(templates: templates),
      tooltips: merged.tooltips?.tryResolveParent(templates: templates),
      transform: merged.transform?.tryResolveParent(templates: templates),
      transitionAnimationSelector: merged.transitionAnimationSelector,
      transitionChange: merged.transitionChange?.tryResolveParent(templates: templates),
      transitionIn: merged.transitionIn?.tryResolveParent(templates: templates),
      transitionOut: merged.transitionOut?.tryResolveParent(templates: templates),
      transitionTriggers: merged.transitionTriggers,
      visibility: merged.visibility,
      visibilityAction: merged.visibilityAction?.tryResolveParent(templates: templates),
      visibilityActions: merged.visibilityActions?.tryResolveParent(templates: templates),
      width: merged.width?.tryResolveParent(templates: templates)
    )
  }
}
