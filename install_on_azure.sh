#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages on Ubuntu
install_ubuntu_packages() {
    echo "Installing packages for Ubuntu..."
    # Add installation steps for Ubuntu here
    sudo apt update
    sudo apt install -y curl unzip

    # Install Terraform if not installed
    if ! command_exists terraform; then
        echo "Installing Terraform..."
        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
        sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        sudo apt update
        sudo apt install -y terraform
    else
        echo "Terraform is already installed."
    fi

    # Install Helm if not installed
    # if ! command_exists helm; then
    #     echo "Installing Helm..."
    #     curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    #     chmod +x get_helm.sh
    #     ./get_helm.sh
    # else
    #     echo "Helm is already installed."
    # fi

    # Install AWS CLI if not installed
    if ! command_exists az; then
        sudo apt install ca-certificates curl apt-transport-https lsb-release gnupg -y
        curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null  
        AZ_REPO=$(lsb_release -cs)  
        echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list  
        echo "Installing Azure CLI..."
        sudo apt update  
        sudo apt install azure-cli -y
    else
        echo "Azure CLI is already installed."
    fi

    # Install Python 3.7 packages if not installed
    if ! command_exists python3.7; then
        echo "Installing Python 3.7..."
        sudo apt update
        sudo apt install -y software-properties-common
        sudo add-apt-repository ppa:deadsnakes/ppa
        sudo apt update
        sudo apt install -y python3.7
    else
        echo "Python 3.7 is already installed."
    fi
}

# Function to install packages on Linux
install_linux_packages() {
    echo "Installing packages for Linux..."
    # Add installation steps for Linux here
    sudo yum update -y
    sudo yum install -y curl unzip

    # Install Terraform if not installed
    if ! command_exists terraform; then
        echo "Installing Terraform..."
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
        sudo yum install -y terraform
    else
        echo "Terraform is already installed."
    fi

    # Install Helm if not installed
    if ! command_exists helm; then
        echo "Installing Helm..."
        curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
        chmod +x get_helm.sh
        ./get_helm.sh
    else
        echo "Helm is already installed."
    fi

    # Install AWS CLI if not installed
    if ! command_exists aws; then
        echo "Installing AWS CLI..."
        sudo yum install -y aws-cli
    else
        echo "AWS CLI is already installed."
    fi

    # Install Python 3.7 packages if not installed
    if ! command_exists python3.7; then
        echo "Installing Python 3.7..."
        sudo yum install -y python3 python3-devel python3-pip
    else
        echo "Python 3.7 is already installed."
    fi
}

# Function to install packages on MacOS
install_macos_packages() {
    echo "Installing packages for MacOS..."
    # Add installation steps for MacOS here
    echo "Installing packages for macOS..."
    brew update
    brew install curl unzip
    if ! command_exists terraform; then
        echo "Installing Terraform..."
        brew tap hashicorp/tap
        brew install hashicorp/tap/terraform
    else
        echo "Terraform is already installed."
    fi

    # Install Helm if not installed
    if ! command_exists helm; then
        echo "Installing Helm..."
        brew install helm
    else
        echo "Helm is already installed."
    fi

    # Install AWS CLI if not installed
    if ! command_exists aws; then
        echo "Installing AWS CLI..."
        brew install awscli
    else
        echo "AWS CLI is already installed."
    fi

    # Install Python 3.7 packages if not installed
    if ! command_exists python3.7; then
        echo "Installing Python 3.7..."
        brew install python@3.7
    else
        echo "Python 3.7 is already installed."
    fi
}

# Function to install packages on Windows
install_windows_packages() {
    echo "Installing packages for Windows..."
     # Execute PowerShell script to install Chocolatey
    powershell.exe -ExecutionPolicy Bypass -File install_choco.ps1
    
    # Install packages using Chocolatey
    choco install -y curl unzip

    # Install Terraform if not installed
    if ! command_exists terraform; then
        echo "Installing Terraform..."
        choco install -y terraform
    else
        echo "Terraform is already installed."
    fi

    # # Install Helm if not installed
    # if ! command_exists helm; then
    #     echo "Installing Helm..."
    #     choco install -y kubernetes-helm
    # else
    #     echo "Helm is already installed."
    # fi

    # Install Azure CLI if not installed
    if ! command_exists az; then
        echo "Installing Azure CLI..."
        $ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi
    else
        echo "Azure CLI is already installed."
    fi

    # Install Python 3.7 packages if not installed
    if ! command_exists python3.7; then
        echo "Installing Python 3.7..."
        choco install -y python --version=3.7
    else
        echo "Python 3.7 is already installed."
    fi

}
# Function to configure AWS credentials
configure_azure_credentials() {
    az login

    read -p "Enter Azure Subscription ID: " azure_subscription_id
    read -p "Enter Azure Resource Group Name: " azure_resource_group_name
    read -p "Enter Azure Cluster Name: " azure_cluster_name
    # read -p "Enter Azure Default Region: " azure_default_region

    export AZURE_SUBSCRIPTION_ID="$azure_subscription_id"
    export AZURE_RESOURCE_GROUP_NAME="$azure_resource_group_name"
    export AZURE_CLUSTER_NAME="$azure_cluster_name"
    # export LOCATION="$azure_default_region"

    az account set --subscription $AZURE_SUBSCRIPTION_ID
    # az group create --name $AZURE_RESOURCE_GROUP_NAME --location $LOCATION
}

# Function to install AWS dependencies
install_azure_dependencies() {
    echo "Installing Using Azure..."
    # Add commands to install AWS dependencies
    # cd AWS || exit

    # Configure AWS CLI
    configure_azure_credentials

    # Run Terraform commands
    terraform init
    terraform plan 
    terraform apply --auto-approve
    echo "Terrafoam commands are successfully executed....."

    az aks get-credentials --resource-group $AZURE_RESOURCE_GROUP_NAME --name $AZURE_CLUSTER_NAME
    echo "AKS cluster credentials has been fetched successfully....."
    
    
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/cloud/deploy.yaml

    kubectl apply -f configmap.yaml
    kubectl apply -f marqoai-2305.yaml
    kubectl apply -f redis.yaml
    echo "Marqo and redis file executed successfully....." 

    # Get the IP address of the service  
    serviceIP=$(kubectl get service marqo-service -o jsonpath="{.spec.clusterIP}")    
    
    # Read the template file content  
    templateContent=$(cat deployment-template.yaml)   
    
    # Replace the placeholder with the actual service IP  
    deploymentContent=$(echo "$templateContent" | sed "s/\${SERVICE_IP}/$serviceIP/g")   
    
    # Save the new content to a deployment.yaml file  
    echo "$deploymentContent" > deployment.yaml  
    
    # Get the IP address of the service  
    apibaseUrl=$(kubectl get service test-srv -o jsonpath="{.spec.clusterIP}")    
    
    # Read the template file content  
    teletemplateContent=$(cat telegram-deployment-template.yaml)   
    
    # Replace the placeholder with the actual service IP  
    Content=$(echo "$teletemplateContent" | sed "s/\${ACT_API_BASE_URL}/$apibaseUrl/g")   
    
    # Save the new content to a deployment.yaml file  
    echo "$Content" > telegram-deployment.yaml  

    # Apply the new YAML file  
    kubectl apply -f deployment.yaml
    sleep 10
    kubectl apply -f telegram-deployment.yaml
    sleep 10
    kubectl apply -f ingress.yaml

}


# Function to run setup based on user's OS selection
run_os_setup() {
    case $os_selection in
        1)
            echo "Selected operating system: Ubuntu"
            install_ubuntu_packages
            ;;
        2)
            echo "Selected operating system: Linux"
            install_linux_packages
            ;;
        3)
            echo "Selected operating system: MacOS"
            install_macos_packages
            ;;
        4)
            echo "Selected operating system: Windows"
            install_windows_packages
            ;;
        *)
            echo "Invalid option. Please select a valid option."
            exit 1
            ;;
    esac
}

# Function to get the external IP of the NGINX Ingress Controller  
get_external_ip() {  
  echo "Fetching the external IP address of the NGINX Ingress Controller..."  
    
  # Wait for the external IP to be assigned  
  while true; do  
    EXTERNAL_IP=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}')  
      
    if [ -n "$EXTERNAL_IP" ]; then  
      echo "External IP address found: $EXTERNAL_IP"  
      break  
    else  
      echo "Waiting for the external IP address to be assigned..."  
      sleep 10  
    fi  
  done  
}  


# Ask user for their operating system
echo "Select your operating system:"
echo "1. Ubuntu"
echo "2. Linux"
echo "3. MacOS"
echo "4. Windows"
read -p "Enter your choice (1-4): " os_selection

# Run setup based on user's OS selection
run_os_setup

# Install AWS dependencies
install_azure_dependencies

# showing external IP to change in DNS record.
get_external_ip

# Print completion message
echo "Package has been deployed successfully"

# Wait for user input before closing  
read -p "Press [Enter] to exit..."