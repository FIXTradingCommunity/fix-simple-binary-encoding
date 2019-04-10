Release Notes
=============

These are the changes made since SBE version 1.0. 

SBE version 2.0 Release Candidate 1
-------------------
These issues were resolved and accepted for version 2.0 Release Candidate 1. See [issues](https://github.com/FIXTradingCommunity/fix-simple-binary-encoding/issues) and [pull requests](https://github.com/FIXTradingCommunity/fix-simple-binary-encoding/pulls) in GitHub for details and changes.

| Issue | Description                                                    |
|------:|----------------------------------------------------------------|
| 26    | Adding new variable length field in a repeating group          |
| 31    | Presence attribute belongs to a field                          |
| 35    | Field attributes                                               |
| 36    | Document cross-references                                      |
| 37    | Extend message with repeating groups and vardata               |
| 39    | sinceVersion on nested types within a composite                |
| 40    | Clarification on constant char encodings                       |
| 44    | Remove deprecated attributes                                   |
| 45    | Update examples for changed headers                            |
| 48    | Member names for data encoding type                            |
| 51    | Semantic type with Decimal encoding                            |
| 59    | refType is missing semanticAttributes                          |
| 62    | Decimal representation for optional mantissa with non-constant exponent |
| 64    | Support for easy constant value setting in fields              |
| 65    | Alignment of var data and repeating groups                     |
| 87    | update examples for version 2.0                                |


### Compatibility

Version 2.0 is not back-compatible with SBE version 1.0, either in wire format or XML schema.
