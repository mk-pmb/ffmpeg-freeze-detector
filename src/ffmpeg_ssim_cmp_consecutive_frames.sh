#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ffmpeg_ssim_cmp_consecutive_frames () {
  local FCMP="[0:v]split=2[orig][delayed]"
  FCMP+=";[delayed]setpts=N+1/TB[prev]"
  FCMP+=";[orig][prev]ssim=stats_file=-"
  ffmpeg -hide_banner -loglevel info -i "$1" -filter_complex "$FCMP" \
    -f null /dev/null
  # Output format `-f null` wouldn't create a file anyway, but an output
  # filename is required to avoid `Filter ssim has an unconnected output`.
}


[ "$1" == --lib ] && return 0; ffmpeg_ssim_cmp_consecutive_frames "$@"; exit $?
