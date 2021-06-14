#!/bin/bash

[[ -n "${DEBUG:+true}" ]] && set -vx

#colors for terminal
boldreduscore="\e[1;4;31m"
boldred="\e[1;31m"
cyan="\e[1;36m"
resetformatting="\e[0m"

#External helper functions
#. "$(dirname "${BASH_SOURCE[0]}")/deploy_utils.sh"
full_script_path="$(realpath "${BASH_SOURCE[0]}")"
script_directory="$(dirname "${full_script_path}")"

#call stack has full scriptname when using source 
source "${script_directory}/deploy_utils.sh"

function showhelp {
    echo ""
    echo "#########################################################################################"
    echo "#                                                                                       #"
    echo "#                                                                                       #"
    echo "#   This file contains the logic to deploy the workload infrastructure to Azure         #"
    echo "#                                                                                       #"
    echo "#   The script experts the following exports:                                           #"
    echo "#                                                                                       #"
    echo "#     DEPLOYMENT_REPO_PATH the path to the folder containing the cloned sap-hana repo   #"
    echo "#                                                                                       #"
    echo "#   The script is to be run from the folder containing the json parameter file          #"
    echo "#                                                                                       #"
    echo "#   The script will persist the parameters needed between the executions in the         #"
    echo "#   ~/.sap_deployment_automation folder                                                 #"
    echo "#                                                                                       #"
    echo "#   Usage: install_workloadzone.sh                                                      #"
    echo "#      -p or --parameterfile                deployer parameter file                    #"
    echo "#                                                                                       #"
    echo "#   Optional parameters                                                                 #"
    echo "#      -d or --deployer_tfstate_key          Deployer terraform state file name         #"
    echo "#      -e or --deployer_environment          Deployer environment, i.e. MGMT            #"
    echo "#      -s or --subscription                  subscription                               #"
    echo "#      -s or --subscription                  subscription                               #"
    echo "#      -c or --spn_id                        SPN application id                         #"
    echo "#      -p or --spn_secret                    SPN password                               #"
    echo "#      -t or --tenant_id                     SPN Tenant id                              #"
    echo "#      -f or --force                         Clean up the local Terraform files.        #"
    echo "#      -i or --auto-approve                  Silent install                             #"
    echo "#      -h or --help                          Help                                       #"
    echo "#                                                                                       #"
    echo "#   Example:                                                                            #"
    echo "#                                                                                       #"
    echo "#   [REPO-ROOT]deploy/scripts/install_workloadzone.sh \                                 #"
    echo "#      --parameterfile PROD-WEEU-SAP01-INFRASTRUCTURE                                  #"
    echo "#                                                                                       #"
    echo "#   Example:                                                                            #"
    echo "#                                                                                       #"
    echo "#   [REPO-ROOT]deploy/scripts/install_workloadzone.sh \                                 #"
    echo "#      --parameterfile PROD-WEEU-SAP01-INFRASTRUCTURE \                                #"
    echo "#      --deployer_environment MGMT \                                                    #"
    echo "#      --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \                            #"
    echo "#      --spn_id yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy \                                  #"
    echo "#      --spn_secret ************************ \                                          #"
    echo "#      --spn_secret yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy \                              #"
    echo "#      --tenant_id zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz \                               #"
    echo "#      --auto-approve                                                                   #"  
    echo "#########################################################################################"
}

function missing {
    printf -v val %-.40s "$option"
    echo ""
    echo ""
    echo "#########################################################################################"
    echo "#                                                                                       #"
    echo "#   Missing environment variables: ${option}!!!              #"
    echo "#                                                                                       #"
    echo "#   Please export the folloing variables:                                               #"
    echo "#      DEPLOYMENT_REPO_PATH (path to the repo folder (sap-hana))                        #"
    echo "#                                                                                       #"
    echo "#   Usage: install_workloadzone.sh                                                      #"
    echo "#      -p or --parameterfile                deployer parameter file                    #"
    echo "#                                                                                       #"
    echo "#   Optional parameters                                                                 #"
    echo "#      -d or deployer_tfstate_key            Deployer terraform state file name         #"
    echo "#      -e or deployer_environment            Deployer environment, i.e. MGMT            #"
    echo "#      -k or --state_subscription            subscription of keyvault with SPN details  #"
    echo "#      -v or --vault                         Name of Azure keyvault with SPN details    #"
    echo "#      -s or --subscription                  subscription                               #"
    echo "#      -c or --spn_id                        SPN application id                         #"
    echo "#      -o or --storageaccountname            Storage account for terraform state files  #"
    echo "#      -p or --spn_secret                    SPN password                               #"
    echo "#      -t or --tenant_id                     SPN Tenant id                              #"
    echo "#      -f or --force                         Clean up the local Terraform files.        #"
    echo "#      -i or --auto-approve                  Silent install                             #"
    echo "#      -h or --help                          Help                                       #"
    echo "#########################################################################################"
}

show_help=false
force=0
INPUT_ARGUMENTS=$(getopt -n install_workloadzone -o p:d:e:k:o:s:c:p:t:a:v:ifh --longoptions parameterfile:,deployer_tfstate_key:,deployer_environment:,subscription:,spn_id:,spn_secret:,tenant_id:,state_subscription:,vault:,storageaccountname:,auto-approve,force,help -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  showhelp
fi

eval set -- "$INPUT_ARGUMENTS"
while :
do
  case "$1" in
    -p | --parameterfile)                     parameterfile="$2"               ; shift 2 ;;
    -d | --deployer_tfstate_key)               deployer_tfstate_key="$2"        ; shift 2 ;;
    -e | --deployer_environment)               deployer_environment="$2"        ; shift 2 ;;
    -k | --state_subscription)                 STATE_SUBSCRIPTION="$2"          ; shift 2 ;;
    -o | --storageaccountname)                 REMOTE_STATE_SA="$2"             ; shift 2 ;;
    -s | --subscription)                       subscription="$2"                ; shift 2 ;;
    -c | --spn_id)                             client_id="$2"                   ; shift 2 ;;
    -v | --vault)                              keyvault="$2"                    ; shift 2 ;;
    -p | --spn_secret)                         spn_secret="$2"                  ; shift 2 ;;
    -t | --tenant_id)                          tenant_id="$2"                   ; shift 2 ;;
    -f | --force)                              force=1                          ; shift ;;
    -i | --auto-approve)                       approve="--auto-approve"         ; shift ;;
    -h | --help)                               showhelp 
                                               exit 3                           ; shift ;;
    --) shift; break ;;
  esac
done
tfstate_resource_id=""
tfstate_parameter=""

deployer_tfstate_key_parameter=""
deployer_tfstate_key_exists=false
landscape_tfstate_key=""
landscape_tfstate_key_parameter=""
landscape_tfstate_key_exists=false

deployment_system=sap_landscape

workload_dirname=$(dirname "${parameterfile}")
workload_file_parametername=$(basename "${parameterfile}")

param_dirname=$(dirname "${parameterfile}")

if [ $param_dirname != '.' ]; then
    echo ""
    echo "#########################################################################################"
    echo "#                                                                                       #"
    echo "#   Please run this command from the folder containing the parameter file               #"
    echo "#                                                                                       #"
    echo "#########################################################################################"
    exit 3
fi

if [ ! -f "${workload_file_parametername}" ]
then
    printf -v val %-40.40s "$workload_file_parametername"
    echo ""
    echo "#########################################################################################"
    echo "#                                                                                       #"
    echo -e "#                 $boldreduscore Parameter file does not exist: ${val}$resetformatting #"
    echo "#                                                                                       #"
    echo "#########################################################################################"
    exit
fi


# Read environment
environment=$(jq --raw-output .infrastructure.environment "${parameterfile}")
region=$(jq --raw-output .infrastructure.region "${parameterfile}")
key=$(echo "${workload_file_parametername}" | cut -d. -f1)

if [ ! -n "${environment}" ]
then
    echo "#########################################################################################"
    echo "#                                                                                       #"
    echo -e "#                          $boldreduscore Incorrect parameter file. $resetformatting                                  #"
    echo "#                                                                                       #"
    echo "#     The file needs to contain the infrastructure.environment attribute!!              #"
    echo "#                                                                                       #"
    echo "#########################################################################################"
    echo ""
    exit -1
fi

if [ ! -n "${region}" ]
then
    echo "#########################################################################################"
    echo "#                                                                                       #"
    echo -e "#                          $boldreduscore Incorrect parameter file. $resetformatting                                  #"
    echo "#                                                                                       #"
    echo "#       The file needs to contain the infrastructure.region attribute!!                 #"
    echo "#                                                                                       #"
    echo "#########################################################################################"
    echo ""
    exit -1
fi

#Persisting the parameters across executions

automation_config_directory=~/.sap_deployment_automation/
generic_config_information="${automation_config_directory}"config
workload_config_information="${automation_config_directory}""${environment}""${region}"

if [ "${force}" == 1 ]
then
    if [ -f $workload_config_information ]
    then
        rm $workload_config_information
    fi
    if [ -d ./.terraform/ ]; then
        rm .terraform -r
    fi
    
    if [ -f terraform.tfstate ]; then
        rm terraform.tfstate
    fi
    
    if [ -f terraform.tfstate.backup ]; then
        rm terraform.tfstate.backup
    fi
    
fi

#Plugins
if [ ! -d "$HOME/.terraform.d/plugin-cache" ]
then
    mkdir "$HOME/.terraform.d/plugin-cache"
fi
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"


init "${automation_config_directory}" "${generic_config_information}" "${workload_config_information}"

param_dirname=$(pwd)
export TF_DATA_DIR="${param_dirname}/.terraform"
var_file="${param_dirname}"/"${parameterfile}"

if [ ! -z "$subscription" ]
then
    save_config_var "subscription" "${workload_config_information}"
fi

if [ ! -z "$STATE_SUBSCRIPTION" ]
then
    echo "Saving the state subscription"
    save_config_var "STATE_SUBSCRIPTION" "${workload_config_information}"
fi

if [ ! -z "$client_id" ]
then
    save_config_var "client_id" "${workload_config_information}"
fi

if [ ! -z "$keyvault" ]
then
    save_config_var "keyvault" "${workload_config_information}"
fi

if [ ! -z "$tenant_id" ]
then
    save_config_var "tenant_id" "${workload_config_information}"
fi

if [ ! -z "$REMOTE_STATE_SA" ]
then
    save_config_var "REMOTE_STATE_SA" "${workload_config_information}"
fi


load_config_vars "${workload_config_information}" "REMOTE_STATE_SA"
load_config_vars "${workload_config_information}" "REMOTE_STATE_RG"
load_config_vars "${workload_config_information}" "tfstate_resource_id"
load_config_vars "${workload_config_information}" "STATE_SUBSCRIPTION"
load_config_vars "${workload_config_information}" "keyvault"
load_config_vars "${workload_config_information}" "deployer_tfstate_key"

# Checking for valid az session
az account show > stdout.az 2>&1
temp=$(grep "az login" stdout.az)
if [ -n "${temp}" ]; then
    echo ""
    echo "#########################################################################################"
    echo "#                                                                                       #"
    echo "#                           Please login using az login                                 #"
    echo "#                                                                                       #"
    echo "#########################################################################################"
    echo ""
    if [ -f stdout.az ]
    then
        rm stdout.az
    fi
    exit -1
else
    if [ -f stdout.az ]
    then
        rm stdout.az
    fi
fi
account_set=0

if [ ! -z "${STATE_SUBSCRIPTION}" ]
then
    $(az account set --sub "${STATE_SUBSCRIPTION}")
    account_set=1
fi

if [ ! -n "${REMOTE_STATE_SA}" ]
then
    # Ask for deployer environment name and try to read the deployer state file and resource group details from the configuration file
    
    if [ -n "$deployer_environment" ]
    then
        read -p "Deployer environment name: " deployer_environment
    fi
    
    deployer_config_information="${automation_config_directory}""${deployer_environment}""${region}"
    load_config_vars "${deployer_config_information}" "keyvault"
    load_config_vars "${deployer_config_information}" "REMOTE_STATE_RG"
    load_config_vars "${deployer_config_information}" "REMOTE_STATE_SA"
    load_config_vars "${deployer_config_information}" "tfstate_resource_id"
    load_config_vars "${deployer_config_information}" "deployer_tfstate_key"

    if [ -z $STATE_SUBSCRIPTION]
    then
        # Retain post processing in case tfstate_resource_id was set by earlier
        # version of script tools.
        STATE_SUBSCRIPTION=$(echo $tfstate_resource_id | cut -d/ -f3 | tr -d \" | xargs)
    fi

    
    if [ -z $REMOTE_STATE_RG ]
    then
        get_and_store_sa_details ${REMOTE_STATE_SA} "${workload_config_information}"
        load_config_vars "${workload_config_information}" "STATE_SUBSCRIPTION"
        load_config_vars "${workload_config_information}" "REMOTE_STATE_RG"
        load_config_vars "${workload_config_information}" "tfstate_resource_id"

    fi
    
    tfstate_parameter=" -var tfstate_resource_id=${tfstate_resource_id}"

    save_config_vars "${workload_config_information}" \
    keyvault \
    deployer_tfstate_key
    
    if [ -n "${STATE_SUBSCRIPTION}" ]
    then
        if [ ${account_set} == 0 ]
        then
            $(az account set --sub "${STATE_SUBSCRIPTION}")
            account_set=1
        fi
        

    fi
else
    if [ -z "$REMOTE_STATE_RG" ]
    then
        get_and_store_sa_details ${REMOTE_STATE_SA} "${workload_config_information}"
        load_config_vars "${workload_config_information}" "STATE_SUBSCRIPTION"
        load_config_vars "${workload_config_information}" "REMOTE_STATE_RG"
        load_config_vars "${workload_config_information}" "tfstate_resource_id"

    fi

fi
if [ -n $keyvault ]
then
    secretname="${environment}"-client-id
    az keyvault secret show --name "$secretname" --vault "$keyvault" --only-show-errors 2>error.log
    if [ -s error.log ]
    then
        if [ ! -z "$spn_secret" ]
        then
            allParams=$(printf " --workload --environment %s --region %s --vault %s --spn_secret %s --subscription %s" ${environment} ${region} ${keyvault} ${spn_secret} ${subscription})
                
            "${DEPLOYMENT_REPO_PATH}"/deploy/scripts/set_secrets.sh $allParams 
            if [ $? -eq 255 ]
            then
                exit $?
            fi
        else
            read -p "Do you want to specify the Workload SPN Details Y/N?"  ans
            answer=${ans^^}
            if [ $answer == 'Y' ]; then
                load_config_vars ${workload_config_information} "keyvault"
                if [ ! -z $keyvault ]
                then
                    # Key vault was specified in ~/.sap_deployment_automation in the deployer file
                    keyvault_param=$(printf " -v %s " "${keyvault}")
                fi
                
                env_param=$(printf " -e %s " "${environment}")
                region_param=$(printf " -r %s " "${region}")
                
                allParams="${env_param}""${keyvault_param}""${region_param}"
                
                "${DEPLOYMENT_REPO_PATH}"/deploy/scripts/set_secrets.sh $allParams -w
                if [ $? -eq 255 ]
                then
                    exit $?
                fi
            fi
        fi
    fi
    if [ -f error.log ]
    then
        rm error.log
    fi
    
    if [ -f kv.log ]
    then
        rm kv.log
    fi
    
fi
if [ -z "${deployer_tfstate_key}" ]
then
    load_config_vars "${workload_config_information}" "deployer_tfstate_key"
    if [ ! -z "${deployer_tfstate_key}" ]
    then
        # Deployer state was specified in ~/.sap_deployment_automation library config
        deployer_tfstate_key_parameter=" -var deployer_tfstate_key=${deployer_tfstate_key}"
        deployer_tfstate_key_exists=true
    fi
else
    deployer_tfstate_key_parameter=" -var deployer_tfstate_key=${deployer_tfstate_key}"
    save_config_vars "${workload_config_information}" deployer_tfstate_key
    
fi

if [ -z "${DEPLOYMENT_REPO_PATH}" ]; then
    option="DEPLOYMENT_REPO_PATH"
    missing
    exit -1
fi

if [ -z "${REMOTE_STATE_SA}" ]; then
    read -p "Terraform state storage account name:"  REMOTE_STATE_SA
    get_and_store_sa_details ${REMOTE_STATE_SA} "${workload_config_information}"
    load_config_vars "${workload_config_information}" "STATE_SUBSCRIPTION"
    load_config_vars "${workload_config_information}" "REMOTE_STATE_RG"
    load_config_vars "${workload_config_information}" "tfstate_resource_id"

    tfstate_parameter=" -var tfstate_resource_id=${tfstate_resource_id}"

    if [ ! -z "${STATE_SUBSCRIPTION}" ]
    then
        if [ $account_set==0 ]
        then
            $(az account set --sub "${STATE_SUBSCRIPTION}")
            account_set=1
        fi
    fi
    
    
fi

if [ -z "${REMOTE_STATE_RG}" ]; then
    if [  -n "${REMOTE_STATE_SA}" ]; then
        get_and_store_sa_details ${REMOTE_STATE_SA} "${workload_config_information}"
        load_config_vars "${workload_config_information}" "STATE_SUBSCRIPTION"
        load_config_vars "${workload_config_information}" "REMOTE_STATE_RG"
        load_config_vars "${workload_config_information}" "tfstate_resource_id"
        
        tfstate_parameter=" -var tfstate_resource_id=${tfstate_resource_id}"
    else
        
        option="REMOTE_STATE_RG"
        read -p "Remote state resource group name:"  REMOTE_STATE_RG
        save_config_vars "${workload_config_information}" REMOTE_STATE_RG
    fi
fi

if [ -n "${tfstate_resource_id}" ]
then
    tfstate_parameter=" -var tfstate_resource_id=${tfstate_resource_id}"
else
    get_and_store_sa_details ${REMOTE_STATE_SA} "${workload_config_information}"
    load_config_vars "${workload_config_information}" "tfstate_resource_id"
    tfstate_parameter=" -var tfstate_resource_id=${tfstate_resource_id}"

fi

terraform_module_directory="${DEPLOYMENT_REPO_PATH}"/deploy/terraform/run/"${deployment_system}"/

if [ ! -d "${terraform_module_directory}" ]
then
    printf -v val %-40.40s "$deployment_system"
    echo "#########################################################################################"
    echo "#                                                                                       #"
    echo "#   Incorrect system deployment type specified: ${val}#"
    echo "#                                                                                       #"
    echo "#     Valid options are:                                                                #"
    echo "#       sap_landscape                                                                   #"
    echo "#                                                                                       #"
    echo "#########################################################################################"
    echo ""
    exit -1
fi

ok_to_proceed=false
new_deployment=false

#Plugins
if [ ! -d "$HOME/.terraform.d/plugin-cache" ]
then
    mkdir "$HOME/.terraform.d/plugin-cache"
fi
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
root_dirname=$(pwd)

check_output=0

if [ $account_set==0 ]
then
    $(az account set --sub "${STATE_SUBSCRIPTION}")
    account_set=1
fi

if [ ! -d ./.terraform/ ];
then
    terraform -chdir="${terraform_module_directory}" init -upgrade=true  --backend-config "subscription_id=${STATE_SUBSCRIPTION}" \
    --backend-config "resource_group_name=${REMOTE_STATE_RG}" \
    --backend-config "storage_account_name=${REMOTE_STATE_SA}" \
    --backend-config "container_name=tfstate" \
    --backend-config "key=${key}.terraform.tfstate"
else
    temp=$(grep "\"type\": \"local\"" .terraform/terraform.tfstate)
    if [ ! -z "${temp}" ]
    then
        
        terraform -chdir="${terraform_module_directory}" init -upgrade=true -force-copy --backend-config "subscription_id=${STATE_SUBSCRIPTION}" \
        --backend-config "resource_group_name=${REMOTE_STATE_RG}" \
        --backend-config "storage_account_name=${REMOTE_STATE_SA}" \
        --backend-config "container_name=tfstate" \
        --backend-config "key=${key}.terraform.tfstate"
    else
        terraform -chdir="${terraform_module_directory}" init -upgrade=true -reconfigure --backend-config "subscription_id=${STATE_SUBSCRIPTION}" \
        --backend-config "resource_group_name=${REMOTE_STATE_RG}" \
        --backend-config "storage_account_name=${REMOTE_STATE_SA}" \
        --backend-config "container_name=tfstate" \
        --backend-config "key=${key}.terraform.tfstate"
        check_output=1
    fi
    
fi

if [ 1 == $check_output ]
then
    outputs=$(terraform -chdir="${terraform_module_directory}" output)
    if echo "${outputs}" | grep "No outputs"; then
        ok_to_proceed=true
        new_deployment=true
        echo "#########################################################################################"
        echo "#                                                                                       #"
        echo "#                                   New deployment                                      #"
        echo "#                                                                                       #"
        echo "#########################################################################################"
    else
        echo ""
        echo "#########################################################################################"
        echo "#                                                                                       #"
        echo "#                           Existing deployment was detected                            #"
        echo "#                                                                                       #"
        echo "#########################################################################################"
        echo ""
        
        deployed_using_version=$(terraform -chdir="${terraform_module_directory}" output automation_version)
        if [ ! -n "${deployed_using_version}" ]; then
            echo ""
            echo "#########################################################################################"
            echo "#                                                                                       #"
            echo "#    The environment was deployed using an older version of the Terrafrom templates     #"
            echo "#                                                                                       #"
            echo "#                               !!! Risk for Data loss !!!                              #"
            echo "#                                                                                       #"
            echo "#        Please inspect the output of Terraform plan carefully before proceeding        #"
            echo "#                                                                                       #"
            echo "#########################################################################################"
            
            read -p "Do you want to continue Y/N?"  ans
            answer=${ans^^}
            if [ $answer == 'Y' ]; then
                ok_to_proceed=true
            else
                unset TF_DATA_DIR

                exit 1
            fi
        else
            
            echo ""
            echo "#########################################################################################"
            echo "#                                                                                       #"
            echo "# Terraform templates version:" $deployed_using_version "were used in the deployment "
            echo "#                                                                                       #"
            echo "#########################################################################################"
            echo ""
            #Add version logic here
        fi
    fi
fi

echo ""
echo "#########################################################################################"
echo "#                                                                                       #"
echo "#                             Running Terraform plan                                    #"
echo "#                                                                                       #"
echo "#########################################################################################"
echo ""

terraform -chdir="${terraform_module_directory}" plan -var-file=${var_file} $tfstate_parameter $deployer_tfstate_key_parameter > plan_output.log

if [ ! $new_deployment ]
then
    if [ grep "No changes" plan_output.log ]
    then
        echo ""
        echo "#########################################################################################"
        echo "#                                                                                       #"
        echo "#                           Infrastructure is up to date                                #"
        echo "#                                                                                       #"
        echo "#########################################################################################"
        echo ""
        rm plan_output.log
        unset TF_DATA_DIR
    
        exit 0
    fi
    if [ grep "0 to change, 0 to destroy" plan_output.log ]
    then
        echo ""
        echo "#########################################################################################"
        echo "#                                                                                       #"
        echo "#                               !!! Risk for Data loss !!!                              #"
        echo "#                                                                                       #"
        echo "#        Please inspect the output of Terraform plan carefully before proceeding        #"
        echo "#                                                                                       #"
        echo "#########################################################################################"
        echo ""
        read -n 1 -r -s -p $'Press enter to continue...\n'
        
        cat plan_output.log
        read -p "Do you want to continue with the deployment Y/N?"  ans
        answer=${ans^^}
        if [ $answer == 'Y' ]; then
            ok_to_proceed=true
        else
            unset TF_DATA_DIR

            exit -1
        fi
    else
        ok_to_proceed=true
    fi
fi

if [ $ok_to_proceed ]; then
    
    rm plan_output.log
    
    echo ""
    echo "#########################################################################################"
    echo "#                                                                                       #"
    echo "#                             Running Terraform apply                                   #"
    echo "#                                                                                       #"
    echo "#########################################################################################"
    echo ""
    
    terraform -chdir="${terraform_module_directory}" apply ${approve} -var-file=${var_file} $tfstate_parameter $landscape_tfstate_key_parameter $deployer_tfstate_key_parameter
fi

return_value=0
landscape_tfstate_key=${key}.terraform.tfstate
save_config_var "landscape_tfstate_key" "${workload_config_information}"

unset TF_DATA_DIR

exit $return_value
