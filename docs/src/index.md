# CitableLibrary.jl


The  `CitableLibrary` package defines a type, the `CiteLibrary`, which includes one or more *collections of citable resources*



## Citable collections

Collections of citable resources (or more briefly, *citable collections*) must implement four kinds of behavior.


- *iteration*. Citable collections can be used with any Julia functions working with iterable collections.
- *URN comparison* Collections can be queried by filtering their identifiers with URN logic.
- *serialization* of individual collections. Individual citable collections can be be losslessly serialized to plain-text representation in CEX format and instantiated from the same plain-text representation


## Citable libraries

The `CiteLibrary` is a *citable object*:  it can be cited by URN, and identified with a human-readable label.  It is also serializable, and can be losslessly represented in CEX format and instantiated from the same plain-text representation.


!!! warning

    The `fromcex` function for the `CiteLibrary` type is defined in a separate package `CiteEXchange`.  See the explanation in these pages and the documentation for  [`CiteEXchange`](https://cite-architecture.github.io/CiteEXchange.jl/stable/)

The following pages provide a working example of how a citable collection relates to a citable library. First we define a custom type of citable collection, then implement each of its required behaviors, and finally add a collection to a `CiteLibrary`, and show some ways it can be used.

