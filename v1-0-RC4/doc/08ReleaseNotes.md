Release Notes
=============
Release Candidate 4
-------------------
[to come]


Release Candidate 3
-------------------

This is a summary of document changes to Release Candidate 3 from RC2.
Changes in this release were intended only as clarifications or to add
capabilities. Message schemas that conformed to the RC2 specification
should still conform to the RC3 wire format.

**Section 1**

References section expanded.

**Section 2**

-   Statement added that non-FIX data types should not carry a
    semanticType attribute in a message schema.

-   String encoding section split into two sections for strings (text
    fields) and data (non-character data) to clarify the distinction.
    Both text and non-text can be either fixed-length `<field>` or
    variable-length `<data>`.

-   Timestamp encoding enhanced to allow time unit to either be
    specified as a constant in a message schema or to be serialized on
    the wire.

**Section 3**

Message structure is enhanced to allow variable-length `<data>` elements
within a repeating group entry.

**Section 4**

Message schema XSD updated to support `<data>` in repeating groups and
for various other refinements

**Section 5**

-   Statements added to say whole repeating groups or variable data may
    be added to a message without breaking compatibility so long as the
    added elements are at the end of a message.

-   Added deprecated schema attribute to mark obsolete elements.

**Section 6**

No change

**Section 7**

Examples updated to use Simple Open Framing Header.

**Section 8**

Release notes added.
