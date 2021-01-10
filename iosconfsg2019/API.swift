// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetScheduleSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    subscription GetSchedule {
      schedule {
        __typename
        id
        activity
        title
        start_at
        end_at
        talk_type
        talk_description
        speakers {
          __typename
          id
          name
          company
          company_url
          image_url
          image_filename
          twitter
          linkedin_url
          short_bio
        }
      }
    }
    """

  public let operationName: String = "GetSchedule"

  public let operationIdentifier: String? = "76b503557b50aecf4d9e4d3f31f141eb6ff515d8377c6b429105907deeb499f1"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["subscription_root"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("schedule", type: .nonNull(.list(.nonNull(.object(Schedule.selections))))),
      ]
    }

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
      public static let possibleTypes: [String] = ["schedule"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .scalar(Int.self)),
          GraphQLField("activity", type: .scalar(String.self)),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("start_at", type: .scalar(String.self)),
          GraphQLField("end_at", type: .scalar(String.self)),
          GraphQLField("talk_type", type: .scalar(String.self)),
          GraphQLField("talk_description", type: .scalar(String.self)),
          GraphQLField("speakers", type: .nonNull(.list(.nonNull(.object(Speaker.selections))))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int? = nil, activity: String? = nil, title: String? = nil, startAt: String? = nil, endAt: String? = nil, talkType: String? = nil, talkDescription: String? = nil, speakers: [Speaker]) {
        self.init(unsafeResultMap: ["__typename": "schedule", "id": id, "activity": activity, "title": title, "start_at": startAt, "end_at": endAt, "talk_type": talkType, "talk_description": talkDescription, "speakers": speakers.map { (value: Speaker) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
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

      public var activity: String? {
        get {
          return resultMap["activity"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "activity")
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

      public var startAt: String? {
        get {
          return resultMap["start_at"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "start_at")
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

      public var talkType: String? {
        get {
          return resultMap["talk_type"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "talk_type")
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

      /// An array relationship
      public var speakers: [Speaker] {
        get {
          return (resultMap["speakers"] as! [ResultMap]).map { (value: ResultMap) -> Speaker in Speaker(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Speaker) -> ResultMap in value.resultMap }, forKey: "speakers")
        }
      }

      public struct Speaker: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["talk_speakers_view"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .scalar(Int.self)),
            GraphQLField("name", type: .scalar(String.self)),
            GraphQLField("company", type: .scalar(String.self)),
            GraphQLField("company_url", type: .scalar(String.self)),
            GraphQLField("image_url", type: .scalar(String.self)),
            GraphQLField("image_filename", type: .scalar(String.self)),
            GraphQLField("twitter", type: .scalar(String.self)),
            GraphQLField("linkedin_url", type: .scalar(String.self)),
            GraphQLField("short_bio", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: Int? = nil, name: String? = nil, company: String? = nil, companyUrl: String? = nil, imageUrl: String? = nil, imageFilename: String? = nil, twitter: String? = nil, linkedinUrl: String? = nil, shortBio: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "talk_speakers_view", "id": id, "name": name, "company": company, "company_url": companyUrl, "image_url": imageUrl, "image_filename": imageFilename, "twitter": twitter, "linkedin_url": linkedinUrl, "short_bio": shortBio])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
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

        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var company: String? {
          get {
            return resultMap["company"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "company")
          }
        }

        public var companyUrl: String? {
          get {
            return resultMap["company_url"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "company_url")
          }
        }

        public var imageUrl: String? {
          get {
            return resultMap["image_url"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "image_url")
          }
        }

        public var imageFilename: String? {
          get {
            return resultMap["image_filename"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "image_filename")
          }
        }

        public var twitter: String? {
          get {
            return resultMap["twitter"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "twitter")
          }
        }

        public var linkedinUrl: String? {
          get {
            return resultMap["linkedin_url"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "linkedin_url")
          }
        }

        public var shortBio: String? {
          get {
            return resultMap["short_bio"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "short_bio")
          }
        }
      }
    }
  }
}
