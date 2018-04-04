//
//  ByteTag.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/2/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

public class ByteTag: BinaryTag {
	public var type: BinaryTagType {
		get {
			return .Byte
		}
	}
	public var payload: Int8
	
	public required init(decoder: BinaryDecoder, byteOrder: ByteOrder = ByteOrder.current) throws {
		payload = try decoder.decode()
	}
	
	public func encode(coder: BinaryCoder, byteOrder: ByteOrder = ByteOrder.current) {
		coder.encode(payload)
	}
	
	public func makeTextFormat(indentation: Int, color: Bool) -> String {
		return "\(payload)"
	}
}
