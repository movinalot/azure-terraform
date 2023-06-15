#!/bin/sh

ARM_CLIENT_ID=${1}
ARM_CLIENT_SECRET=${2}
ARM_SUBSCRIPTION_ID=${3}
ARM_TENANT_ID=${4}
BASTION_HOST_RG=${5}
BASTION_HOST=${6}
BASTION_VM_RG=${7}
BASTION_VM=${8}

#eval "$(jq -r '@sh "ARM_CLIENT_ID=\(.armClientId) ARM_CLIENT_SECRET=\(.armClientSecret) ARM_TENANT_ID=\(.armTenantId) ARM_SUBSCRIPTION_ID=\(.armSubscriptionId) BASTION_HOST_RG=\(.bastionHostRg) BASTION_HOST=\(.bastionHost) BASTION_VM_RG=\(.bastionVmRg) BASTION_VM=\(.bastionVm)"')"

LOGIN=$(az login --service-principal -u ${ARM_CLIENT_ID} -p="${ARM_CLIENT_SECRET}" --tenant ${ARM_TENANT_ID})

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

az rest --method post --body "${BODY}" --uri "${BSL_URI}/createShareableLinks?api-version=${API_VER}"
sleep 10
BSL_LINK=$(az rest --method post --body "${BODY}" --uri "${BSL_URI}/getShareableLinks?api-version=${API_VER}" | jq -r '.value[].bsl')
echo $BSL_LINK

jq -n \
  --arg bsl_link ${BSL_LINK} \
  --arg bsl_user $(echo ${BASTION_HOST_RG} | cut -d'-' -f 1) \
  '{"bsl":$bsl_link, "usr":$bsl_user}'

az logout