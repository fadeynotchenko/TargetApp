// Generated code. Do not modify.

import CommonCore
import Foundation
import Serialization
import TemplatesSupport

public final class DivDataTemplate: TemplateValue, TemplateDeserializable {
  public final class StateTemplate: TemplateValue, TemplateDeserializable {
    public let div: Field<DivTemplate>?
    public let stateId: Field<Int>?

    public convenience init(dictionary: [String: Any], templateToType: TemplateToType) throws {
      do {
        self.init(
          div: try dictionary.getOptionalField("div", templateToType: templateToType),
          stateId: try dictionary.getOptionalField("state_id")
        )
      } catch let DeserializationError.invalidFieldRepresentation(field: field, representation: representation) {
        throw DeserializationError.invalidFieldRepresentation(field: "state_template." + field, representation: representation)
      }
    }

    init(
      div: Field<DivTemplate>? = nil,
      stateId: Field<Int>? = nil
    ) {
      self.div = div
      self.stateId = stateId
    }

    private static func resolveOnlyLinks(context: Context, parent: StateTemplate?) -> DeserializationResult<DivData.State> {
      let divValue = parent?.div?.resolveValue(context: context, useOnlyLinks: true) ?? .noValue
      let stateIdValue = parent?.stateId?.resolveValue(context: context) ?? .noValue
      var errors = mergeErrors(
        divValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "div", level: .error)) },
        stateIdValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "state_id", level: .error)) }
      )
      if case .noValue = divValue {
        errors.append(.right(FieldError(fieldName: "div", level: .error, error: .requiredFieldIsMissing)))
      }
      if case .noValue = stateIdValue {
        errors.append(.right(FieldError(fieldName: "state_id", level: .error, error: .requiredFieldIsMissing)))
      }
      guard
        let divNonNil = divValue.value,
        let stateIdNonNil = stateIdValue.value
      else {
        return .failure(NonEmptyArray(errors)!)
      }
      let result = DivData.State(
        div: divNonNil,
        stateId: stateIdNonNil
      )
      return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
    }

    public static func resolveValue(context: Context, parent: StateTemplate?, useOnlyLinks: Bool) -> DeserializationResult<DivData.State> {
      if useOnlyLinks {
        return resolveOnlyLinks(context: context, parent: parent)
      }
      var divValue: DeserializationResult<Div> = .noValue
      var stateIdValue: DeserializationResult<Int> = parent?.stateId?.value() ?? .noValue
      context.templateData.forEach { key, __dictValue in
        switch key {
        case "div":
          divValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, type: DivTemplate.self).merged(with: divValue)
        case "state_id":
          stateIdValue = deserialize(__dictValue).merged(with: stateIdValue)
        case parent?.div?.link:
          divValue = divValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, type: DivTemplate.self))
        case parent?.stateId?.link:
          stateIdValue = stateIdValue.merged(with: deserialize(__dictValue))
        default: break
        }
      }
      if let parent = parent {
        divValue = divValue.merged(with: parent.div?.resolveValue(context: context, useOnlyLinks: true))
      }
      var errors = mergeErrors(
        divValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "div", level: .error)) },
        stateIdValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "state_id", level: .error)) }
      )
      if case .noValue = divValue {
        errors.append(.right(FieldError(fieldName: "div", level: .error, error: .requiredFieldIsMissing)))
      }
      if case .noValue = stateIdValue {
        errors.append(.right(FieldError(fieldName: "state_id", level: .error, error: .requiredFieldIsMissing)))
      }
      guard
        let divNonNil = divValue.value,
        let stateIdNonNil = stateIdValue.value
      else {
        return .failure(NonEmptyArray(errors)!)
      }
      let result = DivData.State(
        div: divNonNil,
        stateId: stateIdNonNil
      )
      return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
    }

    private func mergedWithParent(templates: Templates) throws -> StateTemplate {
      return self
    }

    public func resolveParent(templates: Templates) throws -> StateTemplate {
      let merged = try mergedWithParent(templates: templates)

      return StateTemplate(
        div: try merged.div?.resolveParent(templates: templates),
        stateId: merged.stateId
      )
    }
  }

  public let logId: Field<String>? // at least 1 char
  public let states: Field<[StateTemplate]>? // at least 1 elements; all received elements must be valid
  public let transitionAnimationSelector: Field<Expression<DivTransitionSelector>>? // default value: none
  public let variableTriggers: Field<[DivTriggerTemplate]>? // at least 1 elements
  public let variables: Field<[DivVariableTemplate]>? // at least 1 elements

  static let statesValidator: AnyArrayValueValidator<DivDataTemplate.StateTemplate> =
    makeStrictArrayValidator(minItems: 1)

  public convenience init(dictionary: [String: Any], templateToType: TemplateToType) throws {
    do {
      self.init(
        logId: try dictionary.getOptionalField("log_id"),
        states: try dictionary.getOptionalArray("states", templateToType: templateToType, validator: Self.statesValidator),
        transitionAnimationSelector: try dictionary.getOptionalExpressionField("transition_animation_selector"),
        variableTriggers: try dictionary.getOptionalArray("variable_triggers", templateToType: templateToType),
        variables: try dictionary.getOptionalArray("variables", templateToType: templateToType)
      )
    } catch let DeserializationError.invalidFieldRepresentation(field: field, representation: representation) {
      throw DeserializationError.invalidFieldRepresentation(field: "div-data_template." + field, representation: representation)
    }
  }

  init(
    logId: Field<String>? = nil,
    states: Field<[StateTemplate]>? = nil,
    transitionAnimationSelector: Field<Expression<DivTransitionSelector>>? = nil,
    variableTriggers: Field<[DivTriggerTemplate]>? = nil,
    variables: Field<[DivVariableTemplate]>? = nil
  ) {
    self.logId = logId
    self.states = states
    self.transitionAnimationSelector = transitionAnimationSelector
    self.variableTriggers = variableTriggers
    self.variables = variables
  }

  private static func resolveOnlyLinks(context: Context, parent: DivDataTemplate?) -> DeserializationResult<DivData> {
    let logIdValue = parent?.logId?.resolveValue(context: context, validator: ResolvedValue.logIdValidator) ?? .noValue
    let statesValue = parent?.states?.resolveValue(context: context, validator: ResolvedValue.statesValidator, useOnlyLinks: true) ?? .noValue
    let transitionAnimationSelectorValue = parent?.transitionAnimationSelector?.resolveOptionalValue(context: context, validator: ResolvedValue.transitionAnimationSelectorValidator) ?? .noValue
    let variableTriggersValue = parent?.variableTriggers?.resolveOptionalValue(context: context, validator: ResolvedValue.variableTriggersValidator, useOnlyLinks: true) ?? .noValue
    let variablesValue = parent?.variables?.resolveOptionalValue(context: context, validator: ResolvedValue.variablesValidator, useOnlyLinks: true) ?? .noValue
    var errors = mergeErrors(
      logIdValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "log_id", level: .error)) },
      statesValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "states", level: .error)) },
      transitionAnimationSelectorValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "transition_animation_selector", level: .warning)) },
      variableTriggersValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "variable_triggers", level: .warning)) },
      variablesValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "variables", level: .warning)) }
    )
    if case .noValue = logIdValue {
      errors.append(.right(FieldError(fieldName: "log_id", level: .error, error: .requiredFieldIsMissing)))
    }
    if case .noValue = statesValue {
      errors.append(.right(FieldError(fieldName: "states", level: .error, error: .requiredFieldIsMissing)))
    }
    guard
      let logIdNonNil = logIdValue.value,
      let statesNonNil = statesValue.value
    else {
      return .failure(NonEmptyArray(errors)!)
    }
    let result = DivData(
      logId: logIdNonNil,
      states: statesNonNil,
      transitionAnimationSelector: transitionAnimationSelectorValue.value,
      variableTriggers: variableTriggersValue.value,
      variables: variablesValue.value
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  public static func resolveValue(context: Context, parent: DivDataTemplate?, useOnlyLinks: Bool) -> DeserializationResult<DivData> {
    if useOnlyLinks {
      return resolveOnlyLinks(context: context, parent: parent)
    }
    var logIdValue: DeserializationResult<String> = parent?.logId?.value(validatedBy: ResolvedValue.logIdValidator) ?? .noValue
    var statesValue: DeserializationResult<[DivData.State]> = .noValue
    var transitionAnimationSelectorValue: DeserializationResult<Expression<DivTransitionSelector>> = parent?.transitionAnimationSelector?.value() ?? .noValue
    var variableTriggersValue: DeserializationResult<[DivTrigger]> = .noValue
    var variablesValue: DeserializationResult<[DivVariable]> = .noValue
    context.templateData.forEach { key, __dictValue in
      switch key {
      case "log_id":
        logIdValue = deserialize(__dictValue, validator: ResolvedValue.logIdValidator).merged(with: logIdValue)
      case "states":
        statesValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.statesValidator, type: DivDataTemplate.StateTemplate.self).merged(with: statesValue)
      case "transition_animation_selector":
        transitionAnimationSelectorValue = deserialize(__dictValue, validator: ResolvedValue.transitionAnimationSelectorValidator).merged(with: transitionAnimationSelectorValue)
      case "variable_triggers":
        variableTriggersValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.variableTriggersValidator, type: DivTriggerTemplate.self).merged(with: variableTriggersValue)
      case "variables":
        variablesValue = deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.variablesValidator, type: DivVariableTemplate.self).merged(with: variablesValue)
      case parent?.logId?.link:
        logIdValue = logIdValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.logIdValidator))
      case parent?.states?.link:
        statesValue = statesValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.statesValidator, type: DivDataTemplate.StateTemplate.self))
      case parent?.transitionAnimationSelector?.link:
        transitionAnimationSelectorValue = transitionAnimationSelectorValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.transitionAnimationSelectorValidator))
      case parent?.variableTriggers?.link:
        variableTriggersValue = variableTriggersValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.variableTriggersValidator, type: DivTriggerTemplate.self))
      case parent?.variables?.link:
        variablesValue = variablesValue.merged(with: deserialize(__dictValue, templates: context.templates, templateToType: context.templateToType, validator: ResolvedValue.variablesValidator, type: DivVariableTemplate.self))
      default: break
      }
    }
    if let parent = parent {
      statesValue = statesValue.merged(with: parent.states?.resolveValue(context: context, validator: ResolvedValue.statesValidator, useOnlyLinks: true))
      variableTriggersValue = variableTriggersValue.merged(with: parent.variableTriggers?.resolveOptionalValue(context: context, validator: ResolvedValue.variableTriggersValidator, useOnlyLinks: true))
      variablesValue = variablesValue.merged(with: parent.variables?.resolveOptionalValue(context: context, validator: ResolvedValue.variablesValidator, useOnlyLinks: true))
    }
    var errors = mergeErrors(
      logIdValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "log_id", level: .error)) },
      statesValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "states", level: .error)) },
      transitionAnimationSelectorValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "transition_animation_selector", level: .warning)) },
      variableTriggersValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "variable_triggers", level: .warning)) },
      variablesValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "variables", level: .warning)) }
    )
    if case .noValue = logIdValue {
      errors.append(.right(FieldError(fieldName: "log_id", level: .error, error: .requiredFieldIsMissing)))
    }
    if case .noValue = statesValue {
      errors.append(.right(FieldError(fieldName: "states", level: .error, error: .requiredFieldIsMissing)))
    }
    guard
      let logIdNonNil = logIdValue.value,
      let statesNonNil = statesValue.value
    else {
      return .failure(NonEmptyArray(errors)!)
    }
    let result = DivData(
      logId: logIdNonNil,
      states: statesNonNil,
      transitionAnimationSelector: transitionAnimationSelectorValue.value,
      variableTriggers: variableTriggersValue.value,
      variables: variablesValue.value
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  private func mergedWithParent(templates: Templates) throws -> DivDataTemplate {
    return self
  }

  public func resolveParent(templates: Templates) throws -> DivDataTemplate {
    let merged = try mergedWithParent(templates: templates)

    return DivDataTemplate(
      logId: merged.logId,
      states: try merged.states?.resolveParent(templates: templates, validator: Self.statesValidator),
      transitionAnimationSelector: merged.transitionAnimationSelector,
      variableTriggers: merged.variableTriggers?.tryResolveParent(templates: templates),
      variables: merged.variables?.tryResolveParent(templates: templates)
    )
  }
}
