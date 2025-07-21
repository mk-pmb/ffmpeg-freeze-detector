#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ffmpeg_tblend_diff_consecutive_frames () {
  local VID_SRC="${1:--}"

  local GRAY_VIDEO_CODEC=()
  # ^-- What codec to use internally inside the filter graph.
  # Since our output format is rawvideo, ffmpeg would usually try to use
  # that for the internal processing as well, as if we had given:
  # GRAY_VIDEO_CODEC=( -c:v rawvideo )
  # However, there seeoms to be absolutely no way to quell rawvideo's warning
  # "The bitrate parameter is set too low. It takes bits/s as argument, not kbits/s"
  # It does not care about -b:v at all, and with -minrate, even if we give
  # the maximum allowed value (INT32_MAX = 2**31 - 1 = 2147483647), it will
  # still complain "is set too low". (Options -nostats has no effect either.)
  # The only solution I found is to use a lossless codec internally:
  # GRAY_VIDEO_CODEC=( -c:v libx264 )
  # … but that produces more than one byte per frame, so apparently it
  # overwrites our `-f rawvideo` option.
  # Maybe ffmpeg's own codec?
  # GRAY_VIDEO_CODEC=( -c:v ffv1 )
  # Nope, again overrides -f and produces more than 1 byte per frame.

  local GRAY_PIXEL_FMT='gray'
  # However, using libx264, swscaler doesn't like "gray" pixels anymore:
  # "[swscaler @ …] deprecated pixel format used, make sure you did set range correctly"
  # If we set `-pix_fmt gray`, we get "Incompatible pixel format 'gray'
  # for codec 'libx264', auto-selecting format 'yuvj444p'" so let's try that:
  # GRAY_PIXEL_FMT='yuvj444p' # triggers the swscaler warning again.
  # GRAY_PIXEL_FMT='yuv420p' # [libx264 @ …] width not divisible by 2 (1x1)

  # Since all above attempts to quell the useless warning didn't help,
  # it's time to resort to censorship:
  local SED_MUTE_BITRATE_WARNING='/bitrate parameter is set too low/d'

  local FFDIFF="tblend=all_mode=difference,format=gray"
  FFDIFF+=",histeq=strength=1:intensity=1,format=gray"
  FFDIFF+=",scale=w=1:h=1:flags=lanczos,format=$GRAY_PIXEL_FMT"

  local FFOPT=(
    -hide_banner
    -loglevel warning
    -i "$VID_SRC"
    -an # Discard any audio
    "${GRAY_VIDEO_CODEC[@]}"
    -vf "$FFDIFF"
    -aspect 1 # suppress the "invalid SAR" warning

    # Even if we had used `-c:v rawvideo`, we still need -f to avoid
    # the error "Unable to find a suitable output format for 'pipe:'".
    -f rawvideo
    )
  ffmpeg "${FFOPT[@]}" - 2> >( sed -ure "$SED_MUTE_BITRATE_WARNING" >&2 )
}










[ "$1" == --lib ] && return 0; ffmpeg_tblend_diff_consecutive_frames "$@"; exit $?
