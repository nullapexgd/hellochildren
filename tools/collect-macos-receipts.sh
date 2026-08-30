#!/bin/sh
set -eu

# Collect reproducible, non-destructive evidence for HELLO CHILDREN.
# Run on the Mac whose build you want to cite. No sudo is required.

stamp=$(date '+%Y%m%d-%H%M%S')
out=${1:-"receipts/local-$stamp"}
mkdir -p "$out"

printf 'Collecting receipts into %s\n' "$out"

{
    sw_vers
    printf '\n'
    uname -a
    printf '\n'
    printf 'hardware: '
    uname -m
} > "$out/system.txt"

for bin in /sbin/launchd /usr/libexec/amfid /usr/libexec/sharingd; do
    name=$(basename "$bin")
    if [ ! -e "$bin" ]; then
        printf 'missing: %s\n' "$bin" > "$out/$name.missing.txt"
        continue
    fi

    {
        printf 'path: %s\n' "$bin"
        printf 'sha256: '
        shasum -a 256 "$bin" | awk '{print $1}'
        printf '\n'
        codesign --display --verbose=4 "$bin" 2>&1 || true
    } > "$out/$name.identity.txt"

done

# Apple documents `codesign --display --entitlements - --xml` as the way to
# force XML output when entitlements are DER encoded. Keep stderr separately so
# an empty output is distinguishable from a command failure or warning.
for bin in /usr/libexec/amfid /usr/libexec/sharingd; do
    name=$(basename "$bin")
    [ -e "$bin" ] || continue

    : > "$out/$name.entitlements.xml"
    : > "$out/$name.entitlements.stderr.txt"
    codesign --display --entitlements - --xml "$bin" \
        > "$out/$name.entitlements.xml" \
        2> "$out/$name.entitlements.stderr.txt" || true

    # Also capture the default abstract representation. Newer codesign versions
    # can decode DER entitlements here even when a legacy XML-only invocation is
    # unhelpful.
    codesign --display --entitlements - "$bin" \
        > "$out/$name.entitlements.txt" \
        2>> "$out/$name.entitlements.stderr.txt" || true

done

# Locate `strings`. Command Line Tools normally provide it; xcrun is a fallback.
if command -v strings >/dev/null 2>&1; then
    STRINGS=$(command -v strings)
elif command -v xcrun >/dev/null 2>&1 && xcrun --find strings >/dev/null 2>&1; then
    STRINGS=$(xcrun --find strings)
else
    STRINGS=
fi

if [ -n "$STRINGS" ] && [ -e /sbin/launchd ]; then
    "$STRINGS" /sbin/launchd > "$out/launchd.strings.txt"

    {
        grep -F '_ThrottleInterval set to zero. You' "$out/launchd.strings.txt" || true
        grep -F 'rlimit(3)? Really?' "$out/launchd.strings.txt" || true
        grep -F "XPC bundles can't have KeepAlive" "$out/launchd.strings.txt" || true
        grep -F 'Any processes that are still running will be abandoned to the mercy of the kernel.' "$out/launchd.strings.txt" || true
    } > "$out/launchd.target-strings.txt"

    {
        grep -E 'LaunchAngel|LaunchAngels|__Angel' "$out/launchd.strings.txt" || true
        grep -F 'com.apple.private.xpc.launchd.allow-submit-launch-angels' "$out/launchd.strings.txt" || true
    } > "$out/launchd.launchangel.txt"
else
    printf 'strings tool unavailable\n' > "$out/launchd.strings-unavailable.txt"
fi

cat > "$out/README.txt" <<'TXT'
These files are raw evidence, not interpretation.

Useful files:
  system.txt
  launchd.identity.txt
  launchd.target-strings.txt
  launchd.launchangel.txt
  amfid.entitlements.xml / .txt / .stderr.txt
  sharingd.entitlements.xml / .txt / .stderr.txt

An empty entitlement output is a result worth preserving. Do not silently turn
it into "the binary has no entitlements" without checking the code-signature
format and codesign diagnostics.
TXT

printf 'Done. Archive with:\n  tar -czf %s.tar.gz %s\n' "$out" "$out"
