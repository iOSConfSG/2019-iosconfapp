// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CreateFeedbackMutation: GraphQLMutation {
  public static let operationName: String = "CreateFeedback"
  public static let document: ApolloAPI.DocumentType = .notPersisted(
    definition: .init(
      """
      mutation CreateFeedback($talkId: Int!, $feeling: String!, $comment: String!) {
        insert_feedback(
          objects: [{talk_id: $talkId, feeling: $feeling, comment: $comment}]
        ) {
          __typename
          affected_rows
        }
      }
      """
    ))

  public var talkId: Int
  public var feeling: String
  public var comment: String

  public init(
    talkId: Int,
    feeling: String,
    comment: String
  ) {
    self.talkId = talkId
    self.feeling = feeling
    self.comment = comment
  }

  public var __variables: Variables? { [
    "talkId": talkId,
    "feeling": feeling,
    "comment": comment
  ] }

  public struct Data: ConfAPI.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { ConfAPI.Objects.Mutation_root }
    public static var __selections: [Selection] { [
      .field("insert_feedback", Insert_feedback?.self, arguments: ["objects": [[
        "talk_id": .variable("talkId"),
        "feeling": .variable("feeling"),
        "comment": .variable("comment")
      ]]]),
    ] }

    /// insert data into the table: "feedback"
    public var insert_feedback: Insert_feedback? { __data["insert_feedback"] }

    /// Insert_feedback
    ///
    /// Parent Type: `Feedback_mutation_response`
    public struct Insert_feedback: ConfAPI.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { ConfAPI.Objects.Feedback_mutation_response }
      public static var __selections: [Selection] { [
        .field("affected_rows", Int.self),
      ] }

      /// number of rows affected by the mutation
      public var affected_rows: Int { __data["affected_rows"] }
    }
  }
}
