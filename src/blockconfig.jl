"""Configure a CEX block for instantiation as a citable collection.
`C` must implement `CitableCollection`.  `container` may either be `nothing`, or a a URN value of type `U`.
"""
struct BlockConfig
    block::AbstractString
    C::Type
    U::Type{<: Urn}
    container
end