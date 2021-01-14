import Foundation
import ApolloCodegenLib

let parentFolderOfScriptFile = FileFinder.findParentFolder()
let sourceRootURL = parentFolderOfScriptFile
  .apollo.parentFolderURL() // Result: Sources folder
  .apollo.parentFolderURL() // Result: Codegen folder
  .apollo.parentFolderURL() // Result: MyProject source root folder

let cliFolderURL = sourceRootURL
  .apollo.childFolderURL(folderName: "Codegen")
  .apollo.childFolderURL(folderName: "ApolloCLI")

let endpoint = URL(string: "https://iosconfsg.herokuapp.com/v1/graphql")!
let output = sourceRootURL
    .apollo.childFolderURL(folderName:"iosconfsg2019")

try FileManager
  .default
  .apollo.createFolderIfNeeded(at: output)

let schemaDownloadOptions = ApolloSchemaOptions(endpointURL: endpoint, outputFolderURL: output)

//let schemaDownloadOptions = ApolloSchemaOptions(
//    schemaFileName: "schema",
//    schemaFileType: ApolloSchemaOptions.SchemaFileType.json,
//    endpointURL: endpoint,
//    headers: ["x-hasura-admin-secret: dingdong"],
//    outputFolderURL: output)

do {
  try ApolloSchemaDownloader.run(with: cliFolderURL,
                                 options: schemaDownloadOptions)
} catch {
  exit(1)
}

// Generating Swift code for a target

let targetURL = sourceRootURL
    .apollo.childFolderURL(folderName: "iosconfsg2019")

try FileManager
      .default
      .apollo.createFolderIfNeeded(at: targetURL)
let codegenOptions = ApolloCodegenOptions(targetRootURL: targetURL)
do {
    try ApolloCodegen.run(from: targetURL,
                          with: cliFolderURL,
                          options: codegenOptions)
} catch {
    exit(1)
}



