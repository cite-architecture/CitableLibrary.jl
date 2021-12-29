

# Instantiating citable content from CEX source

## Citable objects and collections

You can use the `fromcex` function (from the `CitableBase` package) to instantiate citable objects and collections of citable objects.   (You use the `cexserializable` function to check whether an object or collection is reocgnized as serializable).  The first parameter is a string value in CEX format; the second parameter is a Julia type that will be instantiated from the CEX source.

More specifically:

- *citable objects* are objects of Julia types implementing the `CitableBase` package's `CexSerializable` trait.  The CEX string should be a single line of input representing a single object.
- *collections of citable objects* are objects of Julia types implementing both the `CexSerializable` trait and `CitableLibrary` package's `CitableLibraryTrait`.  The CEX string should be one more labelled CEX blocks.


## Citable libraries

The `CiteEXchange` package provides an additional `citelibrary` function that can construct an entire `CiteLibrary` from CEX source.  

While citable objects and collections convert CEX to a single object of a specified type, `citelibrary` must build a `CiteLibrary` by interpreting all blocks of the input and instantiating them with appropriate types.  To do this, you need to include a `Dict` mapping the contents of your CEX content to Julia data types (each of which implements `CexSerializable`).  Keys to the `Dict` may be:

- a CEX block heading (e.g., `ctsdata`)
- a `CtsUrn` for text copora
- a `Cite2Urn` for cite collections
- a `Cite2Urn` for relation sets
- a `Cite2Urn` for data models

You may intermix these freely:  the `citelibrary` function will apply the most specific mapping in each case.  For example, you could use a `CtsUrn` to map one specific corpus to a particular Julia type (perhaps for language-specific processing, for example), and map the `ctsdata` block heading to handle all other text corpora.  

Note that all URNs are applied using `urncontains`, so you can map groups of collections, text corpora, relation sets or data models with a single URN.  

The following pages illustrate how this works.  They first define custom types for instantiating text corpora and CITE relation sets, and buid a citable library with both types of content.  Finally, they use `cex` function to make a CEX representation of the entire library, and reinstantiate a library from the CEX source with the `citelibrary` function.


