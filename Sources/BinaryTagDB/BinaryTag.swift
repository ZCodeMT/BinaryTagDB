//
//  BinaryTag.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/2/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

public enum ByteOrder {
	case LittleEndian
	case BigEndian
	
	public static var current: ByteOrder = Int(1) == Int(1).littleEndian ? .LittleEndian : .BigEndian
}

public enum BinaryTagType: Int8 {
	case End
	case Byte
	case Short
	case Int
	case Long
	case Float
	case Double
	case ByteArray
	case String
	case List
	case Compound
	case IntArray
	
	public func decodeTag(decoder: BinaryDecoder, byteOrder: ByteOrder = ByteOrder.current) throws -> BinaryTag {
		switch self {
		case .End: fatalError()
		case .Byte: return try ByteTag(decoder: decoder, byteOrder: byteOrder)
		case .Short: return try ShortTag(decoder: decoder, byteOrder: byteOrder)
		case .Int: return try IntTag(decoder: decoder, byteOrder: byteOrder)
		case .Long: return try LongTag(decoder: decoder, byteOrder: byteOrder)
		case .Float: return try FloatTag(decoder: decoder, byteOrder: byteOrder)
		case .Double: return try DoubleTag(decoder: decoder, byteOrder: byteOrder)
		case .ByteArray: return try ByteArrayTag(decoder: decoder, byteOrder: byteOrder)
		case .IntArray: return try IntArrayTag(decoder: decoder, byteOrder: byteOrder)
		case .String: return try StringTag(decoder: decoder, byteOrder: byteOrder)
		case .List: return try ListTag(decoder: decoder, byteOrder: byteOrder)
		case .Compound: return try CompoundTag(decoder: decoder, byteOrder: byteOrder)
		}
	}
}

public protocol BinaryTag {
	var type: BinaryTagType { get }
	init(decoder: BinaryDecoder, byteOrder: ByteOrder) throws
	func encode(coder: BinaryCoder, byteOrder: ByteOrder)
	func makeTextFormat(indentation: Int, color: Bool) -> String
}
