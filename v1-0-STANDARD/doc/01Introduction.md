# Scope

This document provides the normative specification of Simple Binary Encoding (SBE), which is one of the possible syntaxes for FIX messages, but not limited to FIX messages. The scope comprises the encoding (wire format) and the message schema for SBE.

# Normative references

The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.

--- IETF RFC 2119 -- *Key words for use in RFCs to Indicate Requirement Levels* March 1997

# Terms and definitions

For the purposes of this document, the terms and definitions given in ISO/IEC 11404 and the following apply.

ISO and IEC maintain terminological databases for use in standardization at the following addresses:

—--	ISO Online browsing platform: available at [https://www.iso.org/obp](https://www.iso.org/obp)

—--	IEC Electropedia: available at [http://www.electropedia.org/](http://www.electropedia.org/)


## datatype
field type with its associated encoding attributes

Note 1 to entry: Includes backing primitive types and valid values or range. Some types
have additional attributes, e.g. epoch of a date.

## encoding
message format for interchange

Note 1 to entry: The term is commonly used
to mean the conversion of one data format to another, such as text to
binary. However, SBE strives to use native binary
datatypes in order to make conversion unnecessary, or at least trivial.

Note 2 to entry: Encoding also refers to the act of formatting a message, as opposed to decoding.

## message schema
metadata that specifies messages and their data types and identifiers

Note 1 to entry: Message schemas may be disseminated out of band.

Note 2 to entry: For SBE, message schemas are expressed as an XML
document that conforms to an XML schema that is published as part of this standard.

## message template
metadata that specifies the fields that belong to one particular message type

Note 1 to entry: A message template is contained by a
message schema.

## session protocol
protocol concerned with the reliable delivery of messages over a transport.

Note 1 to entry: FIX makes a distinction between
session protocol and the encoding of a message payload, as described by
this document. See the [specifications section](https://www.fixtrading.org/standards/) of the FIX Protocol web site
for supported session protocols and encodings.

## XML schema
defines the elements and attributes that may appear in an XML document.

Note 1 to entry: The SBE message schema is defined in W3C (XSD) schema
language since it is the most widely adopted format for XML schemas.

## Specification terms
These key words in this document are to be interpreted as described in IETF RFC 2119.

# Objectives

## General

SBE targets high performance trading systems. It is optimized for low latency of encoding and decoding while
keeping bandwidth utilization reasonably small. For compatibility, it is intended to represent all FIX semantics.

This encoding specification describes the wire protocol for messages.
Thus, it provides a standard for interoperability between communicating
parties. Users are free to implement the standard in a way that best
suits their needs.

The encoding standard is complementary to other FIX standards for
session protocol and application level behavior.

## Binary type system

In order to support traditional FIX semantics, all the documented field
types are supported. However, instead of printable character
representations of tag-value encoding, the type system binds to native
binary datatypes, and defines derived types as needed.

The binary type system has been enhanced in these ways:

-   Provides a means to specify precision of decimal numbers and
    timestamps, as well as valid ranges of numbers.

-   Differentiates fixed-length character arrays from variable-length
    strings. Allows a way to specify the minimum and maximum length of
    strings that an application can accept.

-   Provides a consistent system of enumerations, Boolean switches and
    multiple-choice fields.

## Design principles

The message design strives for direct data access without complex
transformations or conditional logic. This is achieved by:

-   Usage of native binary datatypes and simple types derived from
    native binaries, such as prices and timestamps.

-   Preference for fixed positions and fixed length fields, supporting
    direct access to data and avoiding the need for management of heaps
    of variable-length elements which must be sequentially processed.

## Message schema

This standard describes how fields are encoded and the general structure
of messages. The content of a message type is specified by a message
schema. A message schema tells which fields belong to a message and
their location within a message. Additionally, the metadata describes
valid value ranges and information that need not be sent on the wire,
such as constant values.

Message schemas may be based on standard FIX message specifications or
may be customized as needed by agreement between counterparties.

## Documentation

### General

This document explains:

-   The binary type system for field encoding

-   Message structure, including field arrangement, repeating groups,
    and relationship to a message header that may be provided by a
    session protocol.

-   The SBE message schema.

### Document format

In this document, these formats are used for technical specifications
and data examples.

This is a sample encoding specification

```xml
<type name="short" primitiveType="int16" semanticType="int"/>
```    

This is sample data as it would be transmitted on the wire

`10270000`
