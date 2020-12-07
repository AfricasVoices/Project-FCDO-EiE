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

    "CSAP_age"
    "CSAP_gender"
    "CSAP_location"
    "CSAP_recently_displaced"
    "CSAP_children_in_school"
    "CSAP_livelihood"
)

cd "$CODA_V2_ROOT/data_tools"
git checkout "f97d0865c3ffa1d36e94b6fc4bb740bf3b3af66c"  # (master which supports add_messages_content_batch)

for DATASET in ${DATASETS[@]}
do
    FILE="$DATA_ROOT/Outputs/Coda Files/$DATASET.json"

    if [ -e "$FILE" ]; then  # Stop-gap workaround for supporting multiple pipelines until we have a Coda library
        echo "Pushing messages data to ${DATASET}..."
        pipenv run python add.py "$AUTH" "${DATASET}" messages "$FILE"
    fi
done