#!/bin/bash

TOKEN=$(cat token.txt)
BASE_URL='https://snipeit.lambdaposting.games/api/v1'
HEADER1='accept: application/json'
HEADER2="authorization: Bearer $TOKEN"
HEADER3='content-type: application/json'

ASSET_ID="$1"

printf "Získávání informací o ID $ASSET_ID..."

JSON_INPUT=$(curl -s --request GET --url "$BASE_URL/hardware/$ASSET_ID" --header "$HEADER1" --header "$HEADER2" --header "$HEADER3")

CATEGORY=$(echo $JSON_INPUT | jq -r .category.name)
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

printf "\n\n----- Informace o zařízení $ASSET_ID -----\n----------------------------------\nKategorie: $CATEGORY\nStav: $STATUS"
printf "\n----------------------------------\n"
printf "Výrobce:		$MANUFACTURER\nModel:			$MODEL_NAME\nProcesor:		$CPU\nPaměť:			$RAM\nDisk:			$HDD\nGrafická karta:		$GPU\nDisplej:		$SCREEN\nOperační systém:	$OS\n"
printf "Stav baterie:		$BAT\n\n--- CENA: $PRICE Kč ---\n"