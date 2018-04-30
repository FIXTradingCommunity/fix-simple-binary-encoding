Examples
========

The example messages are preceded by Simple Open Framing Header. Note
that SOFH encoding is always big-endian, regardless of the byte order of
the SBE message body. See that FIX standard for details.

Not all FIX enumeration values are listed in the samples.

Flat, fixed-length message
--------------------------

This is an example of a simple, flat order message without repeating
groups or variable-length data.

### Sample order message schema

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>

<sbe:messageSchema 
	xmlns:sbe="http://fixprotocol.io/2016/sbe"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    package="Examples" id="100"
    description="Test dictionary"
    byteOrder="littleEndian"
	xsi:schemaLocation="http://fixprotocol.io/2016/sbe sbe.xsd">

<types>
    <type name="enumEncoding" primitiveType="char"/>
    <type name="idString" length="8" primitiveType="char" semanticType="String"/>
    <type name="timestampEncoding" primitiveType="uint64" semanticType="UTCTimestamp"/>

    <composite name="messageHeader">
        <type name="blockLength" primitiveType="uint16"/>
        <type name="templateId" primitiveType="uint16"/>
        <type name="schemaId" primitiveType="uint16"/>
        <type name="version" primitiveType="uint16"/>
    </composite>

    <composite name="optionalDecimalEncoding"
        description="Optional decimal with constant exponent">
        <type name="mantissa" presence="optional" primitiveType="int64"/>
        <type name="exponent" presence="constant" primitiveType="int8">-3</type>
    </composite>

    <composite name="qtyEncoding" description="Decimal constrained to integers">
        <type name="mantissa" primitiveType="int32"/>
        <type name="exponent" presence="constant" primitiveType="int8">0</type>
    </composite>

    <enum name="ordTypeEnum" encodingType="enumEncoding">
        <validValue name="Market" description="Market">1</validValue>
        <validValue name="Limit" description="Limit">2</validValue>
        <validValue name="Stop" description="Stop Loss">3</validValue>
        <validValue name="StopLimit" description="Stop Limit">4</validValue>
    </enum>

   <enum name="sideEnum" encodingType="enumEncoding">
        <validValue name="Buy" description="Buy">1</validValue>
        <validValue name="Sell" description="Sell">2</validValue>
   </enum>

</types>

<sbe:message name="NewOrderSingle" id="99" blockLength="54"
semanticType="D">
    <field name="ClOrdID" id="11" type="idString" description="Customer Order ID"
        offset="0" semanticType="String"/>
    <field name="Account" id="1" type="idString" description="Account mnemonic"
        offset="8" semanticType="String"/>
    <field name="Symbol" id="55" type="idString" description="Security ID"
        offset="16" semanticType="String"/>
    <field name="Side" id="54" type="sideEnum" description="Side" offset="24"
        semanticType="char"/>
    <field name="TransactTime" id="60" type="timestampEncoding"
        description="Order entry time" offset="25" semanticType="UTCTimestamp"/>
    <field name="OrderQty" id="38" type="qtyEncoding" description="Order quantity"
        offset="33" semanticType="Qty"/>
    <field name="OrdType" id="40" type="ordTypeEnum" description="Order type"
        offset="37" semanticType="char"/>
    <field name="Price" id="44" type="optionalDecimalEncoding"
        description="Limit price" offset="38" semanticType="Price"/>
    <field name="StopPx" id="99" type="optionalDecimalEncoding"
        description="Stop price" offset="46" semanticType="Price"/>
</sbe:message>

</sbe:messageSchema>
```

**Notes on the message schema**

In this case, there is a lot of verbiage for one message, but in
practice, a schema would define a set of messages. The same encodings
within the `<types>` element would be used for a whole collection of
messages. For example, a price encoding need only be defined once but
can be used in any number of messages in a schema. Many of the
attributes, such as description, offset, and semanticType, are optional
but are shown here for a full illustration.

All character fields in the message are fixed-length. Values may be
shorter than the specified field length, but not longer. Since all
fields are fixed-length, they are always in a fixed position, supporting
direct access to data.

An enumeration gives the valid values of a field. Both enumerations in
the example use character encoding, but note that some enumerations in
FIX are of integer type.

There are two decimal encodings. The one used for quantity sets the
exponent to constant zero. In effect there is no fractional part and
only the mantissa is sent on the wire, acting as an integer. However,
FIX defines Qty as a float type since certain asset classes may use
fractional shares.

The other decimal encoding is used for prices. The exponent is
constant -3. In essence, each price is transmitted as an integer on the
wire with assumed three decimal places. Each of the prices in the
message is conditionally required. If OrdType=Limit, then Price field
required. If OrdType=Stop then StopPx is required. Otherwise, if
OrdType=Market, then neither price is required. Therefore, the price
takes an optional encoding. To indicate that it is null, a special value
is sent on the wire. See the table in section 2.4.2 above for the null
value of the int64 mantissa.

In this example, all fields are packed without special byte alignment.
Performance testing may prove better results with a different
arrangement of the fields or adjustments to field offsets. However,
those sorts of optimizations are platform dependent.

### Wire format of an order message

Hexadecimal and ASCII representations (little-endian byte order):

```
00 00 00 44 eb 50 36 00 63 00 5b 00 00 00 4f 52 :   D P6 c [   OR
44 30 30 30 30 31 41 43 43 54 30 31 00 00 47 45 :D00001ACCT01  GE
4d 34 00 00 00 00 31 80 16 b3 3b 13 65 29 15 07 :M4    1   ; e)  
00 00 00 32 1a 85 01 00 00 00 00 00 00 00 00 00 :   2            
00 00 00 80  
```                                   

**Interpretation**

|Wire format|Field ID|Name|Offset|Length|Interpreted value|
|-----------|-------:|----|-----:|-----:|-----------------|
| `00000044` |   | SOFH message length | 0 | 4 | 68 |
| `eb50` |   | SOFH encoding | 4 | 2 | SBE little-endian |
| `3600` |   | SBE block length | 0 | 2 | 54 |
| `6300` |   | SBE template ID | 2 | 2 | 99 |
| `5b00` |   | SBE schema ID | 4 | 2 | 91 |
| `0000` |   | SBE schema version | 6 | 2 | 0 |
| `4f52443030303031` | 11 | ClOrdId | 0 | 8 | ORD00001 |
| `4143435430310000` | 1 | Account | 8 | 8 | ACCT01 |
| `47454d3400000000` | 55 | Symbol | 16 | 8 | GEM4 |
| `31` | 54 | Side | 24 | 1 | Buy |
| `8016b33b13652915` | 60 | TransactTime | 25 | 8 | 2018-04-27T20:31:22.122Z |
| `07000000` | 38 | OrderQty | 33 | 4 | 7 |
| `32` | 40 | OrdType | 37 | 1 | Limit |
| `1a85010000000000` | 44 | Price | 38 | 8 | 99.610 |
| `0000000000000080` | 99 | StopPx | 46 | 8 | null |
Message with a repeating group
------------------------------

This is an example of a message with a repeating group.

### Sample execution report message schema

Add this encoding types element to those in the previous example.

```xml
<types>
    <type name="date" primitiveType="uint16" semanticType="LocalMktDate"/>
    <composite name="MONTH_YEAR" semanticType="MonthYear">
        <type name="year" primitiveType="uint16"/>
        <type name="month" primitiveType="uint8"/>
        <type name="day" primitiveType="uint8"/>
        <type name="week" primitiveType="uint8"/>
    </composite>

    <composite name="groupSizeEncoding" description="Repeating group dimensions">
        <type name="blockLength" primitiveType="uint16"
        semanticType="Length"/>
        <type name="numInGroup" primitiveType="uint16"
        semanticType="NumInGroup"/>
    </composite>

    <enum name="execTypeEnum" encodingType="enumEncoding">
        <validValue name="New" description="New">0</validValue>
        <validValue name="DoneForDay" description="Done for day">3</validValue>
        <validValue name="Canceled" description="Canceled">4</validValue>
        <validValue name="Replaced" description="Replaced">5</validValue>
        <validValue name="PendingCancel">6</validValue>
        <validValue name="Rejected" description="Rejected">8</validValue>
        <validValue name="PendingNew" description="Pending New">A</validValue>
        <validValue name="Trade" description="partial fill or fill">F</validValue>
    </enum>

    <enum name="ordStatusEnum" encodingType="enumEncoding">
        <validValue name="New" description="New">0</validValue>
        <validValue name="PartialFilled">1</validValue>
        <validValue name="Filled" description="Filled">2</validValue>
        <validValue name="DoneForDay" description="Done for day">3</validValue>
        <validValue name="Canceled" description="Canceled">4</validValue>
        <validValue name="PendingCancel">6</validValue>
        <validValue name="Rejected" description="Rejected">8</validValue>
        <validValue name="PendingNew" description="Pending New">A</validValue>
        <validValue name="PendingReplace" >E</validValue>
    </enum>

</types>

<sbe:message name="ExecutionReport" id="98" blockLength="42"
semanticType="8">
    <field name="OrderID" id="37" type="idString" description="Order ID"
    offset="0" semanticType="String"/>
    <field name="ExecID" id="17" type="idString" description="Execution ID"
    offset="8" semanticType="String"/>
    <field name="ExecType" id="150" type="execTypeEnum"
    description="Execution type" offset="16" semanticType="char"/>
    <field name="OrdStatus" id="39" type="ordStatusEnum"
    description="Order status" offset="17" semanticType="char"/>
    <field name="Symbol" id="55" type="idString" description="Security ID"
    offset="18" semanticType="String"/>
    <field name="MaturityMonthYear" id="200" type="MONTH_YEAR"
    description="Expiration" offset="26" semanticType="MonthYear"/>
    <field name="Side" id="54" type="sideEnum" description="Side" offset="31"
    semanticType="char"/>
    <field name="LeavesQty" id="151" type="qtyEncoding"
    description="Quantity open" offset="32" semanticType="Qty"/>
    <field name="CumQty" id="14" type="qtyEncoding"
    description="Executed quantity" offset="36" semanticType="Qty"/>
    <field name="TradeDate" id="75" type="date"
    description="Trade date" offset="40" semanticType="LocalMktDate"/>
    <group name="FillsGrp" id="2112" description="Partial fills"
    blockLength="12" dimensionType="groupSizeEncoding">
        <field name="FillPx" id="1364" type="optionalDecimalEncoding"
        description="Price of partial fill" offset="0" semanticType="Price"/>
        <field name="FillQty" id="1365" type="qtyEncoding"
        description="Executed quantity" offset="8" semanticType="Qty"/>
    </group>
</sbe:message>
```

**Notes on the message schema**

The message contains a MonthYear field. It is encoded as a composite
type with year, month, day and week subfields.

This message layout contains a repeating group containing a collection
of partial fills for an execution report. The `<group>` XML tag enclosed
the fields within a group entry. The dimensions of the repeating group
are encoding as a composite type called groupSizeEncoding.

### Wire format of an execution message

Hexadecimal and ASCII representations (little-endian byte order):

```
00 00 00 54 eb 50 2a 00 62 00 5b 00 00 00 4f 30 :   T P* b [   O0
30 30 30 30 30 31 45 58 45 43 30 30 30 30 46 31 :000001EXEC0000F1
47 45 4d 34 00 00 00 00 de 07 06 ff ff 31 01 00 :GEM4         1  
00 00 06 00 00 00 75 3e 0c 00 02 00 1a 85 01 00 :      u>        
00 00 00 00 02 00 00 00 24 85 01 00 00 00 00 00 :        $       
04 00 00 00                                     :    
```

### Interpretation
Offset is from beginning of block.

|Wire format|Field ID|Name|Offset|Length|Interpreted value|
|-----------|-------:|----|-----:|-----:|-----------------|
| `00000054` |   | SOFH message length | 0 | 4 | 84 |
| `eb50` |   | SOFH encoding | 4 | 2 | SBE little-endian |
| `2a00` |   | SBE block length | 0 | 2 | 42 |
| `6200` |   | SBE template ID | 2 | 2 | 98 |
| `5b00` |   | SBE schema ID | 4 | 2 | 91 |
| `0000` |   | SBE schema version | 6 | 2 | 0 |
| `4558454330303030` | 37 | OrderID | 8 | 8 | O0000001 |
| `4558454330303030` | 17 | ExecID | 8 | 8 | EXEC0000 |
| `30` | 39 | OrdStatus | 1 | 1 | PartialFilled |
| `47454d3400000000` | 55 | Symbol | 18 | 8 | GEM4 |
| `de0706ffff` | 200 | MaturityMonthYear | 26 | 5 | year=2014 month=6 |
| `30` | 54 | Side | 1 | 1 | Buy |
| `01000000` | 151 | LeavesQty | 32 | 4 | 1 |
| `06000000` | 14 | CumQty | 36 | 4 | 6 |
| `753e` | 75 | TradeDate | 40 | 2 | 2013-10-11 |
| `0c000200` |   | FillGrp | 0 | 4 | Block length=12 count=2 |
| `1a85010000000000` | 1364 | FillPx | 0 | 8 | 99.610 |
| `02000000` | 1365 | FillQty | 8 | 4 | 2 |
| `2485010000000000` | 1364 | FillPx | 0 | 8 | 99.620 |
| `04000000` | 1365 | FillQty | 8 | 4 | 4 |
Message with a variable-length field
------------------------------------

### Sample business reject message schema

Add this encoding types element to those in the previous example.

```xml

<types>
    <type name="intEnumEncoding" primitiveType="uint8"/>

    <composite name="DATA" description="Variable-length data">
        <type name="length" primitiveType="uint16" />
        <type name="varData" length="0" primitiveType="uint8">
    </composite>

    <enum name="businessRejectReasonEnum" encodingType="intEnumEncoding">>
        <validValue name="Other" 0</validValue>
        <validValue name="UnknownID" 1</validValue>
        <validValue name="UnknownSecurity" >2</validValue>
        <validValue name="ApplicationNotAvailable" >4</validValue>
        <validValue name="NotAuthorized" >6</validValue>
    </enum>

</types>

	<sbe:message name="BusinessMessageReject" id="97"
		blockLength="9" semanticType="j">
		<field name="BusinesRejectRefId" id="379" type="idString"
			offset="0" semanticType="String" />
		<field name="BusinessRejectReason" id="380" type="businessRejectReasonEnum"
			offset="8" semanticType="int" />
		<data name="Text" id="58" type="DATA" semanticType="data" />
	</sbe:message>
```

### Wire format of a business reject message

Hexadecimal and ASCII representations (little-endian byte order):
```
00 00 00 40 eb 50 09 00 61 00 5b 00 00 00 4f 52 :   @ P  a [   OR
44 30 30 30 30 31 06 27 00 4e 6f 74 20 61 75 74 :D00001 ' Not aut
68 6f 72 69 7a 65 64 20 74 6f 20 74 72 61 64 65 :horized to trade
20 74 68 61 74 20 69 6e 73 74 72 75 6d 65 6e 74 : that instrument
```

### Interpretation
|Wire format|Field ID|Name|Offset|Length|Interpreted value|
|-----------|-------:|----|-----:|-----:|-----------------|
| `00000040` |   | SOFH message length | 0 | 4 | 64 |
| `eb50` |   | SOFH encoding | 4 | 2 | SBE little-endian |
| `0900` |   | SBE block length | 0 | 2 | 9 |
| `6100` |   | SBE template ID | 2 | 2 | 97 |
| `5b00` |   | SBE schema ID | 4 | 2 | 91 |
| `0000` |   | SBE schema version | 6 | 2 | 0 |
| `4f52443030303031` | 379 | BusinesRejectRefId | 0 | 8 | ORD00001 |
| `06` | 380 | BusinessRejectReason | 8 | 1 | NotAuthorized |
| `4e6f74206175...` | 58 | Text | 0 | 39 | Not authorized to trade that instrument |