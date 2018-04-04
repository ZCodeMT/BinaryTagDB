//
//  BinaryDecoder.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/2/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

import Foundation

public class BinaryDecoder {
	private var data: Data
	var index: Int
	
	init(data: Data, index: Int = 0) {
		self.data = data
		self.index = index
	}
	
	func decode<T>() throws -> T {
		let currentIndex = index
		index += MemoryLayout<T>.size
		if index > data.count {
			throw BinaryTagError.DataFormat("Data ended before expected")
		}
		return data.withUnsafeBytes { (pointer: UnsafePointer<Int8>) -> T in
			let itemPointer = pointer + currentIndex
			return itemPointer.withMemoryRebound(to: T.self, capacity: 1) { (pointer: UnsafePointer<T>) -> T in
				return pointer.pointee
			}
		}
	}
	
	public func decodeNumber<T: FixedWidthInteger>(byteOrder: ByteOrder = ByteOrder.current) throws -> T {
		switch byteOrder {
		case .BigEndian: return (try decode() as T).bigEndian
		case .LittleEndian: return (try decode() as T).littleEndian
		}
	}
	
	public func decodeNumber(byteOrder: ByteOrder = ByteOrder.current) throws -> Float32 {
		switch byteOrder {
		case .BigEndian: return Float32(bitPattern: (try decode() as UInt32).bigEndian)
		case .LittleEndian: return Float32(bitPattern: (try decode() as UInt32).littleEndian)
		}
	}
	
	public func decodeNumber(byteOrder: ByteOrder = ByteOrder.current) throws -> Float64 {
		switch byteOrder {
		case .BigEndian: return Float64(bitPattern: (try decode() as UInt64).bigEndian)
		case .LittleEndian: return Float64(bitPattern: (try decode() as UInt64).littleEndian)
		}
	}
	
	public func decodeString(length: Int) throws -> String {
		let currentIndex = index
		index += length
		if index > data.count {
			throw BinaryTagError.DataFormat("Data ended before expected")
		}
		return data.withUnsafeBytes { (pointer: UnsafePointer<CChar>) -> String in
			let stringMemory = UnsafeMutablePointer<CChar>.allocate(capacity: length)
			for i in 0 ..< length {
				stringMemory[i] = pointer[currentIndex + i]
			}
			return String(bytesNoCopy: UnsafeMutableRawPointer(stringMemory), length: length, encoding: String.Encoding.utf8, freeWhenDone: true)!
		}
	}
}
