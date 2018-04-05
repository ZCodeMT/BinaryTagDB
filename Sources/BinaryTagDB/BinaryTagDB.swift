//
//  BinaryTagDB.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/2/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

import Foundation

public class BinaryTagDB {
	var name: String
	var content: CompoundTag
	
	convenience init(location: URL, byteOrder: ByteOrder = ByteOrder.current) throws {
		try self.init(data: try Data(contentsOf: location), byteOrder: byteOrder)
	}
	
	convenience init(data: Data, byteOrder: ByteOrder = ByteOrder.current) throws {
		try self.init(decoder: BinaryDecoder(data: data), byteOrder: byteOrder)
	}
	
	init(decoder: BinaryDecoder, byteOrder: ByteOrder = ByteOrder.current) throws {
		let tagType = try decoder.decode() as BinaryTagType
		guard tagType == .Compound else {
			throw BinaryTagError.DataFormat("Specifications of NBT format expect compound tag to start data; instead found: \(tagType)")
		}
		name = try StringTag(decoder: decoder, byteOrder: byteOrder).payload
		content = try tagType.decodeTag(decoder: decoder, byteOrder: byteOrder) as! CompoundTag
	}
	
	public func encode(coder: BinaryCoder, byteOrder: ByteOrder = ByteOrder.current) {
		coder.encode(BinaryTagType.Compound)
		StringTag(payload: name).encode(coder: coder, byteOrder: byteOrder)
		content.encode(coder: coder, byteOrder: byteOrder)
	}
	
	public func save(to location: URL, byteOrder: ByteOrder = ByteOrder.current) throws {
		let coder = BinaryCoder()
		encode(coder: coder, byteOrder: byteOrder)
		try coder.data.write(to: location)
	}
	
	public func makeTextFormat(color: Bool) -> String {
		var text = ""
		if color {
			text += Color.tagType.makeText()
		}
		text += "TAG_Compound"
		if color  {
			text += Color.roundBracket.makeText()
		}
		text += "("
		text += StringTag(payload: name).makeTextFormat(indentation: 0, color: color)
		if color  {
			text += Color.roundBracket.makeText()
		}
		text += ")"
		if color {
			text += Color.Reset.makeText()
		}
		text += ": " + content.makeTextFormat(indentation: 0, color: color)
		return text
	}
	
	func printTextFormat(color: Bool = false) {
		print(makeTextFormat(color: color))
	}
}
