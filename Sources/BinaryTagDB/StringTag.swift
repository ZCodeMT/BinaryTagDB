//
//  StringTag.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/4/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

public class StringTag: BinaryTag {
	public var type: BinaryTagType {
		get {
			return .String
		}
	}
	public var payload: String
	
	public required init(decoder: BinaryDecoder, byteOrder: ByteOrder) throws {
		let length = try decoder.decodeNumber(byteOrder: byteOrder) as Int16
		payload = try decoder.decodeString(length: Int(length))
	}
	
	public init(payload: String) {
		self.payload = payload
	}
	
	public func encode(coder: BinaryCoder, byteOrder: ByteOrder) {
		coder.encodeNumber(Int16(payload.lengthOfBytes(using: .utf8)), byteOrder: byteOrder)
		coder.encodeString(payload)
	}
	
	public func makeTextFormat(indentation: Int, color: Bool) -> String {
		var text = ""
		if color {
			text += Color.quotationMark.makeText()
		}
		text += "\""
		if color {
			text += Color.Reset.makeText()
		}
		text += payload
		if color {
			text += Color.quotationMark.makeText()
		}
		text += "\""
		if color {
			text += Color.Reset.makeText()
		}
		return text
	}
}
