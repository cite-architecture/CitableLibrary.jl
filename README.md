# CitableLibrary.jl

> Work with diverse collections of material citable by URN.

A citable collection:

- implements the `CitableLibraryTrait`, and its serialization functions `fromblock`, `toblock`
- implements `UrnComparisonTrait` and:
    - `urnequals`
    - `urncontains`
    - `urnsimilar`
- implements `iterate`  
- implements the `CexTrait` with the functions:
    -   `cex` 
    -   `fromcex`
