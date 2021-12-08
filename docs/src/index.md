# CitableLibrary.jl


The two main elements of the package are:

1. the `CitableLibrary` type
2. the `CitableLibraryTrait`


They are documented in the following pages.


A citable library works with citable library collections. These collections implement a number of functions:

- Julia's `iterate`  
- the three functions of the `UrnComparisonTrait`, `urnequals`, `urncontains` and `urnsimilar`
- the `CexTrait`'s two functions `cex` and `fromcex`
-  the serialization functions of `CitableLibraryTrait`,  `fromblock` and `toblock`


