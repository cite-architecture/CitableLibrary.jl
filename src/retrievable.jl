#= A retrievable collection implements:

- the `CitableLibraryTrait`, and consequently  defines a `lookup` function, with a single parameter that is `<: Urn`.
-   implements `iterate`  [[iterables]]
-   implement `cex` [[serialization]]
=#

abstract type CitableLibraryTrait end

# function lookup() ...?
# function iterate(x::T) {where T....}
# function iterate(x::T, state) {where T....}
# function cex() ...?
