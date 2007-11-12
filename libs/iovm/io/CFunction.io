getSlot("CFunction") do(

    docSlot("name", "Returns the CFunction name in the form CFunction_Pointer.")
    name := method(typeName ifNilEval("Object") .. "_" .. uniqueName ifNilEval("<unnamed>") .. "()")
    
    docSlot("asSimpleString", "Returns the CFunction name.")
    asSimpleString := method(name)

    docSlot("asString", "Same as asSimpleString.")
    asString := getSlot("asSimpleString")
)
