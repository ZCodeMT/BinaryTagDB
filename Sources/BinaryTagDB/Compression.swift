//
//  Compression.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/9/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

import Foundation
#if os(Linux)
import zlibLinux
#else
import zlib
#endif

private let DEFAULT_BUFFER_SIZE: uInt = 1 << 10

func GZIPCompress(data: Data) throws -> Data {
	var mutableData = Data(data)
	return try mutableData.withUnsafeMutableBytes { (pointer: UnsafeMutablePointer<Bytef>) throws -> Data in
		var stream = z_stream()
		stream.next_in = pointer
		stream.avail_in = uInt(data.count)
		var status: Int32
		status = deflateInit2_(&stream, Z_DEFAULT_COMPRESSION, Z_DEFLATED, MAX_WBITS + 16, MAX_MEM_LEVEL, Z_DEFAULT_STRATEGY, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size))
		guard status == Z_OK else {
			throw BinaryTagError.Compression
		}
		var compressedData = Data()
		repeat {
			compressedData.count += Int(DEFAULT_BUFFER_SIZE)
			try compressedData.withUnsafeMutableBytes { (out_pointer: UnsafeMutablePointer<Bytef>) in
				stream.next_out = out_pointer.advanced(by: Int(stream.total_out))
				stream.avail_out = DEFAULT_BUFFER_SIZE
				guard deflate(&stream, Z_FINISH) != Z_STREAM_ERROR else {
					throw BinaryTagError.Compression
				}
				status = inflate(&stream, Z_SYNC_FLUSH)
			}
		} while stream.avail_out == 0
		compressedData.count -= Int(stream.avail_out)
		deflateEnd(&stream)
		return compressedData
	}
}

func GZIPDecompress(data: Data) throws -> Data {
	var mutableData = Data(data)
	return try mutableData.withUnsafeMutableBytes { (pointer: UnsafeMutablePointer<Bytef> ) throws -> Data in
		var stream = z_stream()
		stream.next_in = pointer
		stream.avail_in = uInt(data.count)
		var status: Int32
		status = inflateInit2_(&stream, MAX_WBITS + 32, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size))
		guard status == Z_OK else {
			throw BinaryTagError.Compression
		}
		var decompressedData = Data()
		repeat {
			decompressedData.count += Int(DEFAULT_BUFFER_SIZE)
			try decompressedData.withUnsafeMutableBytes { (out_pointer: UnsafeMutablePointer<Bytef>) throws in
				stream.next_out = out_pointer.advanced(by: Int(stream.total_out))
				stream.avail_out = DEFAULT_BUFFER_SIZE
				status = inflate(&stream, Z_NO_FLUSH)
				switch status {
				case Z_MEM_ERROR: throw BinaryTagError.Compression
				case Z_DATA_ERROR: throw BinaryTagError.Compression
				case Z_NEED_DICT: throw BinaryTagError.Compression
				default: break
				}
			}
		} while stream.avail_out == 0
		guard status == Z_STREAM_END else {
			throw BinaryTagError.Compression
		}
		decompressedData.count -= Int(stream.avail_out)
		status = inflateEnd(&stream)
		guard status == Z_OK else {
			throw BinaryTagError.Compression
		}
		return decompressedData
	}
}
