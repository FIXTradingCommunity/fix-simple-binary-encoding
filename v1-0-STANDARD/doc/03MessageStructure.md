Message Structure
===============================================================================================================

Message Framing
------------------------------------------------------------------------------------------------------------------------------------------------------------

SBE messages have no defined message delimiter. Version 2.0 of SBE makes it possible to walk the elements of a message to determine its limit, even when the message has been extended. Nevertheless, since internal framing depends on a correct starting point and not encountering malformed messages, it may be desirable to use an external framing protocol when used with transports that do not preserve message boundaries, such as when they are transmitted on a streaming
session protocol or when persisting messages in storage. 

### Simple Open Framing Header

FIX Protocol Ltd. offers the Simple Open Framing Header standard for
framing messages encoded with binary wire formats, such as Simple Binary
Encoding.

The framing header provides two features:

-   An overall message size including headers to support framing

-   An identifier of the encoding used in the message payload. This
    supports selecting the correct decoder in the case where multiple
    message encodings are used on a session. It also aids tooling such
    as protocol analyzers to identify message protocols contained in
    network packets.

While the Simple Open Framing Header specification is normative, the
following is an interpretation of that standard as an SBE encoding. Note
that the framing standard specifies that the framing header will always
be encoded in big-endian byte order, also known as network byte order.

Simple Open Framing Header as an SBE composite encoding (big-endian)

```xml
<composite name="framingHeader"/>
    <type name="messageLength" primitiveType="uint32" />
    <type name="encodingType" primitiveType="uint16" />
</composite>
```

The values of encodingType used to indicate SBE payloads are currently
defined as:

| Encoding                      | encodingType value |
|-------------------------------|--------------------|
| SBE version 1.0 big-endian    | 0x5BE0             |
| SBE version 1.0 little-endian | 0xEB50             |

The Simple Open Framing Header specification also lists values for other
wire formats.

SBE Message Encoding Header
---------------------------

The purpose of the message encoding header is to tell which message
template was used to encode the message and to give information about
the size of the message body to aid in decoding, even when a message
template has been extended in a later version. See section 5 below for
an explanation of the schema extension mechanism.

The fields of the SBE message header are:

-   **Block length of the message root** - the total space reserved for
    the root level of the message not counting any repeating groups or
    variable-length fields.

-   **Template ID** - identifier of the message template

-   **Schema ID** - identifier of the message schema that contains the
    template

-   **Schema version** - the version of the message schema in which the
    message is defined

-   **Group count** - the number of repeating groups in the root level of the message

-   **Variable-length field count** - the number of variable-length fields in the root level of the message

Block length is specified in a message schema, but it is also serialized
on the wire. By default, block length is set to the sum of the sizes of
body fields in the message. However, it may be increased to force
padding at the end of block. See section 3.3.3.3 below.

### Message header schema

The header fields precede the message body of every message in a fixed
position as shown below. Each of these fields must be encoded as an
unsigned integer type. The encoding must carry the name "messageHeader".

The message header is encoded in the same byte order as the message
body, as specified in a message schema. See section 4.3.1.

Recommended message header encoding

```xml
<composite name="messageHeader" description="Template ID and length of message root">
    <type name="blockLength" primitiveType="uint16"/>
    <type name="templateId" primitiveType="uint16"/>
    <type name="schemaId" primitiveType="uint16"/>
    <type name="version" primitiveType="uint16"/>
	<type name="numGroups" primitiveType="uint16" />
    <type name="numVarDataFields" primitiveType="uint16" />
</composite>
```

The recommended header encoding is 12 octets.

| Element     | Description       | Primitive type | Length (octets) | Offset |
|-------------|-------------------|----------------|----------------:|-------:|
| blockLength | Root block length | uint16         | 2               | 0      |
| templateId  | Template ID       | uint16         | 2               | 2      |
| schemaId    | Schema ID         | uint16         | 2               | 4      |
| version     | Schema Version    | uint16         | 2               | 6      |
| numGroups   |Number of repeating groups | uint16 | 2               | 8      |
| numVarDataFields | Number of variable-length fields | uint16 | 2   | 10     |

Optionally, implementations may support any other unsigned integer types
for blockLength.

### Root block length

The total space reserved for the root level of the message not counting
any repeating groups or variable-length fields. (Repeating groups have
their own block length; see section 3.4 below. Length of a
variable-length Data field is given by its corresponding Length field;
see section 2.7.3 above.) Block length only represents message body
fields; it does not include the length of the message header itself,
which is a fixed size.

The block size must be at least the sum of lengths of all fields at the
root level of the message, and that is its default value. However, it
may be set larger to reserve more space to effect alignment of blocks.
This is specified by setting the blockLength attribute in a message
schema. 

### Template ID

The identifier of a message type in a message schema. See section 4.5.2
below for schema attributes of a message.

### Schema ID

The identifier of a message schema. See section 4.3.1 below for schema
attributes.

### Schema version

The version number of the message schema that was used to encode a
message. See section 4.3.1 below for schema attributes.

### Number of repeating groups

A count of repeating groups at the root level of the message. The count does not include nested repeating groups.

### Number of variable-length fields

A count of the variable-length fields at the root level of the message. The count does not include variable-length fields within repeating groups.


Message Body
----------------------------------------------------------------------------------------------------------

The message body conveys the business information of the message.

### Data only on the wire

In SBE, fields of a message occupy proximate space without delimiters or
metadata, such as tags.

### Direct access

Access to data is positional, guided by a message schema that specifies
a message type.

Data fields in the message body correspond to message schema fields;
they are arranged in the same sequence. The first data field has the
type and size specified by the first message schema field, the second
data field is described by the second message schema field, and so
forth. Since a message decoder follows the field descriptions in the
schema for position, it is not necessary to send field tags on the wire.

In the simplest case, a message is flat record with a fixed length.
Based on the sequence of field data types, the offset to a given data
field is constant for a message type. This offset may be computed in
advance, based on a message schema. Decoding a field consists of
accessing the data at this fixed location.

### Field position and padding

#### No padding by default

By default, there is no padding between fields. In other words, a field
value is packed against values of its preceding and following fields. No
consideration is given to byte boundary alignment.

By default, the position of a field in a message is determined by the
sum of the sizes of prior fields, as they are defined by the message
schema.

```xml
<field name="ClOrdID" id="11" type="string14"
 semanticType="String"/>
<field name="Side" id="54" type="char" semanticType="char"/>
<field name="OrderQty" id="38" type="intQty32"
 semanticType="Qty"/>
<field name="Symbol" id="55" type="string8" semanticType="String"/>
```

| Field    | Size | Offset |
|----------|-----:|-------:|
| ClOrdID  | 14   | 0      |
| Side     | 1    | 14     |
| OrderQty | 4    | 15     |
| Symbol   | 8    | 19     |

#### Field offset specified by message schema

If a message designer wishes to introduce padding or control byte
boundary alignment or map to an existing data structure, field offset
may optionally be specified in a message schema. Field offset is the
number of octets from the start of the message body or group to the
first octet of the field. Offset is a zero-based index.

If specified, field offset must be greater than or equal to the sum of
the sizes of prior fields. In other words, an offset is invalid if it
would cause fields to overlap.

Extra octets specified for padding should never be interpreted as
business data. They should be filled with binary zeros.

Example of fields with specified offsets

```xml
<field name="ClOrdID" id="11" type="string14" offset="0"
 semanticType="String"/>
<field name="Side" id="54" type="char" offset="14"
 semanticType="char"/>
<field name="OrderQty" id="38" type="intQty32" offset="16"
 semanticType="Qty"/>
<field name="Symbol" id="55" type="string8" offset="20"
 semanticType="String"/>
```

| Field    | Size | Padding preceding field | Offset |
|----------|------|------------------------:|-------:|
| ClOrdID  | 14   | 0                       | 0      |
| Side     | 1    | 0                       | 14     |
| OrderQty | 4    | 1                       | 16     |
| Symbol   | 8    | 0                       | 20     |

#### Padding at end of a message or group

In order to force messages or groups to align on byte boundaries or map
to an existing data structure, they may optionally be specified to
occupy a certain space with a blockLength attribute in the message
schema. The extra space is padded at the end of the message or group. If
specified, blockLength must be greater than or equal to the sum of the
sizes of all fields in the message or group.

The blockLength attribute applies only to the portion of message that
contains fix-length fields; it does not apply to variable-length data
elements of a message.

Extra octets specified for padding should be filled with binary zeros.

Example of blockLength specification for 24 octets

```xml
<message name="ListOrder" id="2" blockLength="24">
```

Repeating Groups
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

A repeating group is a message structure that contains a variable number
of entries. Each entry contains fields specified by a message schema.

The order and data types of the fields are the same for each entry in a
group. That is, the entries are homogeneous. Position of a given
field within any entry is fixed, with the exception of variable-length
fields.

A message may have no groups or an unlimited number of repeating groups
specified in its schema.

### Schema specification of a group

A repeating group is defined in a message schema by adding a `<group>`
element to a message template. An unlimited number of `<field>` elements
may be added to a group, but a group must contain at least one field.

Example repeating group encoding specification

```xml
<group name="Parties" id="1012" blockLength="16">
    <field name="PartyID" id="448" type="string14"
    semanticType="String"/>
    <field name="PartyIDSource" id="447" type="char"
    semanticType="char"/>
    <field name="PartyRole" id="452" type="uint8" semanticType="int"/>
</group>
```

### Group block length

The blockLength part of a group dimension represents total space reserved 
for each group entry, not counting any nested repeating groups or variable-length
fields. (Length of a variable-length Data field is given by its corresponding
Length field.) Block length only represents message body fields; it does not
include the length of the group dimension itself, which is a fixed size.

### Padding at end of a group entry

By default, the space reserved for an entry is the sum of a group’s
field lengths, as defined by a message schema, without regard to byte
alignment.

The space reserved for an entry may optionally be increased to effect
alignment of entries or to plan for future growth. This is specified by
adding the group attribute blockLength to reserve a specified number of
octets per entry. If specified, the extra space is padded at the end of
each entry and should be set to zeroes by encoders. The blockLength
value does not include the group dimensions itself.

Note that padding will only result in deterministic alignment if the
repeating group contains no variable-length fields.

### Entry counter 

Each group is associated with a required counter field of semantic data
type NumInGroup to tell how many entries are contained by a message. The
value of the counter is a non-negative integer. See "Encoding of repeating group dimensions" section below
for encoding of that counter.

### Empty group

The space reserved for all entries of a group is the product of the
space reserved for each entry times the value of the associated
NumInGroup counter. If the counter field is set to zero, then no entries
are sent in the message, and no space is reserved for entries. The group
dimensions including the zero-value counter is still transmitted,
however.

### Multiple repeating groups

A message may contain multiple repeating groups at the same level.

Example of encoding specification with multiple repeating groups

```xml
<message name="ExecutionReport" id="8">
    <group name="ContraGrp" id="2012">
    <!-- ContraGrp group fields -->
    </group>
    <group name="PreAllocGrp" id="2026">
    <!-- PreAllocGrp group fields -->
    </group>
</message>
```

### Nested repeating group specification

Repeating groups may be nested to an arbitrary depth. That is, a
`<group>` in a message schema may contain one or more `<group>` child
elements, each associated with their own counter fields.

The encoding specification of nested repeating groups is in the same
format as groups at the root level of a message in a recursive
procedure.

Example of nested repeating group specification

```xml
<group name="ListOrdGrp" id="2030">
    <field name="ClOrdID" id="11" type="string14" semanticType="String"/>
    <field name="ListSeqNo" id="67" type="uint32" semanticType="int"/>
    <field name="Symbol" id="55" type="string8" semanticType="String"/>
    <field name="Side" id="54" type="char" semanticType="char"/>
    <field name="OrderQty" id="38" type="intQty32" semanticType="Qty"/>
    <group name="Parties" id="1012">
        <field name="PartyID" id="448" type="string14" semanticType="String"/>
        <field name="PartyRole" id="452" type="int" semanticType="int"/>
    </group>
</group>
```

### Nested repeating group wire format

Nested repeating groups are encoded on the wire by a depth-first walk of
the data hierarchy. For example, all inner entries under the first outer
entry must be encoded before encoding outer entry 2. (This is the same
element order as FIX tag=value encoding.)

On decoding, nested repeating groups do no support direct access to
fields. It is necessary to walk all elements in sequence to discover the
number of entries in each repeating group.

### Empty group means nested group is empty

If a group contains nested repeating groups, then a NumInGroup counter
of zero implies that both that group and its child groups are empty. In
that case, no NumInGroup is encoded on the wire for the child groups.

### Group dimension encoding

Every repeating group must be immediately preceded on the wire by its
dimensions. The two dimensions are the count of entries in a repeating
group and the space reserved for each entry of the group.

#### Range of group entry count

Implementations should support uint8 and uint16 types for repeating
group entry counts. Optionally, implementations may support any other
unsigned integer types.

By default, the minimum number of entries is zero, and the maximum number is the largest value of the primitiveType of the counter.

| Primitive type | Description             | Length (octets) | Maximum number of entries |
|----------------|-------------------------|----------------:|--------------------------:|
| uint8          | 8-bit unsigned integer  | 1               | 255                       |
| uint16         | 16-bit unsigned integer | 2               | 65535                     |

The number of entries may be restricted to a specific range; see "Restricting repeating group entries" below.

#### Encoding of repeating group dimensions

Conventionally in FIX, a NumInGroup field conveys the number of entries
in a repeating group. In SBE, the encoding conveys two dimensions: the
number of entries and the length of each entry in number octets.
Therefore, the encoding is a composite of those two elements. Block
length and entry count subfields must be encoded as unsigned integer
types.

By default, the name of the group dimension encoding is
groupSizeEncoding. This name may be overridden by setting the
dimensionType attribute of a `<group>` element.

Recommended encoding of repeating group dimensions

```xml
<composite name="groupSizeEncoding">
    <type name="blockLength" primitiveType="uint16"/>
    <type name="numInGroup" primitiveType="uint16" semanticType="NumInGroup"/>
	<type name="numGroups" primitiveType="uint16" />
    <type name="numVarDataFields" primitiveType="uint16" />
</composite>
```

#### Block length

The total space reserved for the fixed-length fields of this repeating group, not counting
any repeating groups or variable-length fields.

#### Number of entries

The number of entries in this repeating group, called NumInGroup in FIX.

##### Number of repeating groups

A count nested repeating groups in this repeating group.

#### Number of variable-length fields

A count of the variable-length fields in this repeating group.

Wire format of NumInGroup with block length 55 octets by 3 entries, containing one nested group and two variable-length fields.

`3700030001000200`

#### Restricting repeating group entries

The occurrences of a repeating group may be restricted to a specific range by modifying the numInGroup member of the group dimension encoding. The minValue attribute controls the minimum number of entries, overriding the default of zero, and the maxValue attribute restricts the maximum entry count to something less than the maximum corresponding to its primitiveType. Either or both attributes may be specified.

Example of a restricted group encoding

```xml
<type name="numInGroup" primitiveType="uint16" semanticType="NumInGroup" minValue="1" maxValue="10" />
```

Sequence of message body elements
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

### Root level elements

To maximize deterministic field positions, message schemas must be
specified with this sequence of message body elements:

1.  Fixed-length fields that reside at the root level of the message
    (that is, not members of repeating groups), including any of the
    following, in the order specified by the message schema::

    a.  Fixed-length scalar fields, such as integers

    b.  Fixed-length character arrays

    c.  Fixed-length composite types, such as MonthYear

2.  Repeating groups, if any.

3.  Data fields, including raw data and variable-length strings, if any.

### Repeating group elements

Repeating group entries are recursively organized in the same fashion as
the root level: fixed-length fields, then nested repeating groups, and
finally, variable-length data fields.

Message structure validation
--------------------------------------------------------------------------------------------------------------------------

Aside from message schema validations (see section 4.8 below), these
validations apply to message structure.

If a message structure violation is detected on a received message, the
message should be rejected back to the counterparty in a way appropriate
to the session protocol.

| Error condition                                                   | Error description                                                                                                                                           |
|-------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Wrong message size in header                                      | A message size value smaller than the actual message may cause a message to be truncated.                                                                   |
| Wrong or unknown template ID in header                            | A mismatch of message schema would likely render a message unintelligible or cause fields to be misinterpreted.                                             |
| Fixed-length field after repeating group or variable-length field | All fixed-length fields in the root of a message or in a repeating group entry must be listed before any (nested) repeating group or variable-length field. |
| Repeating group after variable-length field                       | All repeating groups at the root level or in a nested repeating group must be listed before any variable length field at the same level.                    |
