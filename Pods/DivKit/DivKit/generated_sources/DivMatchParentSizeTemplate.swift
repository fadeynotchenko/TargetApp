// Generated code. Do not modify.

import CommonCore
import Foundation
import Serialization
import TemplatesSupport

public final class DivMatchParentSizeTemplate: TemplateValue, TemplateDeserializable {
  public static let type: String = "match_parent"
  public let parent: String? // at least 1 char
  public let weight: Field<Expression<Double>>? // constraint: number > 0

  static let parentValidator: AnyValueValidator<String> =
    makeStringValidator(minLength: 1)

  public convenience init(dictionary: [String: Any], templateToType: TemplateToType) throws {
    self.init(
      parent: try dictionary.getOptionalField("type", validator: Self.parentValidator),
      weight: try dictionary.getOptionalExpressionField("weight")
    )
  }

  init(
    parent: String?,
    weight: Field<Expression<Double>>? = nil
  ) {
    self.parent = parent
    self.weight = weight
  }

  private static func resolveOnlyLinks(context: Context, parent: DivMatchParentSizeTemplate?) -> DeserializationResult<DivMatchParentSize> {
    let weightValue = parent?.weight?.resolveOptionalValue(context: context, validator: ResolvedValue.weightValidator) ?? .noValue
    let errors = mergeErrors(
      weightValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "weight", level: .warning)) }
    )
    let result = DivMatchParentSize(
      weight: weightValue.value
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  public static func resolveValue(context: Context, parent: DivMatchParentSizeTemplate?, useOnlyLinks: Bool) -> DeserializationResult<DivMatchParentSize> {
    if useOnlyLinks {
      return resolveOnlyLinks(context: context, parent: parent)
    }
    var weightValue: DeserializationResult<Expression<Double>> = parent?.weight?.value() ?? .noValue
    context.templateData.forEach { key, __dictValue in
      switch key {
      case "weight":
        weightValue = deserialize(__dictValue, validator: ResolvedValue.weightValidator).merged(with: weightValue)
      case parent?.weight?.link:
        weightValue = weightValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.weightValidator))
      default: break
      }
    }
    let errors = mergeErrors(
      weightValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "weight", level: .warning)) }
    )
    let result = DivMatchParentSize(
      weight: weightValue.value
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  private func mergedWithParent(templates: Templates) throws -> DivMatchParentSizeTemplate {
    guard let parent = parent, parent != Self.type else { return self }
    guard let parentTemplate = templates[parent] as? DivMatchParentSizeTemplate else {
      throw DeserializationError.unknownType(type: parent)
    }
    let mergedParent = try parentTemplate.mergedWithParent(templates: templates)

    return DivMatchParentSizeTemplate(
      parent: nil,
      weight: weight ?? mergedParent.weight
    )
  }

  public func resolveParent(templates: Templates) throws -> DivMatchParentSizeTemplate {
    return try mergedWithParent(templates: templates)
  }
}
