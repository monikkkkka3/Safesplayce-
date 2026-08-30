#!/bin/bash
# Safe's Playce — schedule graphic typesetter (v3: measured-label compositing)
# Every text line is rendered as its own label image, measured, then composited
# at an exact NorthWest-anchored offset. No gravity surprises, no silent overflow.
set -e
cd "$(dirname "$0")"

BOLD=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
REG=/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf
SERIF=/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf

GOLD="#FFD166"; WHITE="#FFFFFF"; LAV="#C9B8FF"; TEAL="#8FD8C8"; CARD="#0B2230D9"
TMP=./_labels; mkdir -p "$TMP"; n=0

# place BASE X Y FONT POINTSIZE COLOR "TEXT" [LIMIT_X]
place() {
  local base=$1 x=$2 y=$3 font=$4 pt=$5 color=$6 text=$7 limit=${8:-10000}
  n=$((n+1))
  convert -background none -font "$font" -pointsize "$pt" -fill "$color" \
          "label:$text" "$TMP/l$n.png"
  local wh=$(identify -format "%wx%h" "$TMP/l$n.png")
  local w=${wh%x*}; local h=${wh#*x}
  if [ $((x + w)) -gt "$limit" ]; then
    echo "OVERFLOW: '$text' needs x+w=$((x+w)) > limit $limit" >&2; exit 1
  fi
  composite -gravity NorthWest -geometry "+$x+$y" "$TMP/l$n.png" "$base" "$base"
  echo "  '$text' $wh @ $x,$y"
}

# place_center BASE Y FONT POINTSIZE COLOR "TEXT" [MAXW]
place_center() {
  local base=$1 y=$2 font=$3 pt=$4 color=$5 text=$6 maxw=${7:-1040}
  n=$((n+1))
  convert -background none -font "$font" -pointsize "$pt" -fill "$color" \
          "label:$text" "$TMP/c$n.png"
  local wh=$(identify -format "%wx%h" "$TMP/c$n.png")
  local w=${wh%x*}; local h=${wh#*x}
  if [ "$w" -gt "$maxw" ]; then
    echo "OVERFLOW: '$text' width $w > maxw $maxw" >&2; exit 1
  fi
  local x=$(( (1080 - w) / 2 ))
  composite -gravity NorthWest -geometry "+$x+$y" "$TMP/c$n.png" "$base" "$base"
  echo "  '$text' $wh centered @ $x,$y"
}

# ================================================================ 9:16 — 1080x1920
OUT=../schedule-graphic-916.png
convert ../assets/bg-916.png -resize 1080x1920^ -gravity center -extent 1080x1920 "$OUT"

echo "9:16 header:"
place_center "$OUT" 468 "$REG"   34 "$LAV"  "LIVE ON TIKTOK  ·  @SAFESPLAYCE"
place_center "$OUT" 522 "$BOLD" 112 "$GOLD" "SAFE'S PLAYCE"
place_center "$OUT" 676 "$REG"   36 "$TEAL" "W E E K L Y   L I V E   S C H E D U L E"

echo "9:16 cards:"
# card = Y|DAY|TIME|DESC
cards916=(
"800|TUESDAY|·  7 PM CT|Bee Night — spelling bee + check-in"
"995|THURSDAY|·  7 PM CT|Game Night — word games with chat"
"1190|SATURDAY|·  3 PM CT|Saturday Playce — tournament night"
"1385|SUNDAY|·  6 PM CT|Slow Sunday — wind-down + gratitude"
)
for c in "${cards916[@]}"; do
  IFS='|' read -r cy day time desc <<< "$c"
  convert "$OUT" -fill "$CARD" -draw "roundrectangle 90,$cy 990,$((cy+165)) 34,34" "$OUT"
  place "$OUT" 140 $((cy+24)) "$BOLD" 46 "$GOLD" "$day" 520
  n=$((n+1))
  convert -background none -font "$BOLD" -pointsize 46 -fill "$GOLD" "label:$day" "$TMP/m$n.png"
  dayw=$(identify -format "%w" "$TMP/m$n.png")
  place "$OUT" $((140+dayw+34)) $((cy+36)) "$REG" 36 "$LAV" "$time" 950
  place "$OUT" 140 $((cy+100)) "$REG" 34 "$WHITE" "$desc" 950
done

echo "9:16 footer:"
place_center "$OUT" 1636 "$REG"   36 "$TEAL" "word games  ·  coping skills  ·  community"
place_center "$OUT" 1706 "$SERIF" 44 "$GOLD" "a safe playce to land"
identify "$OUT"

# ================================================================ square — 1080x1080
OUT=../schedule-graphic-square.png
convert ../assets/bg-916.png -resize 1080x1080^ -gravity center -extent 1080x1080 "$OUT"

echo "square header:"
place_center "$OUT" 78  "$REG"  28 "$LAV"  "LIVE ON TIKTOK  ·  @SAFESPLAYCE"
place_center "$OUT" 128 "$BOLD" 92 "$GOLD" "SAFE'S PLAYCE"
place_center "$OUT" 254 "$REG"  30 "$TEAL" "W E E K L Y   L I V E   S C H E D U L E"

echo "square cards:"
cardsSq=(
"336|TUESDAY|·  7 PM CT|Bee Night — spelling + check-in"
"494|THURSDAY|·  7 PM CT|Game Night — word games w/ chat"
"652|SATURDAY|·  3 PM CT|Saturday Playce — tournaments"
"810|SUNDAY|·  6 PM CT|Slow Sunday — wind-down + gratitude"
)
for c in "${cardsSq[@]}"; do
  IFS='|' read -r cy day time desc <<< "$c"
  convert "$OUT" -fill "$CARD" -draw "roundrectangle 80,$cy 1000,$((cy+140)) 28,28" "$OUT"
  place "$OUT" 120 $((cy+18)) "$BOLD" 40 "$GOLD" "$day" 470
  n=$((n+1))
  convert -background none -font "$BOLD" -pointsize 40 -fill "$GOLD" "label:$day" "$TMP/m$n.png"
  dayw=$(identify -format "%w" "$TMP/m$n.png")
  place "$OUT" $((120+dayw+26)) $((cy+28)) "$REG" 32 "$LAV" "$time" 960
  place "$OUT" 120 $((cy+86)) "$REG" 28 "$WHITE" "$desc" 960
done

echo "square footer:"
place_center "$OUT" 966 "$SERIF" 36 "$GOLD" "a safe playce to land"
identify "$OUT"

rm -rf "$TMP"
echo "DONE"
