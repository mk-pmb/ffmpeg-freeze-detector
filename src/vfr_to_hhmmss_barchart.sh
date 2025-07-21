#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function vfr_to_hhmmss_barchart () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  # cd -- "$SELFPATH" || return $?

  local VAL= FX=,
  while [ "${1:0:1}" == - ]; do
    VAL="$1"; shift
    case "$VAL" in
      -- ) break;;
      --durations | \
      -- ) FX+="${VAL#--},";;
      * ) echo E: $FUNCNAME: "Unsupported CLI argument: $VAL" >&2; return 2;;
    esac
  done

  [ "$#" == 0 ] || return 4$(
    echo E: $FUNCNAME: "Unsupported CLI argument: $1" >&2)

  local -A META=()
  while IFS= read -r VAL; do case "$VAL" in
    : ) break;;
    '#'* ) ;;
    [A-Za-z]*:* ) META["${VAL%%:*}"]="${VAL#*:}";;
    * ) echo E: "unexpected input line: $VAL" >&2; return 6;;
  esac; done

  VAL="${META[enc]}"
  case "$VAL" in
    '' ) ;;
    base64 ) exec < <( "$VAL" --decode );;
    * ) echo E: "unsupported encoding: $VAL" >&2; return 6;;
  esac

  if [[ "$FX" == *,durations,* ]]; then
    VAL='
      s~^(\S+)\s+([0-9]+)\s+([0-9].*)$~\3\t\2\t\1~
      1s~^\S+\s+1\s+(#.*)$~\1\tframes\tduration~
      '
    exec > >(uniq --skip-fields=2 --count |
      FIRST_FRAME_NUM=0 "$SELFPATH"/frame_num_to_hhmmss.sh "${META[fps]}" |
      sed -rf <(echo "$VAL") )
  fi

  VAL='# timestamp:pixel_heat:thermometer'
  echo "${VAL//:/$'\t'}"
  od --address-radix=n --format=u1 --width=1 --output-duplicates |
  nl --body-numbering=all --number-width=1 | tr -s '\t ' ' ' |
  "$SELFPATH"/frame_num_to_hhmmss.sh "${META[fps]}" |
  sed -nre 's~^([0-9:.]+)\s+[0-9]+\s+([0-9]+)$~\1\t\2~p' |
  BARCHART_MAX=40 "$SELFPATH"/last_num_to_barchart.sh
  exec >&-
  wait # For all child processes to finish writing their output.
}










vfr_to_hhmmss_barchart "$@"; exit $?
