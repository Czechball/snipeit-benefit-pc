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

IMAGEMAGICK_TEMPLATE="convert -font Helvetica -fill white -pointsize 350 -gravity SouthWest -annotate +300+800 'Line1\nLine2\nLine3\nLine4' -antialias '$IMG_FILE' '$ASSET_ID-$MODEL_NAME-inzerat-foto.jpg'"

#echo $IMAGEMAGICK_TEMPLATE

print_laptop()
{
	printf "\n\n----- Informace o zařízení $ASSET_ID -----\n----------------------------------\nKategorie: $CATEGORY\nStav: $STATUS"
	printf "\n----------------------------------\n"
	printf "Výrobce:		$MANUFACTURER\nModel:			$MODEL_NAME\nProcesor:		$CPU\nPaměť:			$RAM\nDisk:			$HDD\nGrafická karta:		$GPU\nDisplej:		$SCREEN\nOperační systém:	$OS\n"
	printf "Stav baterie:		$BAT\n\n--- CENA: $PRICE Kč ---\n"

	printf "Vytváření náhledového obrázku..."

}

print_desktop()
{
	printf "\n\n----- Informace o zařízení $ASSET_ID -----\n----------------------------------\nKategorie: $CATEGORY\nStav: $STATUS"
	printf "\n----------------------------------\n"
	printf "Výrobce:		$MANUFACTURER\nModel:			$MODEL_NAME\nProcesor:		$CPU\nPaměť:			$RAM\nDisk:			$HDD\nGrafická karta:		$GPU\nOperační systém:	$OS"
	printf "\n\n--- CENA: $PRICE Kč ---\n"

	printf "Vytváření náhledového obrázku..."	
}

print_monitor()
{
	echo monito
	exit
}

if [[ $CATEGORY == "Notebooky" ]] ; then
	print_laptop
elif [[ $CATEGORY == "PC Sestavy" ]]; then
	print_desktop
elif [[ $CATEGORY == "Monitory" ]]; then
	print_monitor
fi