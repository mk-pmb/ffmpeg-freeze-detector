#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function frame_num_to_hhmmss () {
  local FPS="$1"; shift
  [ "${FPS:-0}" -ge 1 -a "${FPS:-0}" -le 100 ] ||
    echo W: "Expected frame rate to be in range 1..100 fps!" >&2
  [ -n "$FRAME_NUM_RGX" ] || local FRAME_NUM_RGX='^[ \t]*([0-9]+)[ \t]'
  local SEC_PER_DAY=86400
  local LN= VAL='bad_fps' MSEC=0 SEC=0
  while IFS= read -r LN; do
    if [[ ! "$LN" =~ $FRAME_NUM_RGX ]]; then
      echo "? $LN"
      continue
    fi
    if [ -n "$FPS" ]; then
      VAL="${BASH_REMATCH[1]}"
      (( MSEC = ( ( VAL - 1 ) * 1000 ) / FPS ))
      printf -v MSEC -- '%04d' "$MSEC"
      SEC="${MSEC%???}"
      MSEC="${MSEC:${#SEC}}"
      TZ=UTC printf -v VAL -- '%(%T)T.%s' "$SEC" "$MSEC"
      [ "$SEC" -lt "$SEC_PER_DAY" ] || VAL="$(( SEC / 3600 ))${VAL:2}"
    fi
    echo "$VAL"$'\t'"$LN"
  done
}










[ "$1" == --lib ] && return 0; frame_num_to_hhmmss "$@"; exit $?
