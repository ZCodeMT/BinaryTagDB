//
//  BinaryCoder.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/3/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

import Foundation

public class BinaryCoder {
	private var memory: Int = 1024
	private var buffer: UnsafeMutableRawPointer
	private var index: Int = 0
	
	public var data: Data {
		get {
			return Data(bytes: buffer, count: index)
		}
	}
	
	public init() {
		buffer = UnsafeMutableRawPointer.allocate(byteCount: memory, alignment: MemoryLayout<Int8>.alignment)
	}
	
	private func requireMemory(size: Int) {
		if memory < index + size {
			repeat {
				memory = memory * 2
			} while memory < index + size
			
			let newBuffer = UnsafeMutableRawPointer.allocate(byteCount: memory, alignment: MemoryLayout<Int8>.alignment)
			newBuffer.copyMemory(from: buffer, byteCount: index)
			buffer.deallocate()
			buffer = newBuffer
		}
	}
	
	public func encode<T>(_ value: T) {
		requireMemory(size: MemoryLayout<T>.size)
		buffer.storeBytes(of: value, toByteOffset: index, as: T.self)
		index += MemoryLayout<T>.size
	}
	
	public func encodeNumber<T: FixedWidthInteger>(_ value: T, byteOrder: ByteOrder = ByteOrder.current) {
		switch byteOrder {
		case .LittleEndian:
			encode(value.littleEndian)
		case .BigEndian:
			encode(value.bigEndian)
		}
	}
	
	public func encodeNumber(_ value: Float32, byteOrder: ByteOrder = ByteOrder.current) {
		switch byteOrder {
		case .LittleEndian:
			encode(value.bitPattern.littleEndian)
		case .BigEndian:
			encode(value.bitPattern.bigEndian)
		}
	}
	
	public func encodeNumber(_ value: Float64, byteOrder: ByteOrder = ByteOrder.current) {
		switch byteOrder {
		case .LittleEndian:
			encode(value.bitPattern.littleEndian)
		case .BigEndian:
			encode(value.bitPattern.bigEndian)
		}
	}
	
	public func encodeString(_ value: String) {
		requireMemory(size: value.lengthOfBytes(using: .utf8))
		if let rawString = value.cString(using: .utf8) {
			for byte in rawString {
				encode(byte)
			}
		} else {
			fatalError()
		}
	}
}
