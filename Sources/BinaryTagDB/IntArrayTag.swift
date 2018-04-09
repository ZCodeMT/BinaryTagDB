//
//  IntArrayTag.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/4/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

public class IntArrayTag: BinaryTag {
	public var type: BinaryTagType {
		get {
			return .IntArray
		}
	}
	var payload = [Int32]()
	
	public required init(decoder: BinaryDecoder, byteOrder: ByteOrder = ByteOrder.current) throws {
		let length = try decoder.decodeNumber(byteOrder: byteOrder) as Int32
		for _ in 0 ..< length {
			payload.append(try decoder.decodeNumber(byteOrder: byteOrder))
		}
	}
	
	public func encode(coder: BinaryCoder, byteOrder: ByteOrder = ByteOrder.current) {
		coder.encodeNumber(Int32(payload.count), byteOrder: byteOrder)
		for element in payload {
			coder.encodeNumber(element, byteOrder: byteOrder)
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
			text += String(format: "%04hhhhX ", item)
		}
		if color {
			text += Color.Blue.makeText()
		}
		text += "]"
		if color {
			text += Color.Reset.makeText()
		}
		return text
	}
}
