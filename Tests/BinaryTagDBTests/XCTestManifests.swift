//
//  XCTestManifests.swift
//  BinaryTagDBTests
//
//  Created by Silas Schwarz on 4/2/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
	return [
		testCase(BinaryTagDBTests.allTests),
	]
}
#endif
