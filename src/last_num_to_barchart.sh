#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function last_num_to_barchart () {
  local BC_MAX="${BARCHART_MAX:-100}"
  local BC_SYM="${BARCHART_SYM:-[#:_]}"
  # ^-- SYM = symbols:
  #   1. left border
  #   2. full block
  #   3. half block
  #   4. empty block
  #   5. right border

  local BW=$(( ( BC_MAX + 1 ) / 2 ))
  local PAD_SP="$(printf '%*s' "$BW" '')"
  local LN= NUM= VAL=
  while IFS= read -r LN; do
    echo -n "$LN"
    NUM="${LN##*[^0-9-]}"
    [[ "$NUM" == *[0-9] ]] || NUM=
    if [ -z "$NUM" ]; then
      echo
      continue
    fi
    [ "${NUM:0:1}" == - ] && NUM=0
    [ "$NUM" -le "$BC_MAX" ] || NUM="$BC_MAX"
    (( VAL = NUM / 2 ))
    printf -v LN '%*s' "$VAL" ''
    LN="${LN// /"${BC_SYM:1:1}"}"
    [ $(( NUM % 2 )) == 0 ] || LN+="${BC_SYM:2:1}"
    VAL="${PAD_SP:${#LN}}"
    VAL="${VAL// /"${BC_SYM:3:1}"}"
    echo $'\t'"${BC_SYM:0:1}$LN$VAL${BC_SYM:4:1}"
  done
}










[ "$1" == --lib ] && return 0; last_num_to_barchart "$@"; exit $?
