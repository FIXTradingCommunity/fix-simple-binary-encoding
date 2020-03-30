#!/bin/bash

# This script must be run in the directory where you want the generated output to be.
# This should not be the directory of the GitHub clone as the repository should not contain generated content.
TARGET="$PWD"

echo Compilation started...
LOCAL="<INSERT YOUR LOCAL PATH TO THE GITHUB CLONE DIRECTORY HERE>"
ROOT="$LOCAL/GitHub/fix-simple-binary-encoding/v1-0-STANDARD/doc"
# There is only one disclaimer and style docx file for all FIX Technical Standards and it is stored with the FIX Session Layer
DISCLAIMER="$LOCAL/GitHub/fix-session-layer-standards/FIXDisclaimerTechStd.md"
STYLE="$LOCAL/GitHub/fix-session-layer-standards/FIX_TechStd_Style_MASTER.docx"
SOURCE="$ROOT"
YAML="$SOURCE/SBE.yaml"
FILES="01Introduction.md 02FieldEncoding.md 03MessageStructure.md 04MessageSchema.md 05SchemaExtensionMechanism.md 06UsageGuidelines.md 07Examples.md"
WPFOLDER="wp-content\/uploads\/2020\/03"

cd "$SOURCE"

# Create document version with disclaimer
pandoc "$DISCLAIMER" $FILES -o "$TARGET/Simple Binary Encoding V1.0.docx" --reference-doc="$STYLE" --metadata-file="$YAML" --toc --toc-depth=4
echo SBE document version created

# Create base online version without disclaimer
pandoc $FILES -o "$TARGET/SBEONLINE.html"

# Switch back to target directory for changing content of generated output with SED utility
cd "$TARGET"

# Create separate online versions for production and test website by including appropriate link prefixes
sed s/"img src=\"media\/"/"img src=\"https:\/\/www.fixtrading.org\/$WPFOLDER\/"/g SBEONLINE.html > SBEONLINE_PROD.html
sed s/"img src=\"media\/"/"img src=\"https:\/\/www.technical-fixprotocol.org\/$WPFOLDER\/"/g SBEONLINE.html > SBEONLINE_TEST.html

# Change remaining links to production website in test version to test website
sed -i '.bak' s/www.fixtrading.org/www.technical-fixprotocol.org/ SBEONLINE_TEST.html
echo SBE ONLINE version created for PROD and TEST

echo Compilation ended!
