// Generated code. Do not modify.

import CommonCore
import Foundation
import Serialization
import TemplatesSupport

@frozen
public enum DivPivotTemplate: TemplateValue {
  case divPivotFixedTemplate(DivPivotFixedTemplate)
  case divPivotPercentageTemplate(DivPivotPercentageTemplate)

  public var value: Any {
    switch self {
    case let .divPivotFixedTemplate(value):
      return value
    case let .divPivotPercentageTemplate(value):
      return value
    }
  }

  public func resolveParent(templates: Templates) throws -> DivPivotTemplate {
    switch self {
    case let .divPivotFixedTemplate(value):
      return .divPivotFixedTemplate(try value.resolveParent(templates: templates))
    case let .divPivotPercentageTemplate(value):
      return .divPivotPercentageTemplate(try value.resolveParent(templates: templates))
    }
  }

  public static func resolveValue(context: Context, parent: DivPivotTemplate?, useOnlyLinks: Bool) -> DeserializationResult<DivPivot> {
    guard let parent = parent else {
      if useOnlyLinks {
        return .failure(NonEmptyArray(.missingType(representation: context.templateData)))
      } else {
        return resolveUnknownValue(context: context, useOnlyLinks: useOnlyLinks)
      }
    }

    switch parent {
    case let .divPivotFixedTemplate(value):
      let result = value.resolveValue(context: context, useOnlyLinks: useOnlyLinks)
      switch result {
      case let .success(value): return .success(.divPivotFixed(value))
      case let .partialSuccess(value, warnings): return .partialSuccess(.divPivotFixed(value), warnings: warnings)
      case let .failure(errors): return .failure(errors)
      case .noValue: return .noValue
      }
    case let .divPivotPercentageTemplate(value):
      let result = value.resolveValue(context: context, useOnlyLinks: useOnlyLinks)
      switch result {
      case let .success(value): return .success(.divPivotPercentage(value))
      case let .partialSuccess(value, warnings): return .partialSuccess(.divPivotPercentage(value), warnings: warnings)
      case let .failure(errors): return .failure(errors)
      case .noValue: return .noValue
      }
    }
  }

  private static func resolveUnknownValue(context: Context, useOnlyLinks: Bool) -> DeserializationResult<DivPivot> {
    guard let type = (context.templateData["type"] as? String).flatMap({ context.templateToType[$0] ?? $0 }) else {
      return .failure(NonEmptyArray(FieldError(fieldName: "type", level: .error, error: .requiredFieldIsMissing)))
    }

    switch type {
    case DivPivotFixed.type:
      let result = DivPivotFixedTemplate.resolveValue(context: context, useOnlyLinks: useOnlyLinks)
      switch result {
      case let .success(value): return .success(.divPivotFixed(value))
      case let .partialSuccess(value, warnings): return .partialSuccess(.divPivotFixed(value), warnings: warnings)
      case let .failure(errors): return .failure(errors)
      case .noValue: return .noValue
      }
    case DivPivotPercentage.type:
      let result = DivPivotPercentageTemplate.resolveValue(context: context, useOnlyLinks: useOnlyLinks)
      switch result {
      case let .success(value): return .success(.divPivotPercentage(value))
      case let .partialSuccess(value, warnings): return .partialSuccess(.divPivotPercentage(value), warnings: warnings)
      case let .failure(errors): return .failure(errors)
      case .noValue: return .noValue
      }
    default:
      return .failure(NonEmptyArray(FieldError(fieldName: "type", level: .error, error: .requiredFieldIsMissing)))
    }
  }
}

extension DivPivotTemplate: TemplateDeserializable {
  public init(dictionary: [String: Any], templateToType: TemplateToType) throws {
    let receivedType = try dictionary.getField("type") as String
    let blockType = templateToType[receivedType] ?? receivedType
    switch blockType {
    case DivPivotFixedTemplate.type:
      self = .divPivotFixedTemplate(try DivPivotFixedTemplate(dictionary: dictionary, templateToType: templateToType))
    case DivPivotPercentageTemplate.type:
      self = .divPivotPercentageTemplate(try DivPivotPercentageTemplate(dictionary: dictionary, templateToType: templateToType))
    default:
      throw DeserializationError.invalidFieldRepresentation(field: "div-pivot_template", representation: dictionary)
    }
  }
}
