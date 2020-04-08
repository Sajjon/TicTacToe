
protocol IntegerFromString: BinaryInteger {
    init?(_ description: String)
}
extension Int: IntegerFromString {}
extension UInt: IntegerFromString {}
extension Int8: IntegerFromString {}
extension UInt8: IntegerFromString {}
extension Int16: IntegerFromString {}
extension UInt16: IntegerFromString {}
extension Int32: IntegerFromString {}
extension UInt32: IntegerFromString {}
extension Int64: IntegerFromString {}
extension UInt64: IntegerFromString {}

func readInteger<I>() -> I? where I: IntegerFromString {
    guard let inputString = readLine(strippingNewline: true) else {
        return nil
    }
    
    guard let integer = I.init(inputString) else {
        return nil
    }
    
    return integer
}
