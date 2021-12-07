# CitableLibrary.jl

> Work with diverse collections of material citable by URN.

A citable collection:

- implements the `CitableLibraryTrait`, and its URN lookup functions:
    - `urnequals`
    - `urncontains` (shared with with `UrnComparable`)
- implements `iterate`  
- implements the `CexTrait` with the functions:
    -   `cex` 
    -   `fromcex`
- additionally, `fromblock`, `toblock`