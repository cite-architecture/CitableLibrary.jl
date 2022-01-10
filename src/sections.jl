"""Hierarchy of abstract types for managing library contents."""
abstract type LibrarySections end

"""`TextSections`` can include `ctsdata` and `ctscatalog` blocks of CEX"""
abstract type TextSections <: LibrarySections end

"""`CollectionSections` can include `citedata`, `citeproperties` and `citecatalog` blocks of CEX."""
abstract type CollectionSections <: LibrarySections 
    

"""`DataModelSections` can include `citedata`, `citeproperties` and `citecatalog` blocks of CEX."""
abstract type DataModelSections <: LibrarySections end


"""`RelationSections` can include `citedata`, `citeproperties` and `citecatalog` blocks of CEX."""
abstract type RelationSections <: LibrarySections end