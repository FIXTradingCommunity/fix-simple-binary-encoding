Field Encoding
===========================================================================================================================================================

Field aspects
-----------------------------------------------------------------------------------------------------------

A field is a unit of data contained by a FIX message. Every field has
the following aspects: semantic data type, encoding, and metadata. They
will be specified in more detail in the sections on data type encoding
and message schema but are introduced here as an overview.

### Semantic data type

The FIX semantic data type of a field tells a data domain in a broad
sense, for example, whether it is numeric or character data, or whether
it represents a time or price. Simple Binary Encoding represents all of
the semantic data types that FIX protocol has defined across all
encodings. In message specifications, FIX data type is declared with
attribute semanticType. See the section 2.2 below for a listing of those
FIX types.

### Encoding

Encoding tells how a field of a specific data type is encoded on the
wire. An encoding maps a FIX data type to either a simple, primitive
data type, such as a 32 bit signed integer, or to a composite type. A
composite type is composed of two or more simple primitive types. For
example, the FIX data type Price is encoded as a decimal, a composite
type containing a mantissa and an exponent. Note that many fields may
share a data type and an encoding. The sections that follow explain the
valid encodings for each data type.

### Metadata

Field metadata, part of a message schema, describes a field to
application developers. Elements of field metadata are:

-   Field ID, also known as FIX tag, is a unique identifier of a field
    for semantic purposes. For example, tag 55 identifies the Symbol
    field of an instrument.

-   Field name, as it is known in FIX specifications

-   The FIX semantic data type and encoding type that it maps to

-   Valid values or data range accepted

-   Documentation

Metadata is normally *not* sent on the wire with Simple Binary Encoding
messages. It is necessary to possess the message schema that was used to
encode a message in order to decode it. In other words, Simple Binary
Encoding messages are not self-describing. Rather, message schemas are
typically exchanged out-of-band between counterparties.

See section 4 below for a detailed message schema specification.

### Field presence

By default, fields are assumed to be required in a message. However,
fields may be specified as optional. To indicate that a value is not
set, a special null indicator value is sent on the wire. The null value
varies according to data type and encoding. Global defaults for null
value may be overridden in a message schema by explicitly specifying the
value that indicates nullness.

Alternatively, fields may be specified as constant. In which case, the
data is not sent on the wire, but may be treated as constants by
applications.

### Default value

Default value handling is not specified by the encoding layer. A null
value of an optional field does not necessarily imply that a default
value should be applied. Rather, default handling is left to application
layer specifications.

FIX data type summary
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

FIX semantic types are mapped to binary field encodings as follows. See
sections below for more detail about each type.

Schema attributes may restrict the range of valid values for a field.
See Common field schema attributes below.

| FIX semantic type                | Binary type                                                                               | Section | Description                                                                                                                                                                              |
|----------------------------------|-------------------------------------------------------------------------------------------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| int                              | Integer encoding                                                                          | 2.4     | An integer number                                                                                                                                                                        |
| Length                           | Integer encoding                                                                          | 2.4     | Field length in octets. Value must be non-negative.                                                                                                                                      |
| TagNum                           | Integer encoding                                                                          | 2.4     | A field's tag number. Value must be positive.                                                                                                                                            |
| SeqNum                           | Integer encoding                                                                          | 2.4     | A field representing a message sequence number. Value must be positive                                                                                                                   |
| NumInGroup                       | Group dimension encoding                                                                  | 3.4.8   | A counter representing the number of entries in a repeating group. Value must be positive.                                                                                               |
| DayOfMonth                       | Integer encoding                                                                          | 2.4     | A field representing a day during a particular month (values 1 to 31).                                                                                                                   |
| Qty                              | Decimal encoding                                                                          | 2.5     | A number representing quantity of a security, such as shares. The encoding may constrain values to integers, if desired.                                                                 |
| float                            | Float encoding                                                                            | 2.5     | A real number with binary representation of specified precision                                                                                                                          |
| Price                            | Decimal encoding                                                                          | 2.5     | A decimal number representing a price                                                                                                                                                    |
| PriceOffset                      | Decimal encoding                                                                          | 2.5     | A decimal number representing a price offset, which can be mathematically added to a Price.                                                                                              |
| Amt                              | Decimal encoding                                                                          | 2.5     | A field typically representing a Price times a Qty.                                                                                                                                      |
| Percentage                       | Decimal encoding                                                                          | 2.5     | A field representing a percentage (e.g. 0.05 represents 5% and 0.9525 represents 95.25%).                                                                                                |
| char                             | Character                                                                                 | 2.7.1   | Single US-ASCII character value. Can include any alphanumeric character or punctuation. All char fields are case sensitive (i.e. m != M).                                                |
| String                           | Fixed-length character array                                                              | 2.7.2   | A fixed-length character array of ASCII encoding                                                                                                                                         |
| String                           | Variable-length data encoding                                                             | 2.7.3   | Alpha-numeric free format strings can include any character or punctuation. All String fields are case sensitive (i.e. morstatt != Morstatt). ASCII encoding.                            |
| String—EncodedText               | String encoding                                                                           | 2.7.3   | Non-ASCII string. The character encoding may be specified by a schema attribute.                                                                                                         |
| XMLData                          | String encoding                                                                           | 2.7.3   | Variable-length XML. Must be paired with a Length field.                                                                                                                                 |
| data                             | Fixed-length data                                                                         | 2.8.1   | Fixed-length non-character data                                                                                                                                                          |
| data                             | Variable-length data encoding                                                             | 2.8.2   | Variable-length data. Must be paired with a Length field.                                                                                                                                |
| Country                          | Fixed-length character array; size = 2 or a subset of values may use Enumeration encoding | 2.7.2   | ISO 3166-1:2013 Country code                                                                                                                                                             |
| Currency                         | Fixed-length character array; size = 3 or a subset of values may use Enumeration encoding | 2.7.2   | ISO 4217:2008 Currency code (3 character)                                                                                                                                                |
| Exchange                         | Fixed-length character array; size = 4 or a subset of values may use Enumeration encoding | 2.7.2   | ISO 10383:2012 Market Identifier Code (MIC)                                                                                                                                             |
| Language                         | Fixed-length character array; size = 2 or a subset of values may use Enumeration encoding | 2.7.2   | National language - uses ISO 639-1:2002 standard                                                                                                                                         |
| Implicit enumeration—char or int | Enumeration encoding                                                                      | 2.12    | A single choice of alternative values                                                                                                                                                    |
| Boolean                          | Boolean encoding                                                                          | 2.12.6  | Values true or false                                                                                                                                                                     |
| MultipleCharValue                | Multi-value choice encoding                                                               | 2.13    | Multiple choice of a set of values                                                                                                                                                       |
| MultipleStringValue              | Multi-value choice encoding**.** String choices must be mapped to int values.             | 2.13    | Multiple choice of a set of values                                                                                                                                                       |
| MonthYear                        | MonthYear encoding                                                                        | 2.8     | A flexible date format that must include month and year at least, but may also include day or week.                                                                                      |
| UTCTimestamp                     | Date and time encoding                                                                    | 2.9     | Time/date combination represented in UTC (Universal Time Coordinated, also known as "GMT")                                                                                               |
| UTCTimeOnly                      | Date and time encoding                                                                    | 2.9     | Time-only represented in UTC (Universal Time Coordinated, also known as "GMT")                                                                                                           |
| UTCDateOnly                      | Date and time encoding                                                                    | 2.9     | Date represented in UTC (Universal Time Coordinated, also known as "GMT")                                                                                                                |
| LocalMktDate                     | Local date encoding                                                                       | 2.9     | Local date(as oppose to UTC)                                                                                                                                                             |
| TZTimeOnly                       | TZTimeOnly                                                                                | 2.11.3  | Time of day                                                                                                                                                                              |
| TZTimestamp                      | TZTimestamp                                                                               | 2.11.1  | Time/date combination representing local time with an offset to UTC to allow identification of local time and timezone offset of that time. The representation is based on ISO 8601:2004 |

The FIX semantic types listed above are spelled and capitalized exactly as
they are in the FIX repository from which official FIX documents and
references are derived.

Common field schema attributes
------------------------------

Schema attributes alter the range of valid values for a field.
Attributes are optional unless specified otherwise.


| Schema attribute  | Description                                                                                                                                                                        |
|-------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| presence=required | The field must always be set. This is the default presence. Mutually exclusive with nullValue.                                                                                     |
| presence=constant | The field has a constant value that need not be transmitted on the wire. Mutually exclusive with value attributes.                                                                 |
| presence=optional | The field need not be populated. A special null value indicates that a field is not set. The presence attribute may be specified on either on a field or its encoding.             |
| nullValue         | A special value that indicates that an optional value is not set. See encodings below for default nullValue for each type. Mutually exclusive with presence=required and constant. |
| minValue          | The lowest valid value of a range. Applies to scalar data types, but not to String or data types.                                                                                  |
| maxValue          | The highest valid value of a range (inclusive unless specified otherwise). Applies to scalar data types, but not to String or data types.                                          |
| semanticType      | Tells the FIX semantic type of a field or encoding. It may be specified on either a field or its encoding.                                                                         |

### Inherited attributes

The attributes listed above apply to a field element or its encoding
(wire format). Any attributes specified on an encoding are inherited by
fields that use that encoding.

### Non-FIX types

Encodings may be added to SBE messages that do not correspond to listed
FIX data types. In that case, the encoding and fields that use the
encoding will not have a semanticType attribute.

Integer encoding
-------------------------------------------------------------------------------------------------------------------------------------------------------------

Integer encodings should be used for cardinal or ordinal number fields.
Signed integers are encoded in a two's complement binary format.

### Primitive type encodings

Numeric data types may be specified by range and signed or unsigned
attribute. Integer types are intended to convey common platform
primitive data types as they reside in memory. An integer type should be
selected to hold the maximum range of values that a field is expected to
hold.

| Primitive type | Description                           | Length (octets) |
|----------------|---------------------------------------|----------------:|
| int8           | Signed byte                           | 1               |
| uint8          | Unsigned byte / single-byte character | 1               |
| int16          | 16-bit signed integer                 | 2               |
| uint16         | 16-bit unsigned integer               | 2               |
| int32          | 32-bit signed integer                 | 4               |
| uint32         | 32-bit unsigned integer               | 4               |
| int64          | 64-bit signed integer                 | 8               |
| uint64         | 64-bit unsigned integer               | 8               |

### Range attributes for integer fields

The default data ranges and null indicator are listed below for each
integer encoding.

A message schema may optionally specify a more restricted range of valid
values for a field.

For optional fields, a special null value is used to indicate that a
field value is not set. The default null indicator may also be
overridden by a message schema.

Required and optional fields of the same primitive type have the same
data range. The null value must not be set for a required field.

 Schema attribute  | int8 | uint8 | int16  | uint16 | int32               | uint32             | int64               | uint64             |
|------------------|-----:|------:|-------:|-------:|--------------------:|-------------------:|--------------------:|-------------------:|
| minValue         | –127 | 0     | –32767 | 0      | –2<sup>31</sup> + 1 | 0                  | –2<sup>63</sup> + 1 | 0                  |
| maxValue         | 127  | 254   | 32767  | 65534  | 2<sup>31</sup> – 1  | 2<sup>32</sup> – 2 | 2<sup>63</sup> – 1  | 2<sup>64</sup> – 2 |
| nullValue        | –128 | 255   | –32768 | 65535  | –2<sup>31</sup>     | 2<sup>32</sup> – 1 | –2<sup>63</sup>     | 2<sup>64</sup> – 1 |

### Byte order

The byte order of integer fields, and for derived types that use integer
components, is specified globally in a message schema. Little-Endian
order is the default encoding, meaning that the least significant byte
is serialized first on the wire.

See section 4.3.1 for specification of message schema attributes,
including byteOrder. Message schema designers should specify the byte
order most appropriate to their system architecture and that of their
counterparties.

### Integer encoding specifications

By nature, integers map to simple encodings. These are valid encoding
specifications for each of the integer primitive types.

```xml
<type name="int8" primitiveType="int8" />
<type name="int16" primitiveType="int16" />
<type name="int32" primitiveType="int32" />
<type name="int64" primitiveType="int64" />
<type name="uint8" primitiveType="uint8" />
<type name="uint16" primitiveType="uint16" />
<type name="uint32" primitiveType="uint32" />
<type name="uint64" primitiveType="uint64" />
```

### Examples of integer fields

Examples show example schemas and encoded bytes on the wire as
hexadecimal digits in Little-Endian byte order.

Example integer field specification

```xml
<field type="uint32" name="ListSeqNo" id="67" semanticType="int"
 description="Order number within the list" />
```

Value on the wire - uint32 value decimal 10,000, hexadecimal 2710.

`10270000`

Optional field with a valid range 0-6

```xml
<type name="range06" primitiveType="uint8" maxValue="6"
 presence="optional" nullValue="255" />
<field type="range06" name="MaxPriceLevels" id="1090"
 semanticType="int"/>
```

Wire format of uint8 value decimal 3.

`03`

Sequence number field with integer encoding

```xml
<field type="uint64" name="MsgSeqNum" id="34"
 semanticType="SeqNum" />
```

Wire format of uint64 value decimal 100,000,000,000, hexadecimal
174876E800.

`00e8764817000000`

Wire format of uint16 value decimal 10000, hexadecimal 2710.

`1027`

Wire format of uint32 null value 2<sup>32</sup> - 1

`ffffffff`

Decimal encoding
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Decimal encodings should be used for prices and related monetary data
types like PriceOffset and Amt.

FIX specifies Qty as a float type to support fractional quantities.
However, decimal encoding may be constrained to integer values if that
is appropriate to the application or market.

### Composite encodings

Prices are encoded as a scaled decimal, consisting of a signed integer
mantissa and signed exponent. For example, a mantissa of 123456 and
exponent of -4 represents the decimal number 12.3456.

#### Mantissa

Mantissa represents the significant digits of a decimal number. Mantissa
is a commonly used term in computing, but it is properly known in
mathematics as significand or coefficient.

#### Exponent

Exponent represents scale of a decimal number as a power of 10.

#### Floating point and fixed point encodings

A floating-point decimal transmits the exponent on the wire while a
fixed-point decimal specifies a fixed exponent in a message schema. A
constant negative exponent specifies a number of assumed decimal places
to the right of the decimal point.

Implementations should support both 32 bit and 64 bit mantissa. The
usage depends on the data range that must be represented for a
particular application. It is expected that an 8 bit exponent should be
sufficient for all FIX uses.

| Encoding type | Description            | Backing primitives | Length (octets) |
|---------------|------------------------|--------------------|----------------:|
| decimal       | Floating-point decimal | Composite: int64 mantissa, int8 exponent   | 9               |
| decimal64     | Fixed-point decimal    | int64 mantissa, constant exponent    | 8               |
| decimal32     | Fixed-point decimal    | int32 mantissa, constant exponent     | 4               |

Optionally, implementations may support any other signed integer types
for mantissa and exponent.

### Range attributes for decimal fields

The default data ranges and null indicator are listed below for each
decimal encoding.

A message schema may optionally specify a more restricted range of valid
values for a field. For optional fields, a special mantissa value is
used to indicate that a field value is null.

| Schema attribute  | decimal                                   | decimal64                                 | decimal32                                 |
|------------------|------------------------------------------:|------------------------------------------:|------------------------------------------:|
| exponent range   | –128 to 127                               | –128 to 127                               | –128 to 127                               |
| mantissa range   | –2<sup>63</sup> + 1 to 2<sup>63</sup> – 1 | –2<sup>63</sup> + 1 to 2<sup>63</sup> – 1 | –2<sup>31</sup> + 1 to 2<sup>31</sup> – 1 |
| minValue         | (–2<sup>63</sup> + 1) \* 10<sup>127</sup> | (–2<sup>63</sup> + 1) \* 10<sup>127</sup> | (–2<sup>31</sup> + 1) \* 10<sup>127</sup> |
| maxValue         | (2<sup>63</sup> – 1) \* 10<sup>127</sup>  | (2<sup>63</sup> – 1) \* 10<sup>127</sup> | (2<sup>31</sup> – 1) \* 10<sup>127</sup>  |
| nullValue        | mantissa=–2<sup>63</sup>, exponent=–128                              | mantissa =–2<sup>63</sup>                 | mantissa =–2<sup>31</sup>                 |


### Encoding specifications for decimal types

Decimal encodings are composite types, consisting of two subfields,
mantissa and exponent. The exponent may either be serialized on the wire
or may be set to constant. A constant exponent is a way to specify an
assumed number of decimal places.

Decimal encoding specifications that an implementation must support

```xml
<composite name="decimal" >
    <type name="mantissa" primitiveType="int64" />
    <type name="exponent" primitiveType="int8" />
</composite>

<composite name="decimal32" >
    <type name="mantissa" primitiveType="int32" />
    <type name="exponent" primitiveType="int8"
        presence="constant">-2</type>
</composite>

<composite name="decimal64">
    <type name="mantissa" primitiveType="int64" />
    <type name="exponent" primitiveType="int8"
         presence="constant">-2</type>
</composite>
```

### Composite encoding padding

When both mantissa and exponent are sent on the wire for a decimal, the
elements are packed by default. However, byte alignment may be
controlled by specifying offset of the exponent within the composite
encoding. See section 4.4.4.3 below.

### Examples of decimal fields

Examples show encoded bytes on the wire as hexadecimal digits,
little-endian.

FIX Qty data type is a float type, but a decimal may be constrained to
integer values by setting exponent to zero.

```xml
<composite name="intQty32" semanticType="Qty">
    <type name="mantissa" primitiveType="int32" />
    <type name="exponent" primitiveType="int8"
        presence="constant">0</type>
</composite>
```

Field inherits semanticType from encoding

```xml
<field type="intQty32" name="OrderQty" id="38"
 description="Total number of shares" />
```

Wire format of decimal 123.45 with 2 significant decimal places.

`3930000000000000fe`

Wire format of decimal64 123.45 with 2 significant decimal places.
Schema attribute exponent = -2

`3930000000000000`

Wire format of decimal32 123.45 with 2 significant decimal places.
Schema attribute exponent = -2

`39300000`

Float encoding
------------------------------------------------------------------------------------------------------------

Binary floating point encodings are compatible with IEEE Standard for
Floating-Point Arithmetic (IEEE 754-2008). They should be used for
floating point numeric fields that do not represent prices or monetary
amounts. Examples include interest rates, volatility and dimensionless
quantities such as ratios. On the other hand, decimal prices should be
encoded as decimals; see section 2.5 above.

### Primitive types

Both single and double precision encodings are supported as primitive
data types. See the IEEE 754-2008 standard for ranges and details of the
encodings.

| Primitive type | Description                     | IEEE 754-2008 format | Length (octets) |
|----------------|---------------------------------|----------------------|----------------:|
| float          | Single precision floating point | binary32             | 4               |
| double         | Double precision floating point | binary64             | 8               |

### Null values

For both float and double precision encodings, null value of an optional
field is represented by the Not-a-Number format (NaN) of the standard
encoding. Technically, it indicated by the so-called quiet NaN.

### Byte order

Like integer encodings, floating point encodings follow the byte order
specified by message schema. See section 4.3.1 for specification of
message schema attributes, including byteOrder.

### Float encoding specifications

These are valid encoding specifications for each of the floating point
primitive types.

```xml
<type name="float" primitiveType="float" />
<type name="double" primitiveType="double" />
```

### Examples of floating point fields

Examples show encoded bytes on the wire as hexadecimal digits,
little-endian.

A single precision ratio

```xml
<type name="ratio" primitiveType="float" />

<field type="ratio" name="CurrencyRatio" id="1382"
 semanticType="float"/>
```

Wire format of float 255.678

`91ad7f43`

Wire format of double 255.678

`04560e2db2f56f40`

String encodings
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Character data may either be of fixed size or variable size. In Simple
Binary Encoding, fixed-length fields are recommended in order to support
direct access to data. Variable-length encoding should be reserved for
character strings that cannot be constrained to a specific size. It may
also be used for non-ASCII encoded strings.

### Character

Character fields hold a single character. They are most commonly used
for field with character code enumerations. See section 2.12 below for
discussion of enum fields.

| FIX data type | Description                 | Backing primitive | Length (octet) |
|---------------|-----------------------------|-------------------|---------------:|
| char          | A single US-ASCII character | char              | 1              |

#### Range attributes for char fields

Valid values of a char field are printable characters of the US-ASCII
character set (codes 20 to 7E hex.) The implicit nullValue is the NUL
control character (code 0).

 Schema attribute  | char   |
|------------------|--------|
| minValue         | hex 20 |
| maxValue         | hex 7e |
| nullValue        | 0      |

#### Encoding of char type

This is the standard encoding for char type.

```xml
<type name="char" primitiveType="char" semanticType="char" />
```

Wire format of char encoding of "A" (ASCII value 65, hexadecimal 41)

`41`

### Fixed-length character array

Character arrays are allocated a fixed space in a message, supporting
direct access to fields. A fixed size character array is distinguished
from a variable length string by the presence of a length schema
attribute or a constant attribute.

| FIX data type | Description     | Backing primitives                                                                                                          | Length (octets)               | Required schema attribute                                          |
|---------------|-----------------|-----------------------------------------------------------------------------------------------------------------------------|-------------------------------|--------------------------------------------------------------------|
| String        | character array | Array of char of specified length, delimited by NUL character if a string is shorter than the length specified for a field. | Specified by length attribute | length (except may be inferred from a constant value, if present). |

A length attribute set to zero indicates variable length. See section
2.7.3 below for variable-length data encoding.

#### Encoding specifications for fixed-length character array

A fixed-length character array encoding must specify
primitiveType="char" and a length attribute is required.

Range attributes minValue and maxValue do not apply to fixed-length
character arrays.

US-ASCII is the default encoding of character arrays to conform to usual
FIX values. The characterEncoding attribute may be specified to override
encoding.

#### Examples of fixed-length character arrays

A typical string encoding specification

```xml
<type name="string6" primitiveType="char" semanticType="String"
 length="6" />

<field type="string6" name="Symbol" id="55" />
```

Wire format of a character array in character and hexadecimal formats

M S F T

`4d5346540000`

A character array constant specification

```xml
<type name="EurexMarketID" semanticType="Exchange"
 primitiveType="char" length="4" description="MIC code"
 presence="constant">XEUR</type>

<field type="EurexMarketID" name="MarketID" id="1301" />
```

### Variable-length string encoding

Variable-length string encoding is used for variable length ASCII
strings or embedded non-ASCII character data (like EncodedText field). A
separate length field coveys the size of the field.

On the wire, length immediately precedes the data.

The length subfield may not be null, but may be set to zero for an empty
string. In that case, no space is reserved for the data. No distinction
is made at an encoding layer between an empty string and a null string.
Semantics of an empty variable-length string should be specified at an
application layer.

| FIX data type | Description                           | Backing primitives                                                                                                         | Length (octets) |
|---------------|---------------------------------------|----------------------------------------------------------------------------------------------------------------------------|-----------------|
| Length        | The length of variable data in octets | primitiveType="uint8" or "uint16"  May not hold null value.                                                                                        | 1 or 2          |
| data          | Raw data                              | Array of octet of size specified in associated Length field. The data field itself should be specified as variable length.   primitiveType="uint8"   length="0" indicates variable length                                                                                        | variable        |

Optionally, implementations may support any other unsigned integer types
for length.

### Range attributes for string Length

| Schema attribute | length  uint8   | length  uint16  | data |
|------------------|-------:|-------:|------|
| minValue         | 0      | 0      | N/A  |
| maxValue         | 254    | 65534  | N/A  |

If the Length element has minValue and maxValue attributes, it specifies
the minimum and maximum *length* of the variable-length data.

Range attributes minValue , maxValue, and nullValue do not apply to the
data element.

If a field is required, both the Length and data fields must be set to a
"required" attribute.

### Encoding specifications for variable-length string

Variable length string is encoded as a composite type, consisting of a
length sub field and data subfield. The length attribute of the varData
element is set to zero in the XML message schema as special value to
indicate that the character data is of variable length.

To map an SBE data field specification to traditional FIX, the field ID
of a data field is used. Its associated length is implicitly contained
by the composite type rather than specified as a separate field.

Encoding specification for variable length data up to 65535 octets

```xml
<composite name="varString" description="Variable-length string">
    <type name="length" primitiveType="uint16" semanticType="Length"/>
    <type name="data" length="0" primitiveType="uint8"
    semanticType="data" characterEncoding="UTF-16"/>
</composite>

<data name="SecurityDesc" id="107" type="varString"/>
```

The characterEncoding attribute tells which variable-sized encoding is
used if the data field represents encoded text. UTF-8 is the recommended
encoding, but there is no default in the XML schema

### Example of a variable-length string field

Example shows encoded bytes on the wire.

Wire format of variable-length String in character and hexadecimal
formats, preceded by uint16 length of 4 octets in little-endian byte
order

M S F T

`04004d534654`

Data encodings
--------------

Raw data is opaque to SBE. In other words, it is not constrained by any
value range or structure known to the messaging layer other than length.
Data fields simply convey arrays of octets.

Data may either be of fixed-length or variable-length. In Simple Binary
Encoding, fixed-length data encoding may be used for data of
predetermined length, even though it does not represent a FIX data type.
Variable-length encoding should be reserved for raw data when its length
is not known until run-time.

### Fixed-length data

Data arrays are allocated as a fixed space in a message, supporting
direct access to fields. A fixed size array is distinguished from a
variable length data by the presence of a length schema attribute rather
than sending length on the wire.

| FIX data type | Description | Backing primitives                  | Length (octets)               | Required schema attribute |
|---------------|-------------|-------------------------------------|-------------------------------|---------------------------|
| data          | octet array | Array of uint8 of specified length. | Specified by length attribute | length                    |

#### Encoding specifications for fixed-length data

A fixed-length octet array encoding should specify primitiveType="uint8"
and a length attribute is required.

Data range attributes minValue and maxValue do not apply.

Since raw data is not constrained to a character set, characterEncoding
attribute should not be specified.

#### Example of fixed-length data encoding

A fixed-length data encoding specification for a binary user ID

```xml
<type name="uuid" primitiveType="uint8" length="16" description="RFC 4122 compliant UUID"/>

<field type="uuid" name="Username" id="553" />
```

### Variable-length data encoding

Variable-length data is used for variable length non-character data
(such as RawData). A separate length field conveys the size of the field.
On the wire, length immediately precedes the data.

The length subfield may not be null, but it may be set to zero. In that
case, no space is reserved for the data. Semantics of an empty
variable-length data element should be specified at an application
layer.

| FIX data type | Description                           | Backing primitives                                                                                                         | Length (octets) |
|---------------|---------------------------------------|----------------------------------------------------------------------------------------------------------------------------|-----------------|
| Length        | The length of variable data in octets | primitiveType="uint8" or "uint16"   May not hold null value.                                                                                                    | 1 or 2          |
| data          | Raw data                              | Array of octet of size specified in associated Length field. The data field itself should be specified as variable length. primitiveType="uint8"  | variable

Optionally, implementations may support any other unsigned integer types
for length.

### Range attributes for variable-length data Length

| Schema attribute | length  uint8   | length  uint16  | data |
|------------------|-------:|-------:|------|
| minValue         | 0      | 0      | N/A  |
| maxValue         | 254    | 65534  | N/A  |

If the Length field has minValue and maxValue attributes, it specifies
the minimum and maximum *length* of the variable-length data. Data range
attributes minValue , maxValue, and nullValue do not apply to a data
field.

If a field is required, both the Length and data fields must be set to a
"required" attribute.

### Encoding specifications for variable-length data

Variable length data is encoded as composite type, consisting of a
length sub field and data subfield.

To map an SBE data field specification to traditional FIX, the field ID
of a data field is used. Its associated length is implicitly contained
by the composite type rather than specified as a separate field.

Encoding specification for variable length data up to 65535 octets

```xml
<composite name="DATA" description="Variable-length data">
    <type name="length" primitiveType="uint16" semanticType="Length"/>
    <type name="data" length="0" primitiveType="uint8" semanticType="data" />
</composite>

<data name="RawData" id="96" type="DATA"/>
```

### Example of a data field

Example shows encoded bytes on the wire.

Wire format of data in character and hexadecimal formats, preceded by
uint16 length of 4 octets in little-endian byte order

M S F T

`04004d534654`

MonthYear encoding
---------------------------------------------------------------------------------------------------------------------------------------------------------------

MonthYear encoding contains four subfields representing respectively
year, month, and optionally day or week. A field of this type is not
constrained to one date format. One message may contain only year and
month while another contains year, month and day in the same field, for
example.

Values are distinguished by position in the field. Year and month must
always be populated for a non-null field. Day and week are set to
special value indicating null if not present. If Year is set to the null
value, then the entire field is considered null.

| Subfield                         | Primitive type | Length (octets) | Null value |
|----------------------------------|----------------|----------------:|-----------:|
| Year                             | uint16         | 2               | 65535      |
| Month (1-12)                     | uint8          | 1               | —          |
| Day of the month(1-31) optional  | uint8          | 1               | 255        |
| Week of the month (1-5) optional | uint8          | 1               | 255        |


### Composite encoding padding

The four subfields of MonthYear are packed at an octet level by default.
However, byte alignment may be controlled by specifying offset of the
elements within the composite encoding. See section 4.4.4.3 below.

### Encoding specifications for MonthYear

MonthYear data type is based on a composite encoding that carries its
required and optional elements.

The standard encoding specification for MonthYear

```xml
<composite name="monthYear" semanticType="MonthYear">
    <type name="year" primitiveType="uint16" presence="optional"
    nullValue="65536" />
    <type name="month" primitiveType="uint8" minValue="1" maxValue="12" />
    <type name="day" primitiveType="uint8" minValue="1" maxValue="31"
    presence="optional" nullValue="255" />
    <type name="week" description="week of month" primitiveType="uint8"
    minValue="1" maxValue="5" presence="optional" nullValue="255" />
</composite>
```

Example MonthYear field specification

<field type="monthYear" name="MaturityMonthYear" id="200" />

Wire format of MonthYear 2014 June week 3 as hexadecimal

`de0706ff03`

Date and time encoding
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Dates and times represent Coordinated Universal Time (UTC). This is the
preferred date/time format, except where regulations require local time
with time zone to be reported (see time zone encoding below).

### Epoch

Each time type has an epoch, or start of a time period to count values.
For timestamp and date, the standard epoch is the UNIX epoch, midnight
January 1, 1970 UTC.

A time-only value may be thought of as a time with an epoch of midnight
of the current day. Like current time, the epoch is also referenced as
UTC.

### Time unit

Time unit tells the precision at which times can be collected. Time unit
may be serialized on the wire if timestamps are of mixed precision. On
the other hand, if all timestamps have the same precision, then time
unit may be set to a constant in the message schema. Then it need not be
sent on the wire.

| FIX data type | Description                                                              | Backing primitives | Length (octets) | Schema attributes      |
|---------------|--------------------------------------------------------------------------|--------------------|----------------:|------------------------|
| UTCTimestamp  | UTC date/time   Default: nanoseconds since Unix epoch Range Jan. 1, 1970 - July 21, 2554  | uint64 time        | 8               | epoch=”unix” (default)                                                                        |                    |                 |                        |
|               | timeUnit = second or millisecond or microsecond or nanosecond  May be constant                                                           | uint8 unit         | 1               |                        |
| UTCTimeOnly   | UTC time of day only  Default: nanoseconds since midnight today                                 | uint64                                                                                     time                | 8               |                        |
|               | timeUnit = second or millisecond or microsecond or nanosecond   May be constant                                                           | uint8 unit         | 1               |                        |
| UTCDateOnly   | UTC calendar date  Default: days since Unix epoch. Range: Jan. 1, 1970 - June 7, 2149        | uint16             | 2               | epoch=”unix” (default) |


### Encoding specifications for date and time

Time specifications use an enumeration of time units. See section 2.13
below for a fuller explanation of enumerations.

Enumeration of time units:

```xml
<enum name="TimeUnit" encodingType="uint8">
    <validValue name="second">0</validValue>
    <validValue name="millisecond">3</validValue>
    <validValue name="microsecond">6</validValue>
   <validValue name="nanosecond">9</validValue>
</enum>
```

Timestamp with variable time units:

```xml
<composite name="UTCTimestamp" description="UTC timestamp with precision on the wire" semanticType="UTCTimestamp" >
    <type name="time" primitiveType="uint64" />
    <type name="unit" primitiveType="uint8" />
</composite>
```

Timestamp with constant time unit:

```xml
<composite name="UTCTimestampNanos" description="UTC timestamp with nanosecond precision" semanticType="UTCTimestamp" >
    <type name="time" primitiveType="uint64" />
    <type name="unit" primitiveType="uint8" presence="constant" valueRef="TimeUnit.nanosecond" />
</composite>
```

Time only with variable time units:

```xml
<composite name="UTCTime" description="Time of day with precision on the wire" semanticType="UTCTimeOnly" >
    <type name="time" primitiveType="uint64" />
    <type name="unit" primitiveType="uint8" />
</composite>
```

Time only with constant time unit:

```xml
<composite name="UTCTimeNanos" description="Time of day with millisecond precision" semanticType="UTCTimeOnly" >
    <type name="time" primitiveType="uint64" />
    <type name="unit" primitiveType="uint8" presence="constant" valueRef="TimeUnit.millisecond" />
</composite>
```

Date only specification:

```xml
<type name="date" primitiveType="uint16" semanticType="UTCDateOnly" />
```

### Examples of date/time fields

**timestamp** 14:17:22 Friday, October 4, 2024 UTC (20,000 days and 14
hours, 17 minutes and 22 seconds since the UNIX epoch) with default
schema attributes

```xml
<composite name="UTCTimestampNanos" description="UTC timestamp with nanosecond precision" semanticType="UTCTimestamp" >
<type name="time" primitiveType="uint64" />
<type name="unit" primitiveType="uint8" presence="constant" valueRef="TimeUnit.nanosecond" />
</composite>
```

Wire format of UTCTimestamp with constant time unit in little-Endian
byte order

`4047baa145fb17`

**time** 10:24:39.123456000 (37,479 seconds and 123456000 nanoseconds
since midnight UTC) with default schema attributes

```xml
<composite name="UTCTimeOnlyNanos" description="UTC time of day with nanosecond precision" semanticType="UTCTimeOnly" >
    <type name="time" primitiveType="uint64" />
    <type name="unit" primitiveType="uint8" presence="constant" valueRef="TimeUnit.nanosecond" />
</composite>
```

Wire format of UTCTimeOnly

`10d74916220000`

**date** Friday, October 4, 2024 (20,000 days since UNIX epoch) with
default schema attributes

```xml
<type name="date" primitiveType="uint16" semanticType="UTCDateOnly" />
```

Wire format of UTCDateOnly

`204e`

Local date encoding
----------------------------------------------------------------------------------------------------------------------------------------------------------------

Local date is encoded the same as UTCDateOnly, but it represents local
time at the market instead of UTC time.

| FIX data type | Description                                                                   | Backing primitives | Length (octets) | Schema attributes                  |
|---------------|-------------------------------------------------------------------------------|--------------------|----------------:|------------------------------------|
| LocalMktDate  | Local calendar date  Default: days since Unix epoch. Range: Jan. 1, 1970 - June 7, 2149 local time  | uint16             | 2               | epoch=”unix” (default)  

The standard encoding specification for LocalMktDate

```xml
<type name="localMktDate" primitiveType="uint16" semanticType="LocalMktDate" />
```

Local time encoding
-----------------------------------------------------------------------------------------------------------------

Time with time zone encoding should only be used when required by market
regulations. Otherwise, use UTC time encoding (see above).

Time zone is represented as an offset from UTC in the ISO 8601:2004
format ±hhmm.

### TZTimestamp encoding

A binary UTCTimestamp followed by a number representing the time zone
indicator as defined in ISO 8601:2004.

| FIX data type | Description                                                              | Backing primitives | Length (octets) | Schema attributes                  |
|---------------|--------------------------------------------------------------------------|--------------------|----------------:|------------------------------------|
| TZTimestamp   | date/time with timezone   Default: nanoseconds since Unix epoch Range Jan. 1, 1970 - July 21, 2554  | uint64             | 8               | epoch=”unix” (default) Represents Jan. 1, 1970 local time  |
|               | timeUnit = second or millisecond or microsecond or nanosecond  May be constant                                                           | uint8              | 1               |                                    |
|               | Time zone hour offset                                                    | int8               | 1               | None                               |
|               | Time zone minute offset                                                  | uint8              | 1               | None                               |

### Composite encoding padding

The subfields of TZTimestamp are packed at an octet level by default.
However, byte alignment may be controlled by specifying offset of the
elements within the composite encoding. See section 4.4.4.3 below.

Standard TZTimestamp encoding specification

```xml
<composite name="tzTimestamp" semanticType="TZTimestamp">
    <type name="time" primitiveType="uint64" />
    <type name="unit" primitiveType="uint8" />
    <!-- Sign of timezone offset is on hour subfield -->
    <type name="timezoneHour" primitiveType="int8" minValue="-12" maxValue="14" />
    <type name="timezoneMinute" primitiveType="uint8" maxValue="59" />
</composite>
```

Wire format of TZTimestamp 8:30 17 September 2013 with Chicago time zone
offset (-6:00)

`0050d489fea22413fa00`

### TZTimeOnly encoding

A binary UTCTimeOnly followed by a number representing the time zone
indicator as defined in ISO 8601:2004.

The time zone hour offset tells the number of hours different to UTC
time. The time zone minute tells the number of minutes different to UTC.
The sign telling ahead or behind UTC is on the hour subfield.

| FIX data type | Description                                                | Backing primitives | Length (octets) | Schema attributes |
|---------------|------------------------------------------------------------|--------------------|----------------:|-------------------|
| TZTimeOnly    | Time of day only with time zone  Default: nanoseconds since midnight today, local time       | uint64             | 8               | None              |
|               | timeUnit = second or millisecond or microsecond or nanosecond  May be constant                                             | uint8              | 1               | None              |
|               | Time zone hour offset                                      | int8               | 1               | None              |
|               | Time zone minute offset                                    | uint8              | 1               | None              |

### Composite encoding padding

The subfields of TZTimeOnly are packed at an octet level by default.
However, byte alignment may be controlled by specifying offset of the
elements within the composite encoding. See section 4.4.4.3 below.

Standard TZTimeOnly encoding specification

```xml
<composite name="tzTimeOnly" semanticType="TZTimeOnly">
    <type name="time" primitiveType="uint64" />
    <type name="unit" primitiveType="uint8" />
    <!-- Sign of timezone offset is on hour subfield -->
    <type name="timezoneHour" primitiveType="int8"
    minValue="-12" maxValue="14" />
    <type name="timezoneMinute" primitiveType="uint8" minValue="0"
    maxValue="59" />
</composite>
```

Wire format of TZTimeOnly 8:30 with Chicago time zone offset (-6:00)

`006c5ebe76000000fa00`

Enumeration encoding
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

An enumeration conveys a single choice of mutually exclusive valid
values.

### Primitive type encodings

An unsigned integer or character primitive type is selected to contain
the number of choices. Implementations must support char and uint8
types. They may additionally support other unsigned integer types to
allow more choices.

| Primitive type | Description            | Length (octets) | Maximum number of choices |
|----------------|------------------------|----------------:|--------------------------:|
| char           | character              | 1               | 95                        |
| uint8          | 8-bit unsigned integer | 1               | 255                       |

### Value encoding

If a field is of FIX data type char, then its valid values are
restricted to US-ASCII printable characters. See section 2.7.1 above.

If the field is of FIX data type int, then a primitive integer data type
should be selected that can contain the number of choices. For most
cases, an 8 bit integer will be sufficient, allowing 255 possible
values.

Enumerations of other data types, such as String valid values specified
in FIX, should be mapped to an integer wire format in SBE.

### Encoding specification of enumeration

In a message schema, the choices are specified a `<validValue>` members
of an `<enum>`. An `<enum>` specification must contain at least one
`<validValue>`.

The name and value of a validValue element must be unique within an
enumeration.

An `<enum>` element must have an encodingType attribute to specify the
type of its values. Two formats of encodingType are acceptable:

-   In-line style: the value of encodingType is its primitive data type.

-   Reference style: the value of encodingType is the name of a `<type>`
    element that specifies the wire format.

The length of a `<type>` associated to an enumeration must be 1. That
is, enumerations should only be backed by scalar types, not arrays.

### Enumeration examples

These examples use a char field for enumerated code values.

Example enum lists acceptable values and gives the underlying encoding,
which in this case is char (in-line style)

```xml
<enum name="SideEnum" encodingType="char">
    <validValue name="Buy">1</validValue>
    <validValue name="Sell">2</validValue>
    <validValue name="SellShort">5</validValue>
    <validValue name="SellShortExempt">6</validValue>
    <!-- not all FIX values shown -->
</enum>
```

Reference to type: This specification is equivalent to the one above.

```xml
<type name="charEnumType" primitiveType="char"/>
    <enum name="SideEnum" encodingType="charEnumType">
	<!-- valid values as above -->
</enum>
```

Side field specification references the enumeration type

```xml
<field name="Side" type="SideEnum" id="54" />
```

Wire format of Side "Buy" code as hexadecimal

`01`

### Constant field of an enumeration value

A constant field may be specified as a value of an enumeration. The
attribute valueRef is a cross-reference to validValue entry by symbolic
name.

Example of a char field using a constant enum value

```xml
<enum name="PartyIDSourceEnum" encodingType="char">
    <validValue name="BIC">B</validValue>
    <validValue name="GeneralIdentifier">C</validValue>
    <validValue name="Proprietary">D</validValue>
</enum>

<field type="PartyIDSourceEnum" name="PartyIDSource" id="447"
 description="Party ID source is fixed" presence="constant"
 valueRef="PartyIDSourceEnum.GeneralIdentifier" />
```

### Boolean encoding

A Boolean field is a special enumeration with predefined valid values:
true and false. Like a standard enumeration, an optional Boolean field
may have nullValue that indicates that the field is null (or not
applicable).

Standard encoding specifications for required and optional Boolean
fields

```xml
<enum name="booleanEnum" encodingType="uint8" semanticType="Boolean">
    <validValue name="false">0</validValue>
    <validValue name="true">1</validValue>
</enum>

<enum name="optionalBoolean" encodingType="uint8" semanticType="Boolean">
    <validValue name="false">0</validValue>
    <validValue name="true">1</validValue>
	<validValue name="nullValue">255</validValue>
</enum>
```

Example optional Boolean field

```xml
<field type="optionalBoolean" name="SolicitedFlag" id="377" />
```

Wire format of true value as hexadecimal

`01`

Wire format of false value as hexadecimal

`00`

Wire format of null Boolean (or N/A) value as hexadecimal

`ff`

Multi-value choice encoding
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

A multi-value field conveys a choice of zero or more non-exclusive valid values.

### Primitive type encodings

The binary encoding uses a bitset (a fixed-size sequence of bits, also
known as bitmap, bit array or bit vector) to represent up to 64 possible
choices. The encoding is backed by an unsigned integer. The smallest
unsigned primitive type should be selected that can contain the number
of valid choices.

| Primitive type | Description             | Length (octets) | Maximum number of choices |
|----------------|-------------------------|----------------:|--------------------------:|
| uint8          | 8-bit unsigned integer  | 1               | 8                         |
| uint16         | 16-bit unsigned integer | 2               | 16                        |
| uint32         | 32-bit unsigned integer | 4               | 32                        |
| uint64         | 64-bit unsigned integer | 8               | 64                        |

Like other integer-backed encodings, multi-value encodings follow the
byte order specified by message schema when serializing to the wire. See
section 4.3.1 for specification of message schema attributes, including
byteOrder.

### Value encoding

Each choice is assigned a bit of the primitive integer encoding,
starting with the least significant bit. For each choice the value is
selected or not, depending on whether it corresponding bit is set or
cleared.

Any remaining unassigned bits in an octet should be cleared.

There is no explicit null value for multi-value choice encoding other
than to set all bits off when no choices are selected.

### Encoding specification of multi-value choice

In a message schema, the choices are specified as `<choice>` members of
an `<set>` element. Choices are assigned values as an ordinal of bits in
the bit set. The first Choice "0" is assigned the least significant bit;
choice "1" is the second bit, and so forth.

The name and value (bit position) must be unique for element of a set.

A `<set>` element must have an encodingType attribute to specify the
wire format of its values. Two formats of encodingType are recognized :

-   In-line style: the value of encodingType is its primitive data type.

-   Reference style: the value of encodingType is the name of a `<type>`
    element that specifies the wire format.

The length of a `<type>` associated to an bitset must be 1. That is,
bitsets should not be specified as arrays.

### Multi-value example

Example of a multi-value choice (was MultipleCharValue in tag-value encoding) Encoding type is
in-line style.

```xml
<set name="FinancialStatusEnum" encodingType="uint8">
    <choice name="Bankrupt">0</choice>
    <choice name="Pending delisting">1</choice>
    <choice name="Restricted">2</choice>
</set>
```

Reference to type. This is equivalent to the example above.

```xml
<type name="u8Bitset" primitiveType="uint8"/>

<set name="FinancialStatusEnum" encodingType="u8Bitset">
<!--choices as above -->
</set>
```

A field using the multi-choice encoding

```xml
<field type="FinancialStatus" name="FinancialStatusEnum"
 id="291" semanticType="MultipleCharValue"/>
```

Wire format of choices "Bankrupt" + "Pending delisting" (first and
second bits set)

`03`

Field value validation
--------------------------------------------------------------------------------------------------------------------

These validations apply to message field values.

If a value violation is detected on a received message, the message
should be rejected back to the counterparty in a way appropriate to the
session protocol.

| Error condition                                             | Error description                                                                                                            |
|-------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| Field value less than minValue                              | The encoded value falls below the specified valid range.                                                                     |
| Field value greater than maxValue                           | The encoded value exceeds the specified valid range.                                                                         |
| Null value set for required field                           | The null value of a data type is invalid for a required field.                                                               |
| String contains invalid characters                          | A String contains non-US-ASCII printable characters or other invalid sequence if a different characterEncoding is specified. |
| Required subfields not populated in MonthYear               | Year and month must be populated with non-null values, and the month must be in the range 1-12.                              |
| UTCTimeOnly exceeds day range                               | The value must not exceed the number of time units in a day, e.g. greater than 86400 seconds.                                |
| TZTimestamp and TZTimeOnly has missing or invalid time zone | The time zone hour and minute offset subfields must correspond to an actual time zone recognized by international standards. |
| Value must match valid value of an enumeration field        | A value is invalid if it does not match one of the explicitly listed valid values.                                           |
