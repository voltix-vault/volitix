//
//  ProtoSerializer.swift
//  VultisigApp
//
//  Created by Artur Guseinov on 07.07.2024.
//

import Foundation

struct ProtoSerializer {

    private init() { }

    static func serialize<T: ProtoMappable>(_ model: T) throws -> String {
        let proto = model.mapToProtobuff()
        let compressed = try proto.serializedData()
        let compressedData = try (compressed as NSData).compressed(using: .zlib)
        let compressedDataBase64 = compressedData.base64EncodedString()
        return compressedDataBase64
    }

    static func deserialize<T: ProtoMappable>(base64EncodedString: String, vault: Vault) throws -> T {
        guard let compressedData = Data(base64Encoded: base64EncodedString) else {
            throw ProtoMappableError.base64EncodedDataNotFound
        }
        let serializedData = try (compressedData as NSData).decompressed(using: .zlib) as Data
        let proto = try T.ProtoType(serializedData: serializedData)
        let model = try T(proto: proto, vault: vault)
        return model
    }
}