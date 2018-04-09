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
	
	convenience init(location: URL, compressed: Bool = false, byteOrder: ByteOrder = ByteOrder.current) throws {
		try self.init(data: try Data(contentsOf: location), compressed: compressed, byteOrder: byteOrder)
	}
	
	convenience init(data: Data, compressed: Bool = false, byteOrder: ByteOrder = ByteOrder.current) throws {
		if compressed {
			let decompressedData = try GZIPDecompress(data: data)
//			try decompressedData.write(to: URL(fileURLWithPath: "Desktop/decompressed.data", relativeTo: FileManager.default.homeDirectoryForCurrentUser))
			try self.init(decoder: BinaryDecoder(data: decompressedData), byteOrder: byteOrder)
		} else {
			try self.init(decoder: BinaryDecoder(data: data), byteOrder: byteOrder)
		}
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
	
	public func save(to location: URL, compressed: Bool = false, byteOrder: ByteOrder = ByteOrder.current) throws {
		let coder = BinaryCoder()
		encode(coder: coder, byteOrder: byteOrder)
		if compressed {
			try GZIPCompress(data: coder.data).write(to: location)
		} else {
			try coder.data.write(to: location)
		}
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
	
	public func printTextFormat(color: Bool = false) {
		print(makeTextFormat(color: color))
	}
	
	public func request(location: URL) -> BinaryTag? {
		var dictionary = content
		var components = location.pathComponents
		if components.count == 0 {
			return nil
		}
		components.removeLast()
		for component in components {
			if let nextTag = dictionary.request(name: component) {
				if nextTag.type != .Compound {
					return nil
				}
				dictionary = nextTag as! CompoundTag
			} else {
				return nil
			}
		}
		return dictionary.request(name: location.pathComponents.last!)
	}
}
