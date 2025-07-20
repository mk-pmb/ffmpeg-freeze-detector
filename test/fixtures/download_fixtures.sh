#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function download_fixtures_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?

  local MD= URL= RANGE= DEST= DL_TMP=
  local WGET_OPT=()
  for MD in *.md; do
    for URL in video-fixture-mirror video-mp4-smallest; do
      URL="$(grep -m 1 -Fe " [$URL]: https://" -- "$MD")"
      [ -z "$URL" ] || break
    done
    [ -n "$URL" ] || continue
    DEST="${MD%.md}"
    URL="${URL##*: }"
    RANGE="${URL##*'#bytes='}"
    [ "${#RANGE}" -lt "${#URL}" ] || RANGE=
    RANGE="${RANGE//[^0-9-]/}"
    URL="${URL%%'#'*}"
    DEST="${DEST%.md}"
    DEST+='.mp4'
    echo -n "D: fixture: $DEST"
    if [ -s "$DEST" ]; then echo ': have.'; continue; fi
    echo -n ' <'
    [ -z "$RANGE" ] || echo -n "--{ range: $RANGE }"
    DL_TMP="tmp.dl-$$.$(basename -- "$DEST").part"
    rm -- "$DL_TMP" 2>/dev/null
    WGET_OPT=(
      --output-document="$DL_TMP"
      # --verbose
      )
    [ -z "$RANGE" ] || WGET_OPT+=( --header="Range: $RANGE" )
    wget "${WGET_OPT[@]}" -- "$URL" || return $?
    mv --verbose --no-target-directory -- "$DL_TMP" "$DEST" || return $?
  done
}










download_fixtures_cli_init "$@"; exit $?
