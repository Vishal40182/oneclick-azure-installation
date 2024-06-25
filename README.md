
# oneclick-azure-installation
Pre-requisites:	
All the below mentioned keys are required for One-click installation of the telegram bot.

Azure subsciption ID=

SERVICE_ENVIRONMENT=
OPENAI_API_TYPE=
OPENAI_API_BASE=
OPENAI_API_VERSION=
OPENAI_API_KEY=
GPT_MODEL=
LOG_LEVEL=
BHASHINI_ENDPOINT_URL=
BHASHINI_API_KEY=
BHASHINI_USER_ID=
MARQO_URL_HOST=
MARQO_URL_PORT=
TRANSLATION_TYPE=
REDIS_HOST=
REDIS_PORT=
REDIS_DB=
BUCKET_TYPE=
BUCKET_NAME=
TELEGRAM_BASE_URL=
TELEGRAM_BOT_TOKEN=
TELEGRAM_BOT_NAME=
ACTIVITY_API_BASE_URL=
STORY_API_BASE_URL=


Procedure:
1. Clone the repository "https://github.com/Vishal40182/oneclick-azure-installation" in your machine.
2. Open terminal and run the script "install_on_azure.sh".
3. Choose your operating system whether it is Ubuntu, Windows or MacOS.
4. Fill out the required details as asked in the terminal such as Azure Subscription ID, Resource Group Name, Azure Cluster Name.
5. Copy external IP if required to expose endpoints on your domain.

Once all the provisioning completed, login to cloud account and map the loadbalancer DNS with the domain name in the DNS mappings in CNAME records.

Once installation is complete, to enable a specific use case, you can follow the below steps to index all the related contents:
1. Install python on the machine from where the files need to be ingested
2. Place the files to be indexed in a folder in the machine.
3. Download index_documents.py and requirements-dev.txt file from https://github.com/Sunbird-AIAssistant/sakhi-api-service
4. Run the following: pip install -r requirements-dev.txt python3 index_documents.py --marqo_url=<MARQO_URL> --index_name=<MARQO_INDEX_NAME> --folder_path=<PATH_TO_INPUT_FILE_DIRECTORY> --fresh_index

Notes:

Please run the commands via screen background as it will take couple of hours to run
“--fresh_index” is to be used when you are running the indexing for the first time or when you delete the existing index and freshly index it. If you want to append new files to the existing index, run it without --fresh_index
For running without --fresh_index, make sure that your new files are kept in a new folder and the --folder_path is pointed to only the new set of files.