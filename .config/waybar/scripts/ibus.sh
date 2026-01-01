#!/bin/bash

# Get current Fcitx5 engine
engine=$(fcitx5-remote -n)

# Show short labels
case "$engine" in
    m17n:hi:phonetic )     label="HI-PH";;
    m17n:hi:inscript )     label="HI-IN";;
    m17n:hi:inscript2 )    label="HI-I2";;
    m17n:hi:remington )    label="HI-RE";;
    m17n:hi:typewriter )   label="HI-TW";;
    m17n:hi:itrans )       label="HI-IT";;
    xkb:in:hin-kagapa:* )  label="KAGAPA";;
    mozc )                 label="JP-MZ";;
    m17n_hi_itrans )       label="HI-IT";;
    m17n_sa_itrans )       label="SA-IT";;
    * )                    label="EN";;
esac

# Output in JSON format
echo "{\"text\": \"$label\"}"

