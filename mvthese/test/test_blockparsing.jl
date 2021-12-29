
@testset "Test parsing relation set" begin
    s = """#!citerelationset
urn|urn:cite2:hmt:dse.v1:msBil4
label|Collection of DSE records for Venetus text of Proclus, Chrestomathy
passage|imageroi|surface


urn:cts:greekLit:tlg4036.tlg023.va:Homer.title|urn:cite2:hmt:vaimg.2017a:VA001RN_0002@0.1580,0.1633,0.4740,0.05302|urn:cite2:hmt:msA.v1:1r
"""
   expected = [Cite2Urn("urn:cite2:hmt:dse.v1:msBil4")]
   @test relationsets(blocks(s)) == expected
end



@testset "Test parsing data model" begin
    s = """#!datamodels
Collection#Model#Label#Description
urn:cite2:hmt:burney86pages.v1:#urn:cite2:cite:datamodels.v1:tbsmodel#Model of Burney 86 codex#British Library, Bureny 86, in the CITE model of a sequence of text-bearing surfaces
"""
    expected = [Cite2Urn("urn:cite2:hmt:burney86pages.v1:")]
    @test datamodels(blocks(s), delimiter = "#") == expected
end