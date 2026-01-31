extension String {
    package static func == (lhs: String, rhs: String) -> Bool {
        lhs.utf8.elementsEqual(rhs.utf8)
    }

    package static func != (lhs: String, rhs: String) -> Bool {
        !lhs.utf8.elementsEqual(rhs.utf8)
    }
}
