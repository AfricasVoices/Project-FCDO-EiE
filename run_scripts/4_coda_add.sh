#!/usr/bin/env bash

set -e

if [[ $# -ne 3 ]]; then
    echo "Usage: ./4_coda_add.sh <coda-auth-file> <coda-v2-root> <data-root>"
    echo "Uploads coded messages datasets from '<data-root>/Outputs/Coda Files' to Coda"
    exit
fi

AUTH=$1
CODA_V2_ROOT=$2
DATA_ROOT=$3

./checkout_coda_v2.sh "$CODA_V2_ROOT"

DATASETS=(
    "FCDO_EiE_rqa_s10e01"
    "FCDO_EiE_rqa_s10e02"
    "FCDO_EiE_rqa_s10e02_break"
    "FCDO_EiE_rqa_s10e03"
    "FCDO_EiE_rqa_s10e04"

    "CSAP_age"
    "CSAP_gender"
    "CSAP_location"
    "CSAP_recently_displaced"
    "CSAP_children_in_school"
    "CSAP_livelihood"

    "FCDO_EiE_schools_informing_parents"
    "FCDO_EiE_issues_in_school"
    "FCDO_EiE_s10_have_voice"
    "FCDO_EiE_s10_suggestions"
)

cd "$CODA_V2_ROOT/data_tools"
git checkout "c47977d03f96ba3e97c704c967c755f0f8b666cb"  # (master which supports incremental add)

for DATASET in ${DATASETS[@]}
do
    MESSAGES_TO_ADD="$DATA_ROOT/Outputs/Coda Files/$DATASET.json"
    PREVIOUS_EXPORT="$DATA_ROOT/Coded Coda Files/$DATASET.json"

    if [ -e "$MESSAGES_TO_ADD" ]; then  # Stop-gap workaround for supporting multiple pipelines until we have a Coda library
        if [ -e "$PREVIOUS_EXPORT" ]; then
            echo "Pushing messages data to ${DATASET} (with incremental get)..."
            pipenv run python add.py --previous-export-file-path "$PREVIOUS_EXPORT" "$AUTH" "${DATASET}" messages "$MESSAGES_TO_ADD"
        else
            echo "Pushing messages data to ${DATASET} (with full download)..."
            pipenv run python add.py "$AUTH" "${DATASET}" messages "$MESSAGES_TO_ADD"
        fi
    fi
done
