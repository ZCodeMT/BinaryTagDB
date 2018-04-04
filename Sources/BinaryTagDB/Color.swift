//
//  Color.swift
//  BinaryTagDB
//
//  Created by Silas Schwarz on 4/3/18.
//  Copyright © 2018 ZCodeMT LLC. All rights reserved.
//

public enum Color: UInt8 {
	case Reset = 0
	case Black = 30
	case Red
	case Green
	case Yellow
	case Blue
	case Magenta
	case Cyan
	case White
	case `default` = 39
	case LightBlack = 90
	case LightRed
	case LightGreen
	case LightYellow
	case LightBlue
	case LightMagenta
	case LightCyan
	case LightWhite
	
	public func makeText() -> String {
		return"\u{001B}[0;\(rawValue)m"
	}
	
	static let tagType = Color.Cyan
	static let squareBracket = Color.Green
	static let curlyBracket = Color.LightRed
	static let roundBracket = Color.LightGreen
	static let quotationMark = Color.Green
}
