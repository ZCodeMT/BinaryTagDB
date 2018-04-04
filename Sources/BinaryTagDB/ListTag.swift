//
//  ListTag.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/4/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

public class ListTag: BinaryTag {
	public var type: BinaryTagType {
		get {
			return .List
		}
	}
	public let payloadType: BinaryTagType
	public var payload: Array<BinaryTag>
	
	public required init(decoder: BinaryDecoder, byteOrder: ByteOrder) throws {
		payloadType = try decoder.decode()
		payload = Array<BinaryTag>()
		
		let length = try decoder.decode() as Int32
		for _ in 0 ..< length {
			payload.append(try payloadType.decodeTag(decoder: decoder, byteOrder: byteOrder))
		}
	}
	
	public func encode(coder: BinaryCoder, byteOrder: ByteOrder) {
		coder.encode(payloadType)
		coder.encode(Int32(payload.count))
		for element in payload {
			guard element.type == payloadType else {
				fatalError()
			}
			element.encode(coder: coder, byteOrder: byteOrder)
		}
	}
	
	public func makeTextFormat(indentation: Int, color: Bool) -> String {
		var text = ""
		if color {
			text += Color.squareBracket.makeText()
		}
		text += "["
		if color {
			text += Color.tagType.makeText()
		}
		text += "TAG_\(payloadType)"
		if color {
			text += Color.squareBracket.makeText()
		}
		text += "] "
		if color {
			text += Color.curlyBracket.makeText()
		}
		text += "{\n"
		if color {
			text += Color.Reset.makeText()
		}
		let indentationString = String(repeating: "\t", count: indentation)
		for item in payload {
			if color {
				text += Color.tagType.makeText()
			}
			text += indentationString + "\tTAG_\(payloadType)"
			if color {
				text += Color.Reset.makeText()
			}
			text += ": " + item.makeTextFormat(indentation: indentation + 1, color: color) + "\n"
		}
		if color {
			text += Color.curlyBracket.makeText()
		}
		text += indentationString + "}"
		return text
	}
}
