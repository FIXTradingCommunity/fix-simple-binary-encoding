# Examples

The example messages are preceded by Simple Open Framing Header. Note
that SOFH encoding is always big-endian, regardless of the byte order of
the SBE message body. See that FIX standard for details.

Not all FIX enumeration values are listed in the samples.

## SBE Message Schema
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<messageSchema xmlns="http://fixprotocol.io/2017/sbe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" package="Examples" id="91" version="0" byteOrder="littleEndian" xsi:schemaLocation="http://fixprotocol.io/2017/sbe sbe-2.0rc3.xsd">
	<types>
		<type name="date" primitiveType="uint16"/>
		<type name="enumEncoding" primitiveType="char"/>
		<type name="idString" length="8" primitiveType="char" characterEncoding="ISO_8859_1"/>
		<type name="intEnumEncoding" primitiveType="uint8"/>
		<type name="currency" length="3" primitiveType="char" description="ISO 4217"/>
		<composite name="DATA">
			<type name="length" primitiveType="uint16"/>
			<type name="varData" length="0" primitiveType="uint8"/>
		</composite>
		<composite name="MONTH_YEAR">
			<type name="year" primitiveType="uint16"/>
			<type name="month" primitiveType="uint8"/>
			<type name="day" primitiveType="uint8"/>
			<type name="week" primitiveType="uint8"/>
		</composite>
		<composite name="groupSizeEncoding">
			<type name="blockLength" primitiveType="uint16"/>
			<type name="numInGroup" primitiveType="uint16"/>
			<type name="numGroups" primitiveType="uint16"/>
			<type name="numVarDataFields" primitiveType="uint16"/>
		</composite>
		<composite name="messageHeader">
			<type name="blockLength" primitiveType="uint16"/>
			<type name="templateId" primitiveType="uint16"/>
			<type name="schemaId" primitiveType="uint16"/>
			<type name="version" primitiveType="uint16"/>
			<type name="numGroups" primitiveType="uint16"/>
			<type name="numVarDataFields" primitiveType="uint16"/>
		</composite>
		<composite name="decimalEncoding">
			<type name="mantissa" primitiveType="int64"/>
			<type name="exponent" primitiveType="int8">-3</type>
		</composite>
		<composite name="qtyEncoding">
			<type name="mantissa" primitiveType="int32"/>
			<type name="exponent" primitiveType="int8">0</type>
		</composite>
		<composite name="timestampEncoding" description="UTC timestamp with nanosecond precision">
			<type name="time" primitiveType="uint64"/>
			<type name="unit" primitiveType="uint8" presence="constant" valueRef="TimeUnit.nanosecond"/>
		</composite>
		<enum name="TimeUnit" encodingType="uint8">
			<validValue name="second">0</validValue>
			<validValue name="millisecond">3</validValue>
			<validValue name="microsecond">6</validValue>
			<validValue name="nanosecond">9</validValue>
		</enum>
		<enum name="businessRejectReasonEnum" encodingType="intEnumEncoding">
			<validValue name="Other">0</validValue>
			<validValue name="UnknownID">1</validValue>
			<validValue name="UnknownSecurity">2</validValue>
			<validValue name="ApplicationNotAvailable">4</validValue>
			<validValue name="NotAuthorized">6</validValue>
		</enum>
		<enum name="execTypeEnum" encodingType="enumEncoding">
			<validValue name="New">0</validValue>
			<validValue name="DoneForDay">3</validValue>
			<validValue name="Canceled">4</validValue>
			<validValue name="Replaced">5</validValue>
			<validValue name="PendingCancel">6</validValue>
			<validValue name="Rejected">8</validValue>
			<validValue name="PendingNew">A</validValue>
			<validValue name="Trade">F</validValue>
		</enum>
		<enum name="ordStatusEnum" encodingType="enumEncoding">
			<validValue name="New">0</validValue>
			<validValue name="PartialFilled">1</validValue>
			<validValue name="Filled">2</validValue>
			<validValue name="DoneForDay">3</validValue>
			<validValue name="Canceled">4</validValue>
			<validValue name="PendingCancel">6</validValue>
			<validValue name="Rejected">8</validValue>
			<validValue name="PendingNew">A</validValue>
			<validValue name="PendingReplace">E</validValue>
		</enum>
		<enum name="ordTypeEnum" encodingType="enumEncoding">
			<validValue name="Market">1</validValue>
			<validValue name="Limit">2</validValue>
			<validValue name="Stop">3</validValue>
			<validValue name="StopLimit">4</validValue>
		</enum>
		<enum name="sideEnum" encodingType="enumEncoding">
			<validValue name="Buy">1</validValue>
			<validValue name="Sell">2</validValue>
		</enum>
	</types>
	<messages>
		<message name="BusinessMessageReject" id="97" blockLength="9" semanticType="j">
			<field name="BusinessRejectRefID" id="379" type="idString" offset="0" semanticType="String"/>
			<field name="BusinessRejectReason" id="380" type="businessRejectReasonEnum" offset="8" semanticType="int"/>
			<data name="Text" id="58" type="DATA" semanticType="data"/>
		</message>
		<message name="ExecutionReport" id="98" blockLength="42" semanticType="8">
			<field name="OrderID" id="37" type="idString" offset="0" semanticType="String"/>
			<field name="ExecID" id="17" type="idString" offset="8" semanticType="String"/>
			<field name="ExecType" id="150" type="execTypeEnum" offset="16" semanticType="char"/>
			<field name="OrdStatus" id="39" type="ordStatusEnum" offset="17" semanticType="char"/>
			<field name="Symbol" id="55" type="idString" offset="18" semanticType="String"/>
			<field name="MaturityMonthYear" id="200" type="MONTH_YEAR" offset="26" semanticType="MonthYear"/>
			<field name="Side" id="54" type="sideEnum" offset="31" semanticType="char"/>
			<field name="LeavesQty" id="151" type="qtyEncoding" offset="32" semanticType="Qty"/>
			<field name="CumQty" id="14" type="qtyEncoding" offset="36" semanticType="Qty"/>
			<field name="TradeDate" id="75" type="date" offset="40" semanticType="LocalMktDate"/>
			<group name="FillsGrp" id="2112" blockLength="12" dimensionType="groupSizeEncoding">
				<field name="FillPx" id="1364" type="decimalEncoding" offset="0" semanticType="Price"/>
				<field name="FillQty" id="1365" type="qtyEncoding" offset="8" semanticType="Qty"/>
			</group>
		</message>
		<message name="NewOrderSingle" id="99" blockLength="54" semanticType="D">
			<field name="ClOrdId" id="11" type="idString" offset="0" semanticType="String"/>
			<field name="Account" id="1" type="idString" offset="8" semanticType="String"/>
			<field name="Symbol" id="55" type="idString" offset="16" semanticType="String"/>
			<field name="Side" id="54" type="sideEnum" offset="24" semanticType="char"/>
			<field name="TransactTime" id="60" type="timestampEncoding" offset="25" semanticType="UTCTimestamp"/>
			<field name="OrderQty" id="38" type="qtyEncoding" offset="33" semanticType="Qty"/>
			<field name="OrdType" id="40" type="ordTypeEnum" offset="37" semanticType="char"/>
			<field name="Price" id="44" type="decimalEncoding" offset="38" semanticType="Price" presence="optional"/>
			<field name="StopPx" id="99" type="decimalEncoding" offset="46" semanticType="Price" presence="optional"/>
		</message>
	</messages>
</messageSchema>
```

## Flat, fixed-length message

This is an example of a simple, flat order message without repeating
groups or variable-length data.

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
is sent on the wire. See the table in section [*Range attributes for integer fields*](#range-attributes-for-integer-fields) above for the null
value of the int64 mantissa.

In this example, all fields are packed without special byte alignment.
Performance testing may prove better results with a different
arrangement of the fields or adjustments to field offsets. However,
those sorts of optimizations are platform dependent.

### Wire format of an order message

Hexadecimal and ASCII representations (little-endian byte order):
```
00 00 00 48 eb 50 36 00 63 00 5b 00 00 00 00 00 :   H P6 c [     
00 00 4f 52 44 30 30 30 30 31 41 43 43 54 30 31 :  ORD00001ACCT01
00 00 47 45 4d 34 00 00 00 00 31 c0 1a 31 96 2a :  GEM4    1  1 *
5e b0 15 07 00 00 00 32 1a 85 01 00 00 00 00 00 :^      2        
00 00 00 00 00 00 00 80                         :        
```
### Interpretation
|Wire format|Field ID|Name|Offset|Length|Interpreted value|
|-----------|-------:|----|-----:|-----:|-----------------|
| `00000048` |   | SOFH message length | 0 | 4 | 72 |
| `eb50` |   | SOFH encoding | 4 | 2 | SBE little-endian |
| `3600` |   | SBE root block length | 0 | 2 | 54 |
| `6300` |   | SBE template ID | 2 | 2 | 99 |
| `5b00` |   | SBE schema ID | 4 | 2 | 91 |
| `0000` |   | SBE schema version | 6 | 2 | 0 |
| `0000` |   | No. of groups | 8 | 2 | 0 |
| `0000` |   | No. of var data | 10 | 2 | 0 |
| `4f52443030303031` | 11 | ClOrdId | 0 | 8 | ORD00001 |
| `4143435430310000` | 1 | Account | 8 | 8 | ACCT01 |
| `47454d3400000000` | 55 | Symbol | 16 | 8 | GEM4 |
| `31` | 54 | Side | 24 | 1 | Buy |
| `c01a31962a5eb015` | 60 | TransactTime | 25 | 8 | 2019-07-11T13:43:27.699Z |
| `07000000` | 38 | OrderQty | 33 | 4 | 7 |
| `32` | 40 | OrdType | 37 | 1 | Limit |
| `1a85010000000000` | 44 | Price | 38 | 8 | 99.610 |
| `0000000000000080` | 99 | StopPx | 46 | 8 | null |

## Message with a repeating group

This is an example of a message with a repeating group.

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
00 00 00 5c eb 50 2a 00 62 00 5b 00 00 00 01 00 :   \ P* b [     
00 00 4f 30 30 30 30 30 30 31 45 58 45 43 30 30 :  O0000001EXEC00
30 30 46 31 47 45 4d 34 00 00 00 00 de 07 06 ff :00F1GEM4        
ff 31 01 00 00 00 06 00 00 00 75 3e 0c 00 02 00 : 1        u>    
00 00 00 00 1a 85 01 00 00 00 00 00 02 00 00 00 :                
24 85 01 00 00 00 00 00 04 00 00 00             :$           
```
### Interpretation
Offset is from beginning of block.

|Wire format|Field ID|Name|Offset|Length|Interpreted value|
|-----------|-------:|----|-----:|-----:|-----------------|
| `0000005c` |   | SOFH message length | 0 | 4 | 92 |
| `eb50` |   | SOFH encoding | 4 | 2 | SBE little-endian |
| `2a00` |   | SBE root block length | 0 | 2 | 42 |
| `6200` |   | SBE template ID | 2 | 2 | 98 |
| `5b00` |   | SBE schema ID | 4 | 2 | 91 |
| `0000` |   | SBE schema version | 6 | 2 | 0 |
| `0100` |   | No. of groups | 8 | 2 | 1 |
| `0000` |   | No. of var data | 10 | 2 | 0 |
| `4f30303030303031` | 37 | OrderID | 8 | 8 | O0000001 |
| `4558454330303030` | 17 | ExecID | 8 | 8 | EXEC0000 |
| `31` | 39 | OrdStatus | 1 | 1 | PartialFilled |
| `47454d3400000000` | 55 | Symbol | 18 | 8 | GEM4 |
| `de0706ffff` | 200 | MaturityMonthYear | 26 | 5 | year=2014 month=6 |
| `31` | 54 | Side | 1 | 1 | Buy |
| `01000000` | 151 | LeavesQty | 32 | 4 | 1 |
| `06000000` | 14 | CumQty | 36 | 4 | 6 |
| `753e` | 75 | TradeDate | 40 | 2 | 2013-10-11 |
| `0c00` |   | Group block length | 0 | 2 | 12 |
| `0200` |   | NumInGroup | 4 | 2 | 2 |
| `0000` |   | No. of groups | 4 | 2 | 0 |
| `0000` |   | No. of var data | 6 | 2 | 0 |
| `1a85010000000000` | 1364 | FillPx | 0 | 8 | 99.610 |
| `02000000` | 1365 | FillQty | 8 | 4 | 2 |
| `2485010000000000` | 1364 | FillPx | 0 | 8 | 99.620 |
| `04000000` | 1365 | FillQty | 8 | 4 | 4 |

## Message with a variable-length field

### Wire format of a business reject message

```
00 00 00 44 eb 50 09 00 61 00 5b 00 00 00 00 00 :   D P  a [     
01 00 4f 52 44 30 30 30 30 31 06 27 00 4e 6f 74 :  ORD00001 ' Not
20 61 75 74 68 6f 72 69 7a 65 64 20 74 6f 20 74 : authorized to t
72 61 64 65 20 74 68 61 74 20 69 6e 73 74 72 75 :rade that instru
6d 65 6e 74                                     :ment
```
### Interpretation
|Wire format|Field ID|Name|Offset|Length|Interpreted value|
|-----------|-------:|----|-----:|-----:|-----------------|
| `00000044` |   | SOFH message length | 0 | 4 | 68 |
| `eb50` |   | SOFH encoding | 4 | 2 | SBE little-endian |
| `0900` |   | SBE root block length | 0 | 2 | 9 |
| `6100` |   | SBE template ID | 2 | 2 | 97 |
| `5b00` |   | SBE schema ID | 4 | 2 | 91 |
| `0000` |   | SBE schema version | 6 | 2 | 0 |
| `0000` |   | No. of groups | 8 | 2 | 0 |
| `0100` |   | No. of var data | 10 | 2 | 1 |
| `4f52443030303031` | 379 | BusinessRejectRefID | 0 | 8 | ORD00001 |
| `06` | 380 | BusinessRejectReason | 8 | 1 | NotAuthorized |
| `4e6f74206175...` | 58 | Text | 0 | 39 | Not authorized to trade that instrument |
