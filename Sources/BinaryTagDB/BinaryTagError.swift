//
//  BinaryTagError.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/2/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

public enum BinaryTagError: Error {
	case System(String)
	case Unknown(String)
	case DataFormat(String)
}
