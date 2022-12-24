// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetScheduleSubscription: GraphQLSubscription {
  public static let operationName: String = "GetSchedule"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
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
            image_url
            twitter
            linkedin
            short_bio
          }
        }
      }
      """
    ))

  public init() {}

  public struct Data: ConfAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { ConfAPI.Objects.Subscription_root }
    public static var __selections: [Selection] { [
      .field("schedule", [Schedule].self),
    ] }

    /// fetch data from the table: "schedule"
    public var schedule: [Schedule] { __data["schedule"] }

    /// Schedule
    ///
    /// Parent Type: `Schedule`
    public struct Schedule: ConfAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { ConfAPI.Objects.Schedule }
      public static var __selections: [Selection] { [
        .field("id", Int?.self),
        .field("activity", String?.self),
        .field("title", String?.self),
        .field("start_at", Timestamptz?.self),
        .field("end_at", Timestamptz?.self),
        .field("talk_type", String?.self),
        .field("talk_description", String?.self),
        .field("speakers", [Speaker].self),
      ] }

      public var id: Int? { __data["id"] }
      public var activity: String? { __data["activity"] }
      public var title: String? { __data["title"] }
      public var start_at: Timestamptz? { __data["start_at"] }
      public var end_at: Timestamptz? { __data["end_at"] }
      public var talk_type: String? { __data["talk_type"] }
      public var talk_description: String? { __data["talk_description"] }
      /// An array relationship
      public var speakers: [Speaker] { __data["speakers"] }

      /// Schedule.Speaker
      ///
      /// Parent Type: `Talk_speakers_view`
      public struct Speaker: ConfAPI.SelectionSet {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public static var __parentType: ParentType { ConfAPI.Objects.Talk_speakers_view }
        public static var __selections: [Selection] { [
          .field("id", Int?.self),
          .field("name", String?.self),
          .field("company", String?.self),
          .field("image_url", String?.self),
          .field("twitter", String?.self),
          .field("linkedin", String?.self),
          .field("short_bio", String?.self),
        ] }

        public var id: Int? { __data["id"] }
        public var name: String? { __data["name"] }
        public var company: String? { __data["company"] }
        public var image_url: String? { __data["image_url"] }
        public var twitter: String? { __data["twitter"] }
        public var linkedin: String? { __data["linkedin"] }
        public var short_bio: String? { __data["short_bio"] }
      }
    }
  }
}
