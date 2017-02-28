 Message Schema
==========================================================================================================================================================================================================

XML schema for SBE message schemas
---------
See [sbe.xsd](../resources/sbe.xsd) for the normative XML Schema Definition (XSD) for SBE.


XML namespace
-----------------------------------------------------------------------------------------------------------

The Simple Binary Encoding XML schema is identified by this URL [*tentative*]:

```xml
xmlns:sbe=http://fixprotocol.io/2017/sbe 
```

Conventionally, the URI of the XML schema is aliased by the prefix
"sbe".

*Caution:* Users should treat the SBE XML namespace as a URI (unique identifier),
not as a URL (physical resource locator). Firms should not depend on
access to the FIX Trading Community web site to validate XML schemas at
run-time

Name convention
-------------------------------------------------------------------------------------------------------------

All symbolic names in a message schema are restricted to alphanumeric
characters plus underscore without spaces. This is the same restriction
applied to all names in FIX specifications.

### Capitalization 

The value of a field's `semanticType` attribute is a FIX data type. In
this document, FIX types are capitalized exactly as in the FIX
repository, from which all official FIX documentation and references are
derived. Since the capitalization is somewhat inconsistent, however, it
is recommended that matching of type names should be case insensitive in
schema parsers.

Root element
------------

The root element of the XML document is `<messageSchema>`.

### `<messageSchema>` attributes

The root element provides basic identification of a schema.

The `byteOrder` attribute controls the byte order of integer encodings
within the schema. It is a global setting for all specified messages and
their encodings.

| Schema attribute | Description                                                                                      | XML type           | Usage                  | Valid values                                                                 |
|------------------|--------------------------------------------------------------------------------------------------|--------------------|------------------------|------------------------------------------------------------------------------|
| package          | Name or category of a schema                                                                     | string             | optional               | Should be unique between counterparties but no naming convention is imposed. |
| id               | Unique identifier of a schema                                                                    | unsignedInt        |                        | Should be unique between counterparties                                      |
| version          | Version of this schema                                                                           | nonnegativeInteger |                        | Initial version is zero and is incremented for each version                  |
| semanticVersion  | Version of FIX semantics                                                                         | string             | optional               | FIX versions, such as “FIX.5.0\_SP2”                                         |
| byteOrder        | Byte order of encoding                                                                           | token              | default = littleEndian | littleEndian  bigEndian                                                                                                             |
| description      | Documentation of the schema                                                                      | string             | optional               |                                                                              |
| headerType       | Name of the encoding type of the message header, which is the same for all messages in a schema. | string             | default= messageHeader | An encoding with this name must be contained by '<types>`.                   |


### Schema versioning

Changes to a message schema may be tracked by its `version` attribute. A
version of a schema is a snapshot in time. All elements in a given
generation of the schema share the same version number. That is,
elements are not versioned individually. By convention, the initial
version of a schema is version zero, and subsequent changes increment
the version number.

The `package` attribute should remain constant between versions, if it is
supplied.

Data encodings
------------------------------------------------------------------------------------------------------------

### Encoding sets 

The `<types>` element contains one or more sets of data encodings used
for messages within the schema.

Within each set, an unbound number of encodings will be listed in any
sequence:

-   Element `<type>` defines a simple encoding

-   Element `<composite>` defines a composite encoding

-   Element `<enum>` defines an enumeration

-   Element `<set>` defines a multi-value choice bitset encoding

### Encoding name

The namespace for encoding names is global across all encodings included
in a schema, including simple, composite and enumeration types. That is,
the name must be unique among all encoding instances.

All symbolic names should be alphanumeric without spaces.


#### Importing encodings

A suggested usage is to import common encodings that are used across
message schemas as one set while defining custom encodings that are
particular to a schema in another set.

Example of XML include usage to import common encoding types

```xml
<!-- included XML contains a <types> element -->
<xi:include href="sbe-builtins.xml"/>
```

### Simple encodings

A simple encoding is backed by either a scalar type or an array of
scalars, such as a character array. One or more simple encodings may be
defined, each specified by a `<type>` element.

#### `<type>` element content

If the element has a value, it is used to indicate a special value of
the encoding.

##### Constant value

The element value represents a constant if attribute
`presence="constant"`. In this case, the value is conditionally required.

#### `<type>` attributes


| `<type>` attribute | Description                                                                                                                                                                                            | XML type           | Usage                             | Valid values                                                                           |
|--------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------|-----------------------------------|----------------------------------------------------------------------------------------|
| name               | Name of encoding                                                                                                                                                                                       | symbolicName\_t    | required                          | Must be unique among all encoding types in a schema.                                   |
| description        | Documentation of the type                                                                                                                                                                              | string             | optional                          |                                                                                        |
| presence           | Presence of any field encoded with this type                                                                                                                                                           | token              |  | required optional  constant                                                                                |
| nullValue          | Override of special value used to indicate null for an optional field                                                                                                                                  | string             | Only valid if presence = optional | The XML string must be convertible to the scalar data type specified by primitiveType. |
| minValue           | Lowest acceptable value                                                                                                                                                                                | string             |                                   |                                                                                        |
| maxValue           | Highest acceptable value                                                                                                                                                                               | string             |                                   |                                                                                        |
| length             | Number of elements of the primitive data type                                                                                                                                                          | nonnegativeInteger | default = 1                       | Value “0” represents variable length.                                                  |
| offset             | If a member of a composite type, tells the offset from the beginning of the composite. By default, the offset is the sum of preceding element sizes, but it may be increased to effect byte alignment. | unsignedInt        | optional                          | See section 4.4.4.3 below                                                              |
| primitiveType      | The primitive data type that backs the encoding                                                                                                                                                        | token              | required                          | char int8 int16 int32 int64 uint8 uint16 uint32 uint64 float double                                                      |
| semanticType       | Represents a FIX data type                                                                                                                                                                             | token              | optional                          | Same as field semanticType – see below.                                                |
| sinceVersion       | Documents the version of a schema in which a type was added                                                                                                                                            | nonnegativeInteger | default = 0                       | Must be less than or equal to the version of the message schema.                       |
| deprecated         | Documents the version of a schema in which a type was deprecated. It should no longer be used in new messages.                                                                                         | nonnegativeInteger | optional                          | Must be less than or equal to the version of the message schema.                       |

#### FIX data type specification

The attribute `semanticType` must be specified on either a field or on its
corresponding type encoding. It need not be specified in both places,
but if it is, the two values must match.

Simple type examples

```xml
<type name="FLOAT" primitiveType="double"
 semanticType="float"/>
<type name="TIMESTAMP" primitiveType="uint64"
 semanticType="UTCTimestamp"/>
<type name="GeneralIdentifier" primitiveType="char"
 description="Identifies class or source
 of the PartyID" presence="constant">C</type>
```

### Composite encodings

Composite encoding types are composed of two or more simple types.

#### `<composite>` attributes

| `<composite>` attribute | Description                                                                                                    | XML type           | Usage       | Valid values                                                     |
|--------------------|----------------------------------------------------------------------------------------------------------------|--------------------|-------------|------------------------------------------------------------------|
| name               | Name of encoding                                                                                               | symbolicName\_t    | required    | Must be unique among all encoding types.                         |
| offset             | The offset from the beginning of the composite. By default, the offset is the sum of preceding element sizes, but it may be increased to effect byte alignment. | unsignedInt        | optional                          |  |
| description        | Documentation of the type                                                                                      | string             | optional    |                                                                  |
| semanticType       | Represents a FIX data type                                                                                     | token              | optional    | Same as field semanticType – see below.                          |
| sinceVersion       | Documents the version of a schema in which a type was added                                                    | nonnegativeInteger | default = 0 | Must be less than or equal to the version of the message schema. |
| deprecated         | Documents the version of a schema in which a type was deprecated. It should no longer be used in new messages. | nonnegativeInteger | optional    | Must be less than or equal to the version of the message schema. |

#### Composite type elements

A `<composite>` composite encoding element may be composed of any
combination of types, including `<type>` simple encoding, `<enum>`
enumeration, `<set>` bitset, and nested composite type. The elements
that compose a composite type carry the same XML attributes as
stand-alone types.

Composite type example

In this example, a Price is encoded as 32 bit integer mantissa and a
constant exponent, which is not sent on the wire.

```xml
<composite name="decimal32" semanticType="Price">
    <type name="mantissa" primitiveType="int32" />
    <type name="exponent" primitiveType="int8"
      presence="constant">-4</type>
</composite>
```

#### Element offset within a composite type

If a message designer wishes to control byte boundary alignment or map
to an existing data structure, element offset may optionally be
specified on a simple type, enum or bitset within a composite type. Offset is the number
of octets from the start of the composite; it is a zero-based index.

If specified, offset must be greater than or equal to the sum of the
sizes of prior elements. In other words, an offset is invalid if it
would cause elements to overlap.

#### Null value of a composite type

For a composite type, nullness is indicated by the value of its first
element. For example, if a price field is optional, a null value in its
mantissa element indicates that the price is null.

### Reference to reusable types

A composite type often has its elements defined in-line within the `<composite>` XML element as shown in the example above. Alternatively, a common type may be defined once on its own, and then referred to by name with the composite type using a `<ref>` element.

#### `<ref>` attributes

| `<ref>` attribute | Description                                                                                                    | XML type           | Usage       | Valid values                                                     |
|--------------------|----------------------------------------------------------------------------------------------------------------|--------------------|-------------|------------------------------------------------------------------|
| name               | Usage of the type in this composite | symbolicName\_t    | required    |       |
| type               | Name of referenced encoding         | symbolicName\_t    | required    | Must match a defined type, enum or set or composite name attribute. |
| offset             | The offset from the beginning of the composite. By default, the offset is the sum of preceding element sizes, but it may be increased to effect byte alignment. | unsignedInt        | optional                          |  |
| sinceVersion       | Documents the version of a schema in which a type was added                                                    | nonnegativeInteger | default = 0 | Must be less than or equal to the version of the message schema. |
| deprecated         | Documents the version of a schema in which a type was deprecated. It should no longer be used in new messages. | nonnegativeInteger | optional    | Must be less than or equal to the version of the message schema. |

#### Type reference examples

**Reference to an enum**

In this example, a futuresPrice is encoded as 64 bit integer mantissa,  8 bit exponent, and a reused enum type. 

```xml
<enum name="booleanEnum" encodingType="uint8" semanticType="Boolean">
    <validValue name="false">0</validValue>
    <validValue name="true">1</validValue>
</enum>

<composite name="futuresPrice">
    <type name="mantissa" primitiveType="int64" />
    <type name="exponent" primitiveType="int8" />
    <ref name="isSettlement" type="boolEnum" />
</composite>	
```

**Reference to a composite type**

In this example, a nested composite is formed by using a reference to another composite type. It supports the expresson of a monetary amount with its currency, such as USD150.45. Note that a reference may carry an offset within the composite encoding that contains it.

```xml
<composite name="price">
    <type name="mantissa" primitiveType="int64" />
    <type name="exponent" primitiveType="int8" />
</composite>	

<composite name="money">
    <type name="currencyCode" primitiveType="char" length="3" semanticType="Currency" />
    <ref name="amount" type="price" semanticType="Price" offset="3" />
</composite>	
```

### Enumeration encodings

An enumeration explicitly lists the valid values of a data domain. Any
number of fields may share the same enumeration.

#### `<enum>` element

Each enumeration is represented by an `<enum>` element. It contains any
number of `<validValue>` elements.

The `encodingType` attribute refers to a simple encoding of scalar type.
The encoding of an enumeration may be char or any unsigned integer type.

| `<enum>` attribute | Description                                                                                                    | XML type           | Usage       | Valid values                                                                      |
|--------------------|----------------------------------------------------------------------------------------------------------------|--------------------|-------------|-----------------------------------------------------------------------------------|
| name               | Name of encoding                                                                                               | symbolicName\_t    | required    | Must be unique among all encoding types.                                          |
| description        | Documentation of the type                                                                                      | string             | optional    |                                                                                   |
| encodingType       | Name of a simple encoding type                                                                                 | symbolicName\_t    | required    | Must match the name attribute of a scalar `<type>` element *or* a primitive type: char uint8 uint16 uint32 uint64 | 
| sinceVersion       | Documents the version of a schema in which a type was added                                                    | nonnegativeInteger | default = 0 | Must be less than or equal to the version of the message schema.                  |
| deprecated         | Documents the version of a schema in which a type was deprecated. It should no longer be used in new messages. | nonnegativeInteger | optional    | Must be less than or equal to the version of the message schema.                  |
| offset             | If a member of a composite type, tells the offset from the beginning of the composite. By default, the offset is the sum of preceding element sizes, but it may be increased to effect byte alignment. | unsignedInt        | optional                          |

#### `<validValue>` element attributes

The name attribute of the `<validValue>` uniquely identifies it.

| `<validValue>` attribute | Description                                                                                                     | XML type           | Usage       | Valid values                                                     |
|--------------------|-----------------------------------------------------------------------------------------------------------------|--------------------|-------------|------------------------------------------------------------------|
| name               | Symbolic name of value                                                                                          | symbolicName\_t    | required    | Must be unique among valid values in the enumeration.            |
| description        | Documentation of the value                                                                                      | string             | optional    |                                                                  |
| sinceVersion       | Documents the version of a schema in which a value was added                                                    | nonNegativeInteger | default = 0 |                                                                  |
| deprecated         | Documents the version of a schema in which a value was deprecated. It should no longer be used in new messages. | nonnegativeInteger | optional    | Must be less than or equal to the version of the message schema. |

#### `<validValue>` element content

The element is required to carry a value, which is the valid value as a
string. The string value in XML must be convertible to the data type of
the encoding, such as an integer.

`<enum>` and `<validValue>` elements

Enumeration example (not all valid values listed)

This enumeration is encoded as an 8 bit unsigned integer value. Others
are encoded as char codes.

```xml
<type name="intEnum" primitiveType="uint8" />

<enum name="PartyRole" encodingType="intEnum">
    <validValue name="ExecutingFirm">1</validValue>
    <validValue name="BrokerOfCredit">2</validValue>
    <validValue name="ClientID">3</validValue>
    <validValue name="ClearingFirm">4</validValue>
</enum>
```

### Multi-value choice encodings (bitset)

An enumeration explicitly lists the valid values of a data domain. Any
number of fields may share the same set of choices.

#### `<set>` element

Each multi-value choice is represented by a `<set>` element. It may
contain a number of `<choice>` elements up to the number of bits in the
primitive encoding type. The largest number possible is 64 choices in a
uint64 encoding.

The `encodingType` attribute refers to a simple encoding of scalar type.
The encoding of a bitset should be an unsigned integer type.

| `<set>` attribute | Description                                                                                                    | XML type           | Usage       | Valid values                                                                      |
|-------------------|----------------------------------------------------------------------------------------------------------------|--------------------|-------------|-----------------------------------------------------------------------------------|
| name              | Name of encoding                                                                                               | symbolicName\_t    | required    | Must be unique among all encoding types.                                          |
| description       | Documentation of the type                                                                                      | string             | optional    |                                                                                   |
| encodingType      | Name of a simple encoding type                                                                                 | string             | required    | Must match the name attribute of a scalar `<type>` element *or* a primitive type: uint8 uint16 uint32 uint64                                                                          |
| sinceVersion      | Documents the version of a schema in which a type was added                                                    | nonnegativeInteger | default = 0 | Must be less than or equal to the version of the message schema.                  |
| deprecated        | Documents the version of a schema in which a type was deprecated. It should no longer be used in new messages. | nonnegativeInteger | optional    | Must be less than or equal to the version of the message schema.       
| offset             | If a member of a composite type, tells the offset from the beginning of the composite. By default, the offset is the sum of preceding element sizes, but it may be increased to effect byte alignment. | unsignedInt        | optional                          |

#### `<choice>` element attributes

The `name` attribute of the `<choice>` uniquely identifies it.

| `<choice>` attribute | Description                                                                                                      | XML type           | Usage       | Valid values                                                     |
|----------------------|------------------------------------------------------------------------------------------------------------------|--------------------|-------------|------------------------------------------------------------------|
| name                 | Symbolic name of value                                                                                           | symbolicName\_t    | required    | Must be unique among choices in the set.                         |
| description          | Documentation of the value                                                                                       | string             | optional    |                                                                  |
| sinceVersion         | Documents the version of a schema in which a choice was added                                                    | nonNegativeInteger | default = 0 |                                                                  |
| deprecated           | Documents the version of a schema in which a choice was deprecated. It should no longer be used in new messages. | nonnegativeInteger | optional    | Must be less than or equal to the version of the message schema. |

#### `< choice >` element content

The element is required to carry a value, which is an unsigned integer
representing a zero-based index to a bit within a bitset. Zero is the
least significant bit.

`<set>` and `<choice>` XML elements

Multi-value choice example, The choice is encoded as a bitset.

```xml
<type name="bitset" primitiveType="uint8" />

<set name="Scope" encodingType="bitset" >
    <choice name="LocalMarket">0</choice>
    <choice name="National">1</choice>
    <choice name="Global">2</choice>
</set>
```

Message template
--------------------------------------------------------------------------------------------------------------

To define a message type, add a `<message>` element to the root element
of the XML document, `<messageSchema>`.

The `name` and `id` attributes are required. The first is a display name for
a message, while the latter is a unique numeric identifier, commonly
called template ID.

### Reserved space

By default, message size is the sum of its field lengths. However, a
larger size may be reserved by setting blockLength, either to allow for
future growth or for desired byte alignment. If so, the extra reserved
space should be filled with zeros by message encoders.

### Message members

A `<message>` element contains its field definitions in three
categories, which must appear in this sequence:

1.  Element `<field>` defines a fixed-length field

2.  Element `<group>` defines a repeating group

3.  Element `<data>` defines a variable-length field, such as raw data

The number of members of each type is unbound.

### Member order

The order that fields are listed in the message schema governs the order
that they are encoded on the wire.

**`<message>` element attributes**
 
| `<message>` attribute | Description                                                                                                                                | XML type           | Usage       | Valid values                                                             |
|-----------------------|--------------------------------------------------------------------------------------------------------------------------------------------|--------------------|-------------|--------------------------------------------------------------------------|
| name                  | Name of a message                                                                                                                          | symbolicName\_t    | required    | Must be unique among all messages in a schema                            |
| id                    | Unique message template identifier                                                                                                         | unsignedInt        | required    | Must be unique within a schema                                           |
| description           | Documentation                                                                                                                              | string             | optional    |                                                                          |
| blockLength           | Reserved size in number of octets for root level of message body                                                                           | unsignedInt        | optional    | If specified, must be greater than or equal to the sum of field lengths. |
| semanticType          | Documents value of FIX MsgType for a message                                                                                               | token              | optional    | Listed in FIX specifications                                             |
| sinceVersion          | Documents the version of a schema in which a message was added                                                                             | nonNegativeInteger | default = 0 |                                                                          |
| deprecated            | Documents the version of a schema in which a message was deprecated. It should no longer be sent but is documented for back-compatibility. | nonnegativeInteger | optional    | Must be less than or equal to the version of the message schema.         |

Note that there need not be a one-to-one relationship between message
template (identified by `id` attribute) and `semanticType` attribute. You
might design multiple templates for the same FIX MsgType to optimize
different scenarios.

Example `<message>` element

```xml
<sbe:message name="NewOrderSingle" id="2" semanticType="D">
```

Field attributes
--------------------------------------------------------------------------------------------------------------

Fields are added to a `<message>` element as child elements. See Field
Encoding section above for a listing of all field types.

These are the common attributes of all field types.


| Schema attribute | Description                                                                                                                                                                               | XML type            | Usage                              | Valid values                                                                                          |
|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|------------------------------------|-------------------------------------------------------------------------------------------------------|
| name             | Name of a field                                                                                                                                                                           | symbolicName\_t     | required                           | Name and id must uniquely identify a field type within a message schema.                              |
| id               | Unique field identifier (FIX tag)                                                                                                                                                         | unsignedShort       | required                           |                                                                                                       |
| description      | Documentation                                                                                                                                                                             | string              | optional                           |                                                                                                       |
| type             | Encoding type name, one of simple type, composite type or enumeration.                                                                                                                    | string              | required                           | Must match the name attribute of a simple `<type>`, `<composite>` encoding type, `<enum>` or `<set>`. |
| offset           | Offset to the start of the field within a message or repeating group entry. By default, the offset is the sum of preceding field sizes, but it may be increased to effect byte alignment. | unsignedInt         | optional                           | Must be greater than or equal to the sum of preceding field sizes.                                    |
| presence         | Field presence                                                                                                                                                                            | enumeration         | Default = required                 | required = field value is required; not tested for null.                                                                                                                                                                                                                                                       optional = field value may be null.  constant = constant value not sent on wire.                                                                                                                         |
| valueRef         | Constant value of a field as a valid value of an enumeration                                                                                                                              | qualifiedName\_t    | optional  Valid only if presence= ”constant”  | If provided, the qualified name must match the name attribute of a `<validValue>` within an `<enum>`  |
| sinceVersion     | The version of a message schema in which this field was added.                                                                                                                            | InonnegativeInteger | default=0                          | Must not be greater than version attribute of `<messageSchema>` element.                              |
| deprecated       | Documents the version of a schema in which a field was deprecated. It should no longer be used in new messages.                                                                           | nonnegativeInteger  | optional                           | Must be less than or equal to the version of the message schema.                                      |


Example field schemas

Field that uses a composite encoding

```xml
<composite name="intQty32" semanticType="Qty">
    <type name="mantissa" primitiveType="int32" />
   <type name="exponent" primitiveType="int8"
    presence="constant">0\</type>
</composite>

<field type="intQty32" name="OrderQty" id="38" offset="16"
  description="Shares: Total number of shares" />
```

Repeating group schema
--------------------------------------------------------------------------------------------------------------------

A `<group>` has the same attributes as a `<message>` element since they
both inherit attributes from the blockType XML type. A group has the
same child members as a message, and they must appear in the same order:

1.  Element `<field>` defines a fixed-length field

2.  Element `<group>` defines a repeating group. Groups may be nested to
    any level.

3.  Element `<data>` defines a variable-length field, such as raw data

The number of members of each type is unbound.


| `<group>` attribute | Description                       | XML type        | Usage                       | Valid values                                                             |
|---------------------|-----------------------------------|-----------------|-----------------------------|--------------------------------------------------------------------------|
| name                | Name of a group                   | symbolicName\_t | required                    | Name and id must uniquely identify a group type within a message schema. |
| id                  | Unique group identifier           | unsignedShort   | required                    |                                                                          |
| description         | Documentation                     | string          | optional                    |                                                                          |
| dimensionType       | Dimensions of the repeating group | symbolicName\_t | default = groupSizeEncoding | If specified, must be greater than or equal to the sum of field lengths. |

`<group>` element inherits attributes of blockType. See `<message>`
above.

*Example group schema with default dimension encoding*

```xml
<composite name="groupSizeEncoding">
    <type name="blockLength" primitiveType="uint16"/>
    <type name="numInGroup" primitiveType="uint16"
     semanticType="NumInGroup"/>
</composite>

<group name="Parties" id="1012" >
    <field type="string14" name="PartyID" id="448" />
    <field type="partyRoleEnum" name="PartyRole" id="452" />
</group>
```

Schema validation
--------------------------------------------------------------------------------------------------------------------------------------------------------------

The first level of schema validation is enforced by XML schema
validation tools to make sure that a schema is well-formed according to
XSD schema rules. Well-formed XML is necessary but insufficient to prove
that a schema is correct according to FIX Simple Binary Encoding rules.

Additional conditions that render a schema invalid include the
following.

| Error condition                                                | Error description                                                                                                                                                                                                                                                                                             |
|----------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Missing field encoding                                         | A field or `<enum>` references a type name that is undefined.                                                                                                                                                                                                                                                 |
| Missing message header encoding                                | Missing encoding type for headerType specified in `<messageSchema>`. Default name is “messageHeader”.                                                                                                                                                                                                         |
| Duplicate encoding name                                        | An encoding name is non-unique, rendering a reference ambiguous.                                                                                                                                                                                                                                              |
| nullValue specified for non-null encoding                      | Attribute nullValue is inconsistent with presence=required or constant                                                                                                                                                                                                                                        |
| Attributes nullValue, minValue or maxValue of wrong data range | The specified values must be convertible to a scalar value consistent with the encoding. For example, if the primitive type is uint8, then the value must be in the range 0 through 255.                                                                                                                      |
| semanticType mismatch                                          | If the attribute is specified on both a field and the encoding that it references, the values must be identical.                                                                                                                                                                                              |
| presence mismatch                                              | If the attribute is specified on both a field and the encoding that it references, the values must be identical.                                                                                                                                                                                              |
| Missing constant value                                         | If presence=constant is specified for a field or encoding, the element value must contain the constant value.                                                                                                                                                                                                 |
| Missing validValue content                                     | A `<validValue>` element is required to carry its value.                                                                                                                                                                                                                                                      |
| Incompatible offset and blockLength                            | A field offset greater than message or group blockLength is invalid                                                                                                                                                                                                                                           |
| Duplicate ID or name of field or group                         | Attributes id and name must uniquely identify a type within a message schema. This applies to fields and groups. To be clear, the same field or group ID may be used in multiple messages, but each instance must represent the same type. Each of those instances must match on both id and name attributes. |

### Message with a repeating group

```xml
<message name="ListOrder" id="2" description="Simplified
 NewOrderList. Demonstrates repeating group">
    <field name="ListID" id="66" type="string14" semanticType="String"/>
    <field name="BidType" id="394" type="uint8" semanticType="int"/>
    <group name="ListOrdGrp" id="2030" >
        <field name="ClOrdID" id="11" type="string14" semanticType="String"/>
        <field name="ListSeqNo" id="67" type="uint32" semanticType="int"/>
        <field name="Symbol" id="55" type="string8" semanticType="String"/>
        <field name="Side" id="54" type="char" semanticType="char"/>
        <field name="OrderQty" id="38" type="intQty32" semanticType="Qty"/>
    </group>
</message>
```

### Message with raw data fields

```xml
<message name="UserRequest" id="4" description="Demonstrates raw data usage">
    <field name="UserRequestId" id="923" type="string14" semanticType="String"/>
    <field name="UserRequestType" id="924" type="uint8" semanticType="int"/>
    <field name="UserName" id="553" type="string14" semanticType="String"/>
    <field name="Password" id="554" type="string14" semanticType="String"/>
    <field name="NewPassword" id="925" type="string14" semanticType="String"/>
    <field name="EncryptedPasswordMethod" id="1400" type="uint8" description="This should be an enum but values undefined."
     semanticType="int"/>
    <field name="EncryptedPasswordLen" id="1401" type="uint8" semanticType="Length"/>
    <field name="EncryptedNewPasswordLen" id="1403" type="uint8" semanticType="Length"/>
    <field name="RawDataLength" id="95" type="uint8" semanticType="Length"/>
    <data name="EncryptedPassword" id="1402" type="rawData" semanticType="data"/>
    <data name="EncryptedNewPassword" id="1404" type="rawData" semanticType="data"/>
    <data name="RawData" id="96" type="rawData" semanticType="data"/>
</message>
```

Reserved element names
----------------------

### Composite types

| Encoding type name (default names) |
|------------------------------------|
| messageHeader                      |
| groupSizeEncoding                  |

### Composite type elements

| Type name      | Composite type              |
|----------------|-----------------------------|
| blockLength    | messageHeader and groupSize |
| day            | MonthYear                   |
| exponent       | decimal                     |
| mantissa       | decimal                     |
| month          | MonthYear                   |
| numInGroup     | groupSize                   |
| templateId     | messageHeader               |
| time           | timestamp, TZ time          |
| timezoneHour   | TZ time                     |
| timezoneMinute | TZ time                     |
| unit           | timestamp, TZ time          |
| version        | messageHeader               |
| week           | MonthYear                   |
| year           | MonthYear                   |
