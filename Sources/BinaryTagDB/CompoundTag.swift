//
//  CompoundTag.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/4/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

public class CompoundTag: BinaryTag {
	public var type: BinaryTagType {
		get {
			return .Compound
		}
	}
	public var payload = [String: BinaryTag]()
	
	public required init(decoder: BinaryDecoder, byteOrder: ByteOrder = ByteOrder.current) throws {
		var nextType = try decoder.decode() as BinaryTagType
		while nextType != .End {
			let name = try StringTag(decoder: decoder, byteOrder: byteOrder)
			payload[name.payload] = try nextType.decodeTag(decoder: decoder, byteOrder: byteOrder)
			nextType = try decoder.decode()
		}
	}
	
	public func encode(coder: BinaryCoder, byteOrder: ByteOrder = ByteOrder.current) {
		for (name, tag) in payload {
			coder.encode(tag.type)
			StringTag(payload: name).encode(coder: coder, byteOrder: byteOrder)
			tag.encode(coder: coder, byteOrder: byteOrder)
		}
		coder.encode(BinaryTagType.End)
	}
	
	public func makeTextFormat(indentation: Int, color: Bool) -> String {
		var text = ""
		if color {
			text += Color.curlyBracket.makeText()
		}
		text += "{\n"
		let indentationString = String(repeating: "\t", count: indentation)
		for (name, tag) in payload {
			if color {
				text += Color.tagType.makeText()
			}
			text += indentationString + "\tTAG_\(tag.type)"
			if color  {
				text += Color.roundBracket.makeText()
			}
			text += "("
			text += StringTag(payload: name).makeTextFormat(indentation: indentation, color: color)
			if color  {
				text += Color.roundBracket.makeText()
			}
			text += ")"
			if color {
				text += Color.Reset.makeText()
			}
			text += ": " + tag.makeTextFormat(indentation: indentation + 1, color: color)
			text += "\n"
		}
		if color {
			text += Color.curlyBracket.makeText()
		}
		text += indentationString + "}"
		if color {
			text += Color.Reset.makeText()
		}
		return text
	}
}
