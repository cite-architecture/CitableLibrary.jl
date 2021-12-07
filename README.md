# CitableLibrary.jl

> Work with diverse collections of material citable by URN.

A citable collection:

- implements `iterate`  
- implements the `CitableLibraryTrait`, and its serialization functions 
    - `fromblock` 
    - `toblock`
- implements the `CexTrait` with the functions:
    -   `cex` 
    -   `fromcex`
- implements `UrnComparisonTrait` and:
    - `urnequals`
    - `urncontains`
    - `urnsimilar`
