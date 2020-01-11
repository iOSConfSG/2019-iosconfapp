//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetScheduleSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    subscription GetSchedule {
      schedule {
        __typename
        activity
        end_at
        id
        speaker_bio
        speaker_company
        speaker_image
        speaker_name
        speaker_twitter
        speaker_linkedin
        speaker_image_url
        start_at
        talk_description
        talk_type
        title
      }
    }
    """

  public let operationName = "GetSchedule"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["subscription_root"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("schedule", type: .nonNull(.list(.nonNull(.object(Schedule.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(schedule: [Schedule]) {
      self.init(unsafeResultMap: ["__typename": "subscription_root", "schedule": schedule.map { (value: Schedule) -> ResultMap in value.resultMap }])
    }

    /// fetch data from the table: "schedule"
    public var schedule: [Schedule] {
      get {
        return (resultMap["schedule"] as! [ResultMap]).map { (value: ResultMap) -> Schedule in Schedule(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Schedule) -> ResultMap in value.resultMap }, forKey: "schedule")
      }
    }

    public struct Schedule: GraphQLSelectionSet {
      public static let possibleTypes = ["schedule"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("activity", type: .scalar(String.self)),
        GraphQLField("end_at", type: .scalar(String.self)),
        GraphQLField("id", type: .scalar(Int.self)),
        GraphQLField("speaker_bio", type: .scalar(String.self)),
        GraphQLField("speaker_company", type: .scalar(String.self)),
        GraphQLField("speaker_image", type: .scalar(String.self)),
        GraphQLField("speaker_name", type: .scalar(String.self)),
        GraphQLField("speaker_twitter", type: .scalar(String.self)),
        GraphQLField("speaker_linkedin", type: .scalar(String.self)),
        GraphQLField("speaker_image_url", type: .scalar(String.self)),
        GraphQLField("start_at", type: .scalar(String.self)),
        GraphQLField("talk_description", type: .scalar(String.self)),
        GraphQLField("talk_type", type: .scalar(String.self)),
        GraphQLField("title", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(activity: String? = nil, endAt: String? = nil, id: Int? = nil, speakerBio: String? = nil, speakerCompany: String? = nil, speakerImage: String? = nil, speakerName: String? = nil, speakerTwitter: String? = nil, speakerLinkedin: String? = nil, speakerImageUrl: String? = nil, startAt: String? = nil, talkDescription: String? = nil, talkType: String? = nil, title: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "schedule", "activity": activity, "end_at": endAt, "id": id, "speaker_bio": speakerBio, "speaker_company": speakerCompany, "speaker_image": speakerImage, "speaker_name": speakerName, "speaker_twitter": speakerTwitter, "speaker_linkedin": speakerLinkedin, "speaker_image_url": speakerImageUrl, "start_at": startAt, "talk_description": talkDescription, "talk_type": talkType, "title": title])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var activity: String? {
        get {
          return resultMap["activity"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "activity")
        }
      }

      public var endAt: String? {
        get {
          return resultMap["end_at"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "end_at")
        }
      }

      public var id: Int? {
        get {
          return resultMap["id"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var speakerBio: String? {
        get {
          return resultMap["speaker_bio"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "speaker_bio")
        }
      }

      public var speakerCompany: String? {
        get {
          return resultMap["speaker_company"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "speaker_company")
        }
      }

      public var speakerImage: String? {
        get {
          return resultMap["speaker_image"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "speaker_image")
        }
      }

      public var speakerName: String? {
        get {
          return resultMap["speaker_name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "speaker_name")
        }
      }

      public var speakerTwitter: String? {
        get {
          return resultMap["speaker_twitter"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "speaker_twitter")
        }
      }

      public var speakerLinkedin: String? {
        get {
          return resultMap["speaker_linkedin"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "speaker_linkedin")
        }
      }

      public var speakerImageUrl: String? {
        get {
          return resultMap["speaker_image_url"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "speaker_image_url")
        }
      }

      public var startAt: String? {
        get {
          return resultMap["start_at"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "start_at")
        }
      }

      public var talkDescription: String? {
        get {
          return resultMap["talk_description"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "talk_description")
        }
      }

      public var talkType: String? {
        get {
          return resultMap["talk_type"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "talk_type")
        }
      }

      public var title: String? {
        get {
          return resultMap["title"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }
    }
  }
}

public final class CreateFeedbackMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreateFeedback($talkId: Int!, $feeling: String!, $comment: String!) {
      insert_feedback(objects: [{talk_id: $talkId, feeling: $feeling, comment: $comment}]) {
        __typename
        affected_rows
      }
    }
    """

  public let operationName = "CreateFeedback"

  public var talkId: Int
  public var feeling: String
  public var comment: String

  public init(talkId: Int, feeling: String, comment: String) {
    self.talkId = talkId
    self.feeling = feeling
    self.comment = comment
  }

  public var variables: GraphQLMap? {
    return ["talkId": talkId, "feeling": feeling, "comment": comment]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["mutation_root"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("insert_feedback", arguments: ["objects": [["talk_id": GraphQLVariable("talkId"), "feeling": GraphQLVariable("feeling"), "comment": GraphQLVariable("comment")]]], type: .object(InsertFeedback.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(insertFeedback: InsertFeedback? = nil) {
      self.init(unsafeResultMap: ["__typename": "mutation_root", "insert_feedback": insertFeedback.flatMap { (value: InsertFeedback) -> ResultMap in value.resultMap }])
    }

    /// insert data into the table: "feedback"
    public var insertFeedback: InsertFeedback? {
      get {
        return (resultMap["insert_feedback"] as? ResultMap).flatMap { InsertFeedback(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "insert_feedback")
      }
    }

    public struct InsertFeedback: GraphQLSelectionSet {
      public static let possibleTypes = ["feedback_mutation_response"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("affected_rows", type: .nonNull(.scalar(Int.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(affectedRows: Int) {
        self.init(unsafeResultMap: ["__typename": "feedback_mutation_response", "affected_rows": affectedRows])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// number of affected rows by the mutation
      public var affectedRows: Int {
        get {
          return resultMap["affected_rows"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "affected_rows")
        }
      }
    }
  }
}
