// Generated code. Do not modify.

import CommonCore
import Foundation
import Serialization
import TemplatesSupport

public final class NumberVariableTemplate: TemplateValue, TemplateDeserializable {
  public static let type: String = "number"
  public let parent: String? // at least 1 char
  public let name: Field<String>? // at least 1 char
  public let value: Field<Double>?

  static let parentValidator: AnyValueValidator<String> =
    makeStringValidator(minLength: 1)

  public convenience init(dictionary: [String: Any], templateToType: TemplateToType) throws {
    do {
      self.init(
        parent: try dictionary.getOptionalField("type", validator: Self.parentValidator),
        name: try dictionary.getOptionalField("name"),
        value: try dictionary.getOptionalField("value")
      )
    } catch let DeserializationError.invalidFieldRepresentation(field: field, representation: representation) {
      throw DeserializationError.invalidFieldRepresentation(field: "number_variable_template." + field, representation: representation)
    }
  }

  init(
    parent: String?,
    name: Field<String>? = nil,
    value: Field<Double>? = nil
  ) {
    self.parent = parent
    self.name = name
    self.value = value
  }

  private static func resolveOnlyLinks(context: Context, parent: NumberVariableTemplate?) -> DeserializationResult<NumberVariable> {
    let nameValue = parent?.name?.resolveValue(context: context, validator: ResolvedValue.nameValidator) ?? .noValue
    let valueValue = parent?.value?.resolveValue(context: context) ?? .noValue
    var errors = mergeErrors(
      nameValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "name", level: .error)) },
      valueValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "value", level: .error)) }
    )
    if case .noValue = nameValue {
      errors.append(.right(FieldError(fieldName: "name", level: .error, error: .requiredFieldIsMissing)))
    }
    if case .noValue = valueValue {
      errors.append(.right(FieldError(fieldName: "value", level: .error, error: .requiredFieldIsMissing)))
    }
    guard
      let nameNonNil = nameValue.value,
      let valueNonNil = valueValue.value
    else {
      return .failure(NonEmptyArray(errors)!)
    }
    let result = NumberVariable(
      name: nameNonNil,
      value: valueNonNil
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  public static func resolveValue(context: Context, parent: NumberVariableTemplate?, useOnlyLinks: Bool) -> DeserializationResult<NumberVariable> {
    if useOnlyLinks {
      return resolveOnlyLinks(context: context, parent: parent)
    }
    var nameValue: DeserializationResult<String> = parent?.name?.value(validatedBy: ResolvedValue.nameValidator) ?? .noValue
    var valueValue: DeserializationResult<Double> = parent?.value?.value() ?? .noValue
    context.templateData.forEach { key, __dictValue in
      switch key {
      case "name":
        nameValue = deserialize(__dictValue, validator: ResolvedValue.nameValidator).merged(with: nameValue)
      case "value":
        valueValue = deserialize(__dictValue).merged(with: valueValue)
      case parent?.name?.link:
        nameValue = nameValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.nameValidator))
      case parent?.value?.link:
        valueValue = valueValue.merged(with: deserialize(__dictValue))
      default: break
      }
    }
    var errors = mergeErrors(
      nameValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "name", level: .error)) },
      valueValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "value", level: .error)) }
    )
    if case .noValue = nameValue {
      errors.append(.right(FieldError(fieldName: "name", level: .error, error: .requiredFieldIsMissing)))
    }
    if case .noValue = valueValue {
      errors.append(.right(FieldError(fieldName: "value", level: .error, error: .requiredFieldIsMissing)))
    }
    guard
      let nameNonNil = nameValue.value,
      let valueNonNil = valueValue.value
    else {
      return .failure(NonEmptyArray(errors)!)
    }
    let result = NumberVariable(
      name: nameNonNil,
      value: valueNonNil
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  private func mergedWithParent(templates: Templates) throws -> NumberVariableTemplate {
    guard let parent = parent, parent != Self.type else { return self }
    guard let parentTemplate = templates[parent] as? NumberVariableTemplate else {
      throw DeserializationError.unknownType(type: parent)
    }
    let mergedParent = try parentTemplate.mergedWithParent(templates: templates)

    return NumberVariableTemplate(
      parent: nil,
      name: name ?? mergedParent.name,
      value: value ?? mergedParent.value
    )
  }

  public func resolveParent(templates: Templates) throws -> NumberVariableTemplate {
    return try mergedWithParent(templates: templates)
  }
}
