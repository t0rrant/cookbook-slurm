#!/usr/bin/env bash
# Copyright (c) Simão Martins and Manuel Torrinha, 2019
SECRET="../secrets/encrypted_data_bag_secret"
for ITEM_PATH in $(find -iname *.unencrypted.json| sed 's/\.unencrypted\.json//'); do
    BAG_NAME=$(uuidgen -r)
    ITEM_NAME=$(basename ${ITEM_PATH})
    knife data bag create ${BAG_NAME}
    knife data bag from file ${BAG_NAME} ${ITEM_PATH}.unencrypted.json --secret-file ${SECRET}
    knife data bag show ${BAG_NAME} ${ITEM_NAME} -Fj > ${ITEM_PATH}.json
    knife data bag delete ${BAG_NAME} -yes
done
