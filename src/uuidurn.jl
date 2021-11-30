"""A UUID value in URN notation."""
struct UuidUrn <: Urn
    uuid::UUID
end

"""Override `show` for UuidUrn type.
$(SIGNATURES)
"""
function show(io::IO, u::CitableLibrary.UuidUrn)   
    show(io, join(["urn:uuid:", string(u.uuid)]))
end

"""Generate a new UuidUrn
$(SIGNATURES)
"""
function uuidUrn()
    rng = MersenneTwister(1234)
    uuid1(rng) |> UuidUrn
end

