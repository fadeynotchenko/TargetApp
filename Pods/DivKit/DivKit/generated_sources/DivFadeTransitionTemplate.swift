// Generated code. Do not modify.

import CommonCore
import Foundation
import Serialization
import TemplatesSupport

public final class DivFadeTransitionTemplate: TemplateValue, TemplateDeserializable {
  public static let type: String = "fade"
  public let parent: String? // at least 1 char
  public let alpha: Field<Expression<Double>>? // constraint: number >= 0.0 && number <= 1.0; default value: 0.0
  public let duration: Field<Expression<Int>>? // constraint: number >= 0; default value: 200
  public let interpolator: Field<Expression<DivAnimationInterpolator>>? // default value: ease_in_out
  public let startDelay: Field<Expression<Int>>? // constraint: number >= 0; default value: 0

  static let parentValidator: AnyValueValidator<String> =
    makeStringValidator(minLength: 1)

  public convenience init(dictionary: [String: Any], templateToType: TemplateToType) throws {
    self.init(
      parent: try dictionary.getOptionalField("type", validator: Self.parentValidator),
      alpha: try dictionary.getOptionalExpressionField("alpha"),
      duration: try dictionary.getOptionalExpressionField("duration"),
      interpolator: try dictionary.getOptionalExpressionField("interpolator"),
      startDelay: try dictionary.getOptionalExpressionField("start_delay")
    )
  }

  init(
    parent: String?,
    alpha: Field<Expression<Double>>? = nil,
    duration: Field<Expression<Int>>? = nil,
    interpolator: Field<Expression<DivAnimationInterpolator>>? = nil,
    startDelay: Field<Expression<Int>>? = nil
  ) {
    self.parent = parent
    self.alpha = alpha
    self.duration = duration
    self.interpolator = interpolator
    self.startDelay = startDelay
  }

  private static func resolveOnlyLinks(context: Context, parent: DivFadeTransitionTemplate?) -> DeserializationResult<DivFadeTransition> {
    let alphaValue = parent?.alpha?.resolveOptionalValue(context: context, validator: ResolvedValue.alphaValidator) ?? .noValue
    let durationValue = parent?.duration?.resolveOptionalValue(context: context, validator: ResolvedValue.durationValidator) ?? .noValue
    let interpolatorValue = parent?.interpolator?.resolveOptionalValue(context: context, validator: ResolvedValue.interpolatorValidator) ?? .noValue
    let startDelayValue = parent?.startDelay?.resolveOptionalValue(context: context, validator: ResolvedValue.startDelayValidator) ?? .noValue
    let errors = mergeErrors(
      alphaValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "alpha", level: .warning)) },
      durationValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "duration", level: .warning)) },
      interpolatorValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "interpolator", level: .warning)) },
      startDelayValue.errorsOrWarnings?.map { .right($0.asError(deserializing: "start_delay", level: .warning)) }
    )
    let result = DivFadeTransition(
      alpha: alphaValue.value,
      duration: durationValue.value,
      interpolator: interpolatorValue.value,
      startDelay: startDelayValue.value
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  public static func resolveValue(context: Context, parent: DivFadeTransitionTemplate?, useOnlyLinks: Bool) -> DeserializationResult<DivFadeTransition> {
    if useOnlyLinks {
      return resolveOnlyLinks(context: context, parent: parent)
    }
    var alphaValue: DeserializationResult<Expression<Double>> = parent?.alpha?.value() ?? .noValue
    var durationValue: DeserializationResult<Expression<Int>> = parent?.duration?.value() ?? .noValue
    var interpolatorValue: DeserializationResult<Expression<DivAnimationInterpolator>> = parent?.interpolator?.value() ?? .noValue
    var startDelayValue: DeserializationResult<Expression<Int>> = parent?.startDelay?.value() ?? .noValue
    context.templateData.forEach { key, __dictValue in
      switch key {
      case "alpha":
        alphaValue = deserialize(__dictValue, validator: ResolvedValue.alphaValidator).merged(with: alphaValue)
      case "duration":
        durationValue = deserialize(__dictValue, validator: ResolvedValue.durationValidator).merged(with: durationValue)
      case "interpolator":
        interpolatorValue = deserialize(__dictValue, validator: ResolvedValue.interpolatorValidator).merged(with: interpolatorValue)
      case "start_delay":
        startDelayValue = deserialize(__dictValue, validator: ResolvedValue.startDelayValidator).merged(with: startDelayValue)
      case parent?.alpha?.link:
        alphaValue = alphaValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.alphaValidator))
      case parent?.duration?.link:
        durationValue = durationValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.durationValidator))
      case parent?.interpolator?.link:
        interpolatorValue = interpolatorValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.interpolatorValidator))
      case parent?.startDelay?.link:
        startDelayValue = startDelayValue.merged(with: deserialize(__dictValue, validator: ResolvedValue.startDelayValidator))
      default: break
      }
    }
    let errors = mergeErrors(
      alphaValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "alpha", level: .warning)) },
      durationValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "duration", level: .warning)) },
      interpolatorValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "interpolator", level: .warning)) },
      startDelayValue.errorsOrWarnings?.map { Either.right($0.asError(deserializing: "start_delay", level: .warning)) }
    )
    let result = DivFadeTransition(
      alpha: alphaValue.value,
      duration: durationValue.value,
      interpolator: interpolatorValue.value,
      startDelay: startDelayValue.value
    )
    return errors.isEmpty ? .success(result) : .partialSuccess(result, warnings: NonEmptyArray(errors)!)
  }

  private func mergedWithParent(templates: Templates) throws -> DivFadeTransitionTemplate {
    guard let parent = parent, parent != Self.type else { return self }
    guard let parentTemplate = templates[parent] as? DivFadeTransitionTemplate else {
      throw DeserializationError.unknownType(type: parent)
    }
    let mergedParent = try parentTemplate.mergedWithParent(templates: templates)

    return DivFadeTransitionTemplate(
      parent: nil,
      alpha: alpha ?? mergedParent.alpha,
      duration: duration ?? mergedParent.duration,
      interpolator: interpolator ?? mergedParent.interpolator,
      startDelay: startDelay ?? mergedParent.startDelay
    )
  }

  public func resolveParent(templates: Templates) throws -> DivFadeTransitionTemplate {
    return try mergedWithParent(templates: templates)
  }
}
