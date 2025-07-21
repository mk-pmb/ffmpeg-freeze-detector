#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function dvfr_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  set -o pipefail
  # cd -- "$SELFPATH" || return $?
  exec </dev/null

  local VID_SRC="$1"; shift
  local DEST_VFR="$1"; shift
  local VID_FPS="$("$SELFPATH"/detect_video_frame_rate.sh "$VID_SRC")"
  [ -n "$VID_FPS" ] || return 2

  local DEST_BFN="$(basename -- "${DEST_VFR:-$VID_SRC}")"
  DEST_BFN="${DEST_BFN%.vfr}"
  DEST_BFN="${DEST_BFN%.mkv}"
  DEST_BFN="${DEST_BFN%.mp4}"

  local DEST_TMP="tmp.$DEST_BFN.$(printf '%(%y%m%d-%H%M%S)T')-$$.vfr"
  [ -n "$DEST_VFR" ] || DEST_VFR="$DEST_BFN.vfr"

  echo D: "Scan video file: $DEST_VFR <- $VID_SRC"
  local FMT_VER='250720.0' # File format version.
  ( echo fmt:"ffmpeg-freeze-detector"
    echo ver:"$FMT_VER"
    echo fps:"$VID_FPS"
    echo enc:"base64"
    echo :
    echo
    # The final blank line of the header is here because sometimes when a
    # command in a pipe has stopped reading (e.g. `sed -nre '/^:$/q;p'` or
    # `grep -xFe : -m 1 -B 9000`), the pipe won't break until the sender
    # quits or fails a write attempt. The empty line provokes the latter.
  ) >"$DEST_TMP" || return $?
  "$SELFPATH"/ffmpeg_tblend_diff_consecutive_frames.sh "$VID_SRC" |
    base64 --wrap=80 >>"$DEST_TMP" || return $?
  echo D: "Done, took $(TZ=UTC printf -- '%(%s seconds (%T))T' "$SECONDS"
    ), $(stat -c %s -- "$DEST_TMP") bytes."
  mv --no-target-directory -- "$DEST_TMP" "$DEST_VFR" || return $?
}










[ "$1" == --lib ] && return 0; dvfr_cli_init "$@"; exit $?
