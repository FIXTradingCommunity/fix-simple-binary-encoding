# fix-simple-binary-encoding

[![Join the chat at https://gitter.im/fix-simple-binary-encoding/Lobby](https://badges.gitter.im/fix-simple-binary-encoding/Lobby.svg)](https://gitter.im/fix-simple-binary-encoding/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

This project contains specifications and resources for Simple Binary Encoding (SBE).
SBE is a FIX standard for binary message encoding. 

For a fuller explanation, see [FIX Simple Binary Encoding](http://fixtradingcommunity.github.io/fix-simple-binary-encoding/).

## Protocol stack
SBE is part of a family of protocols created by the High Performance Working Group
 of the FIX Trading Community. SBE is a presentation layer protocol (layer 6).

## Versions

### Planned Lifecycle

The planned lifecycle of this project is to roll out new features in a series of release candidates. After each release candidate is approved, it will be exposed to public review. Issues may be entered here in GitHub or in a discussion forum on the FIX Trading Community site. When a version is considered complete, the last release candidate will be promoted to Draft Standard. Following further public review, a Draft Standard may be promoted to the final specification for that version. Only minor errata are permitted. To reach the final stage, the Draft Standard must be reviewed for no less than 6 months, and at least two interoperable implementations must be certified. That version is henceforth immutable.

### Current version: 1.0 Technical Specification
Version 1.0 Draft Standard was promoted to SBE version 1.0 Technical Specification by the Global Technical Committee on Feb. 9, 2016. This is the final specification of version 1.0.

The standard met these criteria for promotion:
* More than 6 months public review. During the period, some minor errors were found, and the errata were incorporated into the final specification. Thanks to users who detected those errors.

* At least two interopable implementations. This was demonstrated with the conformance test suite described below.

SBE standards are available here in GitHub and on the [FIX Trading Community site](http://www.fixtradingcommunity.org/pg/structure/tech-specs/simple-binary-encoding).

### Working version: 2.0 Release Candidate 1

The working group will consider issues and pull requests for the next release candidate. The planned themes for Version 2.0 Release Candidate 1 are:
* Further enhancements to the schema extension mechanism
* Improvement of the XML schema

### Participation
All users are encouraged to contribute, especially by reviewing proposed changes in the form of pull requests. Your feedback counts.

Interested parties who wish to participate in the FIX High Performance Working Group should contact fix@fixtrading.org and state that your interest is in SBE, which sometimes meets as a subgroup. Membership in FIX Trading Community is not required to participate in technical working groups.

### Conformance test suite
The [SBE Conformance project](https://github.com/FIXTradingCommunity/fix-sbe-conformance) provides a conformance test suite to verify interoperability of SBE implementations. All implementors are invited to demonstrate their conformance to the standard.

### XML namespace
The XML namespace for SBE version 1.0 message schemas is [http://fixprotocol.io/2016/sbe](http://fixprotocol.io/2016/sbe).

## License
FIX Simple Binary Encoding specifications are © Copyright 2014-2017 FIX Protocol Ltd.

<a rel="license" href="http://creativecommons.org/licenses/by-nd/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nd/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">FIX Simple Binary Encoding</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.fixtradingcommunity.org/" property="cc:attributionName" rel="cc:attributionURL">FIX Protocol Ltd.</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nd/4.0/">Creative Commons Attribution-NoDerivatives 4.0 International License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="https://github.com/FIXTradingCommunity/fix-simple-binary-encoding" rel="dct:source">https://github.com/FIXTradingCommunity/fix-simple-binary-encoding</a>

## Implementations
We will post links to open source implementations of SBE. Implementors, contact one
of the owners of this repository.



