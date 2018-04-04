//
//  ByteArrayTag.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/3/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

public class ByteArrayTag: BinaryTag {
	public var type: BinaryTagType {
		get {
			return .ByteArray
		}
	}
	var payload = [Int8]()
	
	public required init(decoder: BinaryDecoder, byteOrder: ByteOrder = ByteOrder.current) throws {
		let length = try decoder.decodeNumber() as Int16
		for _ in 0 ..< length {
			payload.append(try decoder.decode())
		}
	}
	
	public func encode(coder: BinaryCoder, byteOrder: ByteOrder = ByteOrder.current) {
		coder.encodeNumber(Int16(payload.count), byteOrder: byteOrder)
		for element in payload {
			coder.encode(element)
		}
	}
	
	public func makeTextFormat(indentation: Int, color: Bool) -> String {
		var text = ""
		if color {
			text += Color.squareBracket.makeText()
		}
		text += "[ "
		if color {
			text += Color.Reset.makeText()
		}
		for item in payload {
			text += String(format: "%02hhX ", item)
		}
		if color {
			text += Color.squareBracket.makeText()
		}
		text += "]"
		if color {
			text += Color.Reset.makeText()
		}
		return text
	}
}
