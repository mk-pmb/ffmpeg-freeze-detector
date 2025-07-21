#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function detect_video_frame_rate () {
  local VID_SRC="$1"; shift
  local FPS="$(
  ffprobe -hide_banner -loglevel warning -i "$VID_SRC" \
    -select_streams v:0 -print_format compact=escape=none -show_streams |
    grep -oPe '\|r_frame_rate=[^|]+')"
  # ^-- r_frame_rate = recommended (i.e., nominal) frame rate
  #     avg_frame_rate = actual frame rate
  FPS="${FPS#*=}"
  FPS="${FPS%/1}"
  case "${#FPS}:${FPS//[0-9]/}" in
    [1-4]: ) echo "$FPS";;
    * )
      echo E: "Expected an integer frame rate with few digits, not '$FPS'" >&2
      return 4;;
  esac
}


[ "$1" == --lib ] && return 0; detect_video_frame_rate "$@"; exit $?
