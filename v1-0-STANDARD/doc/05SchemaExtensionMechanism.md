Schema Extension Mechanism
=====================================================================================================================================================================================================================================================================

Objective
---------

It is not always practical to update all message publishers and
consumers simultaneously. Within certain constraints, message schemas
and wire formats can be extended in a controlled way. Consumers using an
older version of a schema should be compatible if interpretation of
added fields or messages is not required for business processing.

This specification only details compatibility at the presentation layer. It does not relieve application developers of any responsibility for carefully planning a migration strategy and for handling exceptions at the application layer.

### Constraints

Compatibility is only ensured under these conditions:

-   Fields may be added to either the root of a message or to a
    repeating group, but in each case, they must be appended to end of a
    block.

-   Existing fields cannot change data type or move within a message.

-   A repeating group may be added after existing groups at the root level or nested within another repeating group.

-   A variable-length data field may be added after existing variable-length data at the root level or within a repeating group.

-   Message header encoding cannot change.

-   In general, metadata changes such as name or description corrections do not break compatibility so long as
wire format does not change.

Changes that break those constraints require consumers to update to the
current schema used by publishers. An message template that has changed in an incompatible way must be assinged a new template "id" attribute.

Message schema features for extension
-------------------------------------

### Schema version

The `<messageSchema>` root element contains a version number attribute.
By default, version is zero, the initial version of a message schema.
Each time a message schema is changed, the version number is
incremented.

Version applies to the schema as a whole, not to individual elements.
Version is sent in the message header so the consumer can determine
which version of the message schema was used to encode the message.

See section 4.3.1 above for schema attributes.

### Since version

When a new field, enumeration value, group or message is added to a message schema, the
extension may be documented by adding a sinceVersion attribute to the
element. The sinceVersion attribute tells in which schema version the
element was added. This attribute remains the same for that element for
the lifetime of the schema. This attribute is for documentation purposes
only, it is not sent on the wire.

Over time, multiple extensions may be added to a message schema. New
fields must be appended following earlier extensions. By documenting
when each element was added, it possible to verify that extensions were
appended in proper order.

### Block length

The length of the root level of the message may optionally be documented
on a `<message>` element in the schema using the blockLength attribute.
See section 4.5.3 above for message attributes. If not set in the
schema, block length of the message root is the sum of its field
lengths. Whether it is set in the schema or not, the block length is
sent on the wire to consumers.

Likewise, a repeating group has a blockLength attribute to tell how much
space is reserved for group entries, and the value is sent on the wire.
It is encoded in the schema as part of the NumInGroup field encoding.
See section 3.4.8.2 above.

### Deprecated elements

A message schema may document obsolete elements, such as messages,
fields, and valid values of enumerations with deprecated attribute.
Updated applications should not publish deprecated messages or values,
but declarations may remain in the message schema during a staged
migration to replacement message layouts.

Wire format features for extension
----------------------------------

### Block size

The length of the root level of the message is sent on the wire in the
SBE message header. See section 3.2.2 above. Therefore, if new fields
were appended in a later version of the schema, the consumer would still
know how many octets to consume to find the next message element, such
as repeating group or variable-length Data field. Without the current
schema version, the consumer cannot interpret the new fields, but it
does not break parsing of earlier fields.

Likewise, block size of a repeating group is conveyed in the NumInGroup
encoding.

### Number of repeating groups and variable data

Message headers and repeating group dimensions carry a count of the number of repeating groups and a count of variable-length data fields on the wire. This supports a walk by a decoder of all the elements of a message, even when the decoder was built with an older version of a schema. As for added fixed-length fields, new repeating groups cannot be interpreted by the decoder, but it still can process the ones it knows, and it can correctly reach the end of a message.

Comaptibility strategy
-----------------------
*This suggested strategy is non-normative.*

A message decoder compares the schema version in a received message header to the version that the decoder was built with.

If the *received version is equal to the decoder's version*, then all fields known to the decoder may be parsed, and no further analysis is required.

If the *received version is greater than the decoder's version* (that is, the producer's encoder is newer than the consumer's decoder), then all fields known to the decoder may be parsed but it will be unable to parse added fields. 

Also, an old decoder may encounter unexpected enumeration values. The application layer determines whether an unexpected value is a fatal error. Probably so for a required field since the business meaning is unknown, but it may choose to allow an unknown value of an optional field to pass through. For example, if OrdType value J="Market If Touched" is added to a schema, and the consumer does not recognize it, then the application returns an order rejection with reason "order type not supported", even if it does not know what "J" represents. Note that this is not strictly a versioning problem, however. This exception handling is indistinguishable from the case where "J" was never added to the enum but was simply sent in error.

If the *received version is less than the decoder's version* (that is, the producer's encoder is older than the consumer's decoder), then only the fields of the older version may be parsed. This information is available through metadata as "sinceVersion" attribute of a field. If sinceVersion is greater than received schema version, then the field is not available. How a decoder signals an application that a field is unavailable is an implementation detail. One strategy is for an application to provide a default value for unavailable fields.

Message schema extension example
--------------------------------

Initial version of a message schema

```xml
<messageSchema package="FIXBinaryTest" byteOrder="littleEndian">
    <types>
        <type name="int8" primitiveType="int8"/>
    </types>

<message name="FIX Binary Message1" id="1" blockLength="4">
    <field name="Field1" id="1" type="int8" semanticType="int"/>
</message>

</messageSchema>
```

Second version - a new message is added

```xml
<messageSchema package="FIXBinaryTest" byteOrder="littleEndian"
 version="1">

<types>
    <type name="int8" primitiveType="int8"/>
    <type name="int16" primitiveType="int16"
    sinceVersion="1"/>
</types>

<message name="FIX Binary Message1" id="1" blockLength="4">
    <field name="Field1" id="1" type="int8" semanticType="int"/>
</message>

<!-- New message added in this version-->
<message name="FIX Binary Message2" id="2" blockLength="4"
    sinceVersion="1">
    <field name="Field2" id="2" type="int16" semanticType="int"/>
</message>
</messageSchema>
```

Third version - a field is added

```xml
<messageSchema package="FIXBinaryTest" byteOrder="littleEndian"
 version="2">

<types>
    <type name="int8" primitiveType="int8"/>
    <type name="int16" primitiveType="int16"
     sinceVersion="1"/>
    <type name="int32" primitiveType="int32"
     sinceVersion="2"/>
</types>

<message name="FIX Binary Message1" id="1" blockLength="8">
    <field name="Field1" id="1" type="int8" semanticType="int"/>
    <field name="Field11" id="11" type="int32" semanticType="int"
     sinceVersion="2"/>
</message>

<message name="FIX Binary Message2" id="2" blockLength="4"
     sinceVersion="1">
    <field name="Field2" id="2" type="int16" semanticType="int"/>
</message>
</messageSchema>
```
