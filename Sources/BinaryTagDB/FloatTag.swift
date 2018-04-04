//
//  FloatTag.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/3/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

public class FloatTag: BinaryTag {
	public var type: BinaryTagType {
		get {
			return .Float
		}
	}
	public var payload: Float32
	
	public required init(decoder: BinaryDecoder, byteOrder: ByteOrder = ByteOrder.current) throws {
		payload = try decoder.decodeNumber(byteOrder: byteOrder)
	}
	
	public func encode(coder: BinaryCoder, byteOrder: ByteOrder = ByteOrder.current) {
		coder.encodeNumber(payload, byteOrder: byteOrder)
	}
	
	public func makeTextFormat(indentation: Int, color: Bool) -> String {
		return "\(payload)"
	}
}
