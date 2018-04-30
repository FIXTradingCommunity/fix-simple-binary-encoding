Introduction
=========================================================================================================================================================

FIX Simple Binary Encoding (SBE) targets high performance trading
systems. It is optimized for low latency of encoding and decoding while
keeping bandwidth utilization reasonably small. For compatibility, it is
intended to represent all FIX semantics.

This encoding specification describes the wire protocol for messages.
Thus, it provides a standard for interoperability between communicating
parties. Users are free to implement the standard in a way that best
suits their needs.

The encoding standard is complimentary to other FIX standards for
session protocol and application level behavior.

Binary type system
----------------------------------------------------------------------------------------------------------------

In order to support traditional FIX semantics, all the documented field
types are supported. However, instead of printable character
representations of tag-value encoding, the type system binds to native
binary data types, and defines derived types as needed.

The binary type system has been enhanced in these ways:

-   Provides a means to specify precision of decimal numbers and
    timestamps, as well as valid ranges of numbers.

-   Differentiates fixed-length character arrays from variable-length
    strings. Allows a way to specify the minimum and maximum length of
    strings that an application can accept.

-   Provides a consistent system of enumerations, Boolean switches and
    multiple-choice fields.

Design principles
---------------------------------------------------------------------------------------------------------------

The message design strives for direct data access without complex
transformations or conditional logic. This is achieved by:

-   Usage of native binary data types and simple types derived from
    native binaries, such as prices and timestamps.

-   Preference for fixed positions and fixed length fields, supporting
    direct access to data and avoiding the need for management of heaps
    of variable-length elements which must be sequentially processed.

Message schema
------------------------------------------------------------------------------------------------------------

This standard describes how fields are encoded and the general structure
of messages. The content of a message type is specified by a message
schema. A message schema tells which fields belong to a message and
their location within a message. Additionally, the metadata describes
valid value ranges and information that need not be sent on the wire,
such as constant values.

Message schemas may be based on standard FIX message specifications, or
may be customized as needed by agreement between counterparties.

Glossary
------------------------------------------------------------------------------------------------------

**Data type** - A field type with its associated encoding attributes,
including backing primitive types and valid values or range. Some types
have additional attributes, e.g. epoch of a date.

**Encoding** - a message format for interchange. The term is commonly used
to mean the conversion of one data format to another, such as text to
binary. However, Simple Binary Encoding strives to use native binary
data types in order to make conversion unnecessary, or at least trivial.
Encoding also refers to the act of formatting a message, as opposed to
decoding.

**Message schema** - metadata that specifies messages and their data
types and identifiers. Message schemas may be disseminated out of band.
For Simple Binary Encoding, message schemas are expressed as an XML
document that conforms to an XML schema that is published as part of
this standard.

**Message template** - metadata that specifies the fields that belong to
one particular message type. A message template is contained by a
message schema.

**Session protocol** - a protocol concerned with the reliable delivery of
messages over a transport. FIX protocol makes a distinction between
session protocol and the encoding of a message payload, as described by
this document. See the specifications section of FIX protocol web site
for supported protocols. The original FIX session protocol is known as
FIXT.

**XML schema** - defines the elements and attributes that may appear in an
XML document. The SBE message schema is defined in W3C (XSD) schema
language since it is the most widely adopted format for XML schemas.

Documentation
-----------------------------------------------------------------------------------------------------------

This document explains:

-   The binary type system for field encoding

-   Message structure, including field arrangement, repeating groups,
    and relationship to a message header that may be provided by a
    session protocol.

-   The Simple Binary Encoding message schema.

### Specification terms

These key words in this document are to be interpreted as described in
[Internet Engineering Task Force RFC2119](http://www.apps.ietf.org/rfc/rfc2119.html). These terms indicate
an absolute requirement for implementations of the standard: "**must**",
or "**required**".

This term indicates an absolute prohibition: "**must not**".

These terms indicate that a feature is allowed by the standard but not
required: "**may**", "**optional**". An implementation that does not
provide an optional feature must be prepared to interoperate with one
that does.

These terms give guidance, recommendation or best practices:
"**should**" or "**recommended**". A recommended choice among
alternatives is described as "**preferred**".

These terms give guidance that a practice is not recommended: "**should not**" 
or "**not recommended**".

### Document format

In this document, these formats are used for technical specifications
and data examples.

This is a sample encoding specification

```xml
<type name="short" primitiveType="int16" semanticType="int" />
```    

This is sample data as it would be transmitted on the wire

`10270000`

References
-------------------------------------------------------------------------------------------------------------------------------------------------------

### Related FIX Standards 

*Simple Open Framing Header*, FIX Protocol, Limited. Version 1.0 Draft Standard
specification has been published at
<http://www.fixtradingcommunity.org/>

For FIX semantics, see the current FIX message specification, which is
currently [FIX 5.0 Service Pack 2](http://www.fixtradingcommunity.org/pg/structure/tech-specs/fix-version/50-service-pack-2)
with Extension Packs.

### Dependencies on other standards 

SBE is dependent on several industry standards. Implementations must
conform to these standards to interoperate. Therefore, they are
normative for SBE.

[IEEE 754-2008](http://ieeexplore.ieee.org/servlet/opac?punumber=4610933) A
Standard for Binary Floating-Point Arithmetic

[ISO 639-1:2002](http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=22109)
Codes for the representation of names of languages - Part 1: Alpha-2
code

[ISO 3166-1:2013](http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=63545)
Codes for the representation of names of countries and their
subdivisions - Part 1: Country codes

[ISO 4217:2015](https://www.iso.org/standard/64758.html)
Codes for the representation of currencies and funds

[ISO 8601:2004](http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=40874)
Data elements and interchange formats - Information interchange -
Representation of dates and times

[ISO 10383:2012](http://www.iso.org/iso/home/store/catalogue_tc/catalogue_detail.htm?csnumber=61067)
Securities and related financial instruments - Codes for exchanges and
market identification (MIC)

XML 1.1 schema standards are located here [W3C XML Schema](http://www.w3.org/XML/Schema.html#dev)
