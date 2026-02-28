#!/bin/sh

set -e
set -o pipefail

mkdir -p /tmp/derivedData /tmp/docc

xcodebuild docbuild -scheme Renzo \
  -configuration Release \
  -derivedDataPath /tmp/derivedData \
  -destination 'platform=macOS' \
  -toolchain "swift latest" \
  -skipPackagePluginValidation \
  -skipMacroValidation;

xcrun docc merge $(find /tmp/derivedData -type d -name 'Renzo*.doccarchive') \
  --synthesized-landing-page-name Renzo \
  --synthesized-landing-page-kind SDK \
  --synthesized-landing-page-topics-style list \
  --output-path /tmp/docc/RenzoSDK.doccarchive

$(xcrun -f docc -toolchain "swift latest") process-archive \
  transform-for-static-hosting /tmp/docc/RenzoSDK.doccarchive \
  --hosting-base-path . \
  --output-path docs;

echo "<script>window.location.href += \"/documentation\"</script>" > docs/index.html;

rm -rf /tmp/derivedData /tmp/docc
