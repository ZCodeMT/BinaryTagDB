//
//  BinaryTagDBTests.swift
//  BinaryTagDBTests
//
//  Created by Silas Schwarz on 4/2/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

import XCTest
@testable import BinaryTagDB

final class BinaryTagDBTests: XCTestCase {
	func testLevelFile() {
		do {
#if os(OSX) || os(iOS)
			let bundle = Bundle(for: BinaryTagDBTests.self)
			guard let levelURL = bundle.url(forResource: "level", withExtension: "dat") else {
				throw BinaryTagError.Unknown("Test resource 'level.dat' not found in bundle")
			}
#elseif os(Linux)
			let levelURL = URL(fileURLWithPath: "Tests/BinaryTagDBTests/Data/level.dat")
#else
			let levelURL = URL(fileURLWithPath: "Tests/BinaryTagDBTests/Data/level.dat")
#endif
			let data = try Data(contentsOf: levelURL)
			let decoder = BinaryDecoder(data: data)
			print("level.data Int[0]: \(try decoder.decode() as Int32)")
			print("level.data Int[1]: \(try decoder.decode() as Int32)")
			let db = try BinaryTagDB(decoder: decoder, byteOrder: .LittleEndian)
			db.printTextFormat(color: true)
		} catch BinaryTagError.Unknown(let message) {
			XCTFail(message)
		} catch let error {
			XCTFail("Unknown error caught with unknown error type: \(error).")
		}
	}

	static var allTests = [
		("testLevelFile", testLevelFile),
	]
}
