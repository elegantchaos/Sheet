// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 10/08/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation
import SwiftUI
import UniformTypeIdentifiers

//
//protocol ReadableTypesList {
//    static var list: [UTType] { get }
//}
//
//struct DataFile<ReadableTypes: ReadableTypesList>: FileDocument {
//    static var readableContentTypes: [UTType] { ReadableTypes.list }
//
//    var data: Data
//
//    init(data: Data) {
//        self.data = data
//    }
//
//    init(configuration: ReadConfiguration) throws {
//        if let data = configuration.file.regularFileContents {
//            self.data = data
//        } else {
//            self.data = Data()
//        }
//    }
//
//    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
//        return FileWrapper(regularFileWithContents: data)
//    }
//}
//
//struct JSONTypeList: ReadableTypesList {
//    static var list: [UTType] = [UTType.json]
//}

//typealias JSONFile = DataFile<JSONTypeList>

protocol JSONDataProvider {
    var asJSONData: Data { get }
}

struct JSONFile: FileDocument {
    static var readableContentTypes: [UTType] { [UTType.json] }

    enum Errors: Error {
        case noData
    }
    
    enum Content {
        case data(Data)
        case deferred(JSONDataProvider)
    }
    
    let content: Content

    init(data: Data) {
        self.content = .data(data)
    }
    
    init(provider: JSONDataProvider) {
        self.content = .deferred(provider)
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            self.content = .data(data)
        } else {
            throw Errors.noData
        }
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data: Data
        
        switch content {
            case .data(let storedData):
                data = storedData

            case .deferred(let adaptor):
                data = adaptor.asJSONData
        }
        
        return FileWrapper(regularFileWithContents: data)
    }
}
