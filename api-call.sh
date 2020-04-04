#!/bin/bash

TOKEN=$(cat token.txt)
BASE_URL='https://snipeit.lambdaposting.games/api/v1'
HEADER1='accept: application/json'
HEADER2="authorization: Bearer $TOKEN"
HEADER3='content-type: application/json'

ASSET_ID="$1"
IMG_FILE="$2"

re='^[0-9]+$'
if ! [[ $ASSET_ID =~ $re ]]; then
	echo "Chyba, nebylo vloženo správné ID..."
	exit
fi
if [[ $IMG_FILE == "" ]]; then
	echo "Chyba, nebyl zadán žádný obrázkový soubor..."
	exit
fi

printf "Získávání informací o ID $ASSET_ID..."

JSON_INPUT=$(curl -s --request GET --url "$BASE_URL/hardware/$ASSET_ID" --header "$HEADER1" --header "$HEADER2" --header "$HEADER3")

CATEGORY=$(echo $JSON_INPUT | jq -r .category.name)

if [[ $CATEGORY == "null" ]]; then
	echo
	echo "Předmět $ASSET_ID neexistuje"
	exit
fi

STATUS=$(echo $JSON_INPUT | jq -r .status_label.name)
MANUFACTURER=$(echo $JSON_INPUT | jq -r .manufacturer.name)
MODEL_NAME=$(echo $JSON_INPUT | jq -r .model.name)
CPU=$(echo $JSON_INPUT | jq -r .custom_fields.CPU.value)
RAM=$(echo $JSON_INPUT | jq -r .custom_fields.RAM.value)
HDD=$(echo $JSON_INPUT | jq -r .custom_fields.Disk.value)
GPU=$(echo $JSON_INPUT | jq -r .custom_fields.GPU.value)
BAT=$(echo $JSON_INPUT | jq -r .custom_fields.Baterie.value)
SCREEN=$(echo $JSON_INPUT | jq -r .custom_fields.Displej.value)
OS=$(echo $JSON_INPUT | jq -r '.custom_fields."Operační systém".value')
PRICE=$(echo $JSON_INPUT | jq -r '.custom_fields."Prodejní cena".value')
#echo $JSON_INPUT | jq -r .custom_fields.

#echo $IMAGEMAGICK_TEMPLATE

FONT="Helvetica"
FILL="white"
GRAVITY="NorthWest"
POINTSIZE="150"
OFFSETX="+200"
OFFSETY="+200"

print_laptop()
{
	printf "\n\n----- Informace o zařízení $ASSET_ID -----\n----------------------------------\nKategorie: $CATEGORY\nStav: $STATUS"
	printf "\n----------------------------------\n"
	printf "Výrobce:		$MANUFACTURER\nModel:			$MODEL_NAME\nProcesor:		$CPU\nPaměť:			$RAM\nDisk:			$HDD\nGrafická karta:		$GPU\nDisplej:		$SCREEN\nOperační systém:	$OS\n"
	printf "Stav baterie:		$BAT\n\n--- CENA: $PRICE Kč ---\n"

	printf "Vytváření náhledového obrázku..."

	convert -font $FONT -fill $FILL -pointsize $POINTSIZE -gravity $GRAVITY -annotate $OFFSETX$OFFSETY "$MANUFACTURER $MODEL_NAME\n$CPU\n$RAM\n$HDD\n$SCREEN\nBaterie: $BAT\n$OS" -antialias $IMG_FILE $ASSET_ID-inzerat-foto.jpg
	convert -font $FONT -fill $FILL -pointsize 400 -gravity SouthEast -annotate +116+87 "$PRICE Kč" -antialias $ASSET_ID-inzerat-foto.jpg $ASSET_ID-inzerat-foto.jpg

	printf " hotovo.\n"
}

print_desktop()
{
	printf "\n\n----- Informace o zařízení $ASSET_ID -----\n----------------------------------\nKategorie: $CATEGORY\nStav: $STATUS"
	printf "\n----------------------------------\n"
	printf "Výrobce:		$MANUFACTURER\nModel:			$MODEL_NAME\nProcesor:		$CPU\nPaměť:			$RAM\nDisk:			$HDD\nGrafická karta:		$GPU\nOperační systém:	$OS"
	printf "\n\n--- CENA: $PRICE Kč ---\n"

	printf "Vytváření náhledového obrázku..."

	convert -font $FONT -fill $FILL -pointsize $POINTSIZE -gravity $GRAVITY -annotate $OFFSETX$OFFSETY "$MANUFACTURER $MODEL_NAME\n$CPU\n$RAM\n$HDD\n$OS" -antialias $IMG_FILE $ASSET_ID-inzerat-foto.jpg
	convert -font $FONT -fill $FILL -pointsize 400 -gravity SouthEast -annotate +116+87 "$PRICE Kč" -antialias $ASSET_ID-inzerat-foto.jpg $ASSET_ID-inzerat-foto.jpg

	printf " hotovo. \n"
}

print_monitor()
{
	echo monitor
	exit
}

if [[ $CATEGORY == "Notebooky" ]] ; then
	print_laptop
elif [[ $CATEGORY == "PC Sestavy" ]]; then
	print_desktop
elif [[ $CATEGORY == "Monitory" ]]; then
	print_monitor
fi