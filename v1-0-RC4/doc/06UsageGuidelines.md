Usage Guidelines
================

Identifier encodings
-------------------------------------------------------------------------------------------------------------------

FIX specifies request and entity identifiers as String type. Common
practice is to specify an identifier field as fixed-length character of
a certain size.

Optionally, a message schema may restrict such identifiers to numeric
encodings.

Example of an identifier field with character encoding

```xml
<type name="idString" primitiveType="char" length="16" />

<field name="QuoteReqId" id="131" type="idString"
 semanticType="String"/>
 ```

Example of an identifier field with numeric encoding

```xml
<type name="uint64" primitiveType="uint64" />

<field name="QuoteReqId" id="131" type="uint64"
 semanticType="String"/>
```
