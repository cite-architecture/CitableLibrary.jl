
struct CiteLibrary
    #cexversion::VersionNumber
    collections

    function CiteLibrary(collectionlist)
        @info("Initialized libary")
        for coll in collectionlist
            if CitableLibraryTrait(typeof(coll)) != CitableLibraryCollection()
                msg = "Type does not implement CitableLibraryTrait: $(typeof(coll))"
                DomainError(typeof(coll), msg) |> throw

            else
                @info(typeof(coll), CitableLibraryTrait(typeof(coll)))
            end
        end
        new(collectionlist)
    end
end