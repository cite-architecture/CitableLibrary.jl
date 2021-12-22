# CitableLibrary.jl


The  `CitableLibrary` package defines a type, the `CiteLibrary`, which includes one or more *collections of citable resources*

Collections of citable resources (or more briefly, *citable collections*) must implement four kinds of behavior.


- *iteration*. Citable collections can be used with any Julia functions working with iterable collections.
- *URN comparison* Collections can be queried by filtering their identifiers with URN logic.
- *serialization* of individual collections. Individual citable collections can be be losslessly serialized to plain-text representation in CEX format and instantiated from the same plain-text representation



> Or maybe this isn't real?
>
> - *serializing entire libraries* 




The following pages provide a working example. They first define a custom type of citable collection, then implement each of the required behaviors, and finally add a collection to a `CiteLibrary`, and show some ways it can be used.

