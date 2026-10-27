#!/usr/bin/env bash
# Put the latest iKubb on your own iPhone and iPad.
#
#   tool/ios.sh                  pull, build once, install on every connected
#                                iPhone/iPad (cable or wireless)
#   tool/ios.sh --device NAME    only that device (name or id, prefix is fine)
#   tool/ios.sh --no-pull        build what is checked out, skip git pull
#   tool/ios.sh --dev [NAME]     debug run with hot reload on one device
#                                (r = reload, R = restart, q = quit)
#
# Needs a Mac with Xcode, Flutter 3.47.7 and signing set up once in Xcode.
# See docs/IOS_DEVICE_TESTING.md. Written for the macOS default bash 3.2.
set -euo pipefail

cd "$(dirname "$0")/.."

# Feedback backend. The publishable key is public by design (it ships in
# every build; RLS limits it to inserting feedback), same as the web build.
SUPABASE_URL="https://cebkosufhtkddecfroij.supabase.co"
SUPABASE_ANON_KEY="sb_publishable_qaavkaafBNirBzeW9k3toA_FOi_Dx-d"

pull=1
dev=0
device=""
while [ $# -gt 0 ]; do
  case "$1" in
    --no-pull) pull=0 ;;
    --dev) dev=1 ;;
    --device|-d) shift; device="${1:-}" ;;
    -h|--help) sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) echo "Unknown option: $1 (see tool/ios.sh --help)" >&2; exit 2 ;;
    *) device="$1" ;;
  esac
  shift
done

say() { printf '\n\033[1m%s\033[0m\n' "$*"; }
fail() { printf '\n\033[31m%s\033[0m\n' "$*" >&2; exit 1; }

command -v flutter >/dev/null || fail "flutter is not on your PATH. See docs/IOS_DEVICE_TESTING.md, step 3."

branch="$(git rev-parse --abbrev-ref HEAD)"
say "Branch: $branch"

if [ "$pull" -eq 1 ]; then
  before="$(git rev-parse HEAD)"
  # --autostash keeps local Xcode tweaks (such as your signing team in
  # project.pbxproj) across the pull.
  git pull --ff-only --autostash || fail "git pull failed. Run 'git status' and paste the output in the chat."
  if [ "$before" = "$(git rev-parse HEAD)" ]; then
    echo "Already up to date."
  else
    say "New since your last build:"
    git --no-pager log --oneline "$before..HEAD"
  fi
fi

flutter pub get >/dev/null

# "0.2.0+2" in pubspec.yaml reads as "0.2.0 (2)", as in Settings.
version="$(sed -n 's/^version: *\([^+]*\)+\(.*\)$/\1 (\2)/p' pubspec.yaml)"
sha="$(git rev-parse --short HEAD)"
# Local edits other than the signing team mark the build with a "+", so a
# build that is not exactly a pushed commit is never mistaken for one.
if [ -n "$(git status --porcelain -- . ':!ios/Runner.xcodeproj/project.pbxproj')" ]; then
  sha="$sha+"
fi
defines=(
  "--dart-define=SUPABASE_URL=$SUPABASE_URL"
  "--dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY"
  "--dart-define=GIT_SHA=$sha"
)

if [ "$dev" -eq 1 ]; then
  say "Debug run of $version, commit $sha, with hot reload"
  if [ -n "$device" ]; then
    exec flutter run --debug -d "$device" "${defines[@]}"
  fi
  exec flutter run --debug "${defines[@]}"
fi

# Connected physical iPhones and iPads (simulators cannot run release builds).
devices="$(flutter devices --machine 2>/dev/null | /usr/bin/python3 -c '
import json, sys
raw = sys.stdin.read()
for d in json.loads(raw[raw.find("["):] or "[]"):
    if d.get("targetPlatform") == "ios" and not d.get("emulator") and d.get("isSupported"):
        print(d["id"] + "\t" + d["name"])
')"

if [ -n "$device" ]; then
  devices="$(printf '%s\n' "$devices" | grep -i -- "$device" || true)"
  [ -n "$devices" ] || fail "No connected iPhone or iPad matches '$device'. Run 'flutter devices' to see the names."
fi
[ -n "$devices" ] || fail "No iPhone or iPad found. Connect one by cable, unlock it and tap Trust; or pair it for wireless in Xcode (Window > Devices and Simulators)."

say "Building iKubb $version, commit $sha for iOS"
flutter build ios --release "${defines[@]}"

installed=""
while IFS="$(printf '\t')" read -r id name; do
  [ -n "$id" ] || continue
  say "Installing on $name"
  # </dev/null: flutter must not read the device list this loop consumes.
  if flutter install --release -d "$id" </dev/null; then
    installed="$installed
  - $name"
  else
    echo "Install on $name failed; is it unlocked and in Developer Mode?" >&2
  fi
done <<< "$devices"

[ -n "$installed" ] || fail "Nothing was installed."
say "Installed iKubb $version, commit $sha on:$installed"
echo "Check Settings > bottom of the screen on the device: it shows the same version and commit."
