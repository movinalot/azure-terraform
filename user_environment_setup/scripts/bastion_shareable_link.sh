#!/bin/sh

DEBUG=0 # use 1 for DEBUG output

OUTPUT="${2:-csv}"
INPUT="${1:-../default_credentials.csv}"

OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read -r USERNAME PASSWORD BASTION_HOST_RG BASTION_HOST BASTION_VM ARM_CLIENT_ID ARM_CLIENT_SECRET ARM_SUBSCRIPTION_ID ARM_TENANT_ID
do
  # Remove double quotes
  ARM_CLIENT_ID=${ARM_CLIENT_ID%\"}; ARM_CLIENT_ID=${ARM_CLIENT_ID#\"}

  ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET%\"}; ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET#\"}

  ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID%\"}; ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID#\"}

  ARM_TENANT_ID=${ARM_TENANT_ID%\"}; ARM_TENANT_ID=${ARM_TENANT_ID#\"}

  BASTION_HOST_RG=${BASTION_HOST_RG%\"}; BASTION_HOST_RG=${BASTION_HOST_RG#\"}

  BASTION_HOST=${BASTION_HOST%\"}; BASTION_HOST=${BASTION_HOST#\"}

  BASTION_VM_RG=$BASTION_HOST_RG

  BASTION_VM=${BASTION_VM%\"}; BASTION_VM=${BASTION_VM#\"}

  LOGIN=$(az login --service-principal -u "${ARM_CLIENT_ID}" -p="${ARM_CLIENT_SECRET}" --tenant "${ARM_TENANT_ID}")

  if [ "${DEBUG}" -eq 1 ]
  then
    echo "${USERNAME}" "${PASSWORD}" "${ARM_CLIENT_ID}" "${ARM_CLIENT_SECRET}" "${ARM_SUBSCRIPTION_ID}" "${ARM_TENANT_ID}" "${BASTION_HOST_RG}" "${BASTION_HOST}" "${BASTION_VM_RG}" "${BASTION_VM}"
    echo "${LOGIN}"
  fi

  BODY=$(cat <<EOF
  {
    "vms": [
      { "vm": {
        "id": "/subscriptions/${ARM_SUBSCRIPTION_ID}/resourceGroups/${BASTION_VM_RG}/providers/Microsoft.Compute/virtualMachines/${BASTION_VM}"
        }
      }
    ]
  }
EOF
)

  BSL_URI="https://management.azure.com/subscriptions/${ARM_SUBSCRIPTION_ID}/resourceGroups/${BASTION_HOST_RG}/providers/Microsoft.Network/bastionHosts/${BASTION_HOST}"
  API_VER="2022-11-01"

  az rest --method post --headers "Content-Type=application/json"  --body "${BODY}" --uri "${BSL_URI}/createShareableLinks?api-version=${API_VER}"
  sleep 5
  BSL_LINK=$(az rest --method post --headers "Content-Type=application/json" --body "${BODY}" --uri "${BSL_URI}/getShareableLinks?api-version=${API_VER}" | jq -r '.value[].bsl')

  if [ "${OUTPUT}" == "csv" ]
  then
    echo "${USERNAME},${PASSWORD},\"${BASTION_VM}\",\"${BSL_LINK}\""
  fi

  if [ "${OUTPUT}" == "json" ]
  then
    jq -n \
      --arg bsl_link "${BSL_LINK}" \
      --arg bsl_vm_name "${BASTION_VM}" \
      --arg bsl_user "$(echo "${BASTION_HOST_RG}" | cut -d'-' -f 1)" \
      '{ "user":$bsl_user, "name":$bsl_vm_name, "link":$bsl_link }'
  fi

  az logout

done < $INPUT
IFS=$OLDIFS