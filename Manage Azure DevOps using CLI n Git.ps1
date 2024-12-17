#### Demo Git Repository Basic Operation on Local and Azure DevOps Repo


#########################################################
##########       Preparing for Next Demo       ##########
#########################################################


### Demo for Module 02 - Working with Local Repository - Start -

## Go to local repository folder
$localProjectRoot = 'D:\DevOpsProjects\TrainingEnv20241217'
cd $localProjectRoot
cd "$((Get-Item $localProjectRoot).PSDrive.Name):"

### Preparing Local Git

### Avoid annoying GIT stderr message in powershell
$env:GIT_REDIRECT_STDERR = '2>&1'

# Create a ASP.NET core 6 web app
## Create Local Git Repository for App
mkdir myWebApp.core7
cd myWebApp.core7
$localGitRepository = (Get-Location).Path

# Verify dotnet SDk
## check default sdk version
dotnet --version
## check installed sdk list
dotnet --list-sdks
## copy the .net core 6 sdk version (Major.Minor), example: 6.0
## ensure the .net core sdk version for current folder
dotnet new globaljson
## Edit the json file and apply the sdk version as below which allow 6.0.xxx version of sdk
### Example for core 7
## {
##  "sdk": {
##     "version": "7.0.102"
##  }
## }
### Example for core 6
## {
##   "sdk": {
##     "version": "6.0",
##     "rollForward": "latestFeature"
##   }
## }
##
code global.json

# Verify dotnet mvc template is available
dotnet new --list
## Find short name - mvc
dotnet new mvc

# Configure Local Git Repository
## Initialize a new Git local repository - Per Application Folder
git init

## Configure global settings for the name and email address to be used when committing in this Git repository
## Verify git configuration
git config -l

# Update to git if missing below information
git config --global user.name "James Hong" 
git config --global user.email "jhcg@hotmail.com"

# To remove setting
git config --global --unset-all gui.recentrepo

## working behind an enterprise proxy, you can make your Git repository proxy-aware by adding the proxy details 
## in the Git global configuration file.
# git config --global http.proxy 
# http://proxyUsername:proxyPassword@proxy.server.com:port

### Demo for Module 02 - Working with Local Repository - End -


#########################################################
##########       Preparing for Next Demo       ##########
#########################################################


### Demo for Module 02 - Local Repository & VS Code - Start -

# view local repository
git branch --list

### Create MVC App using VS Code
## Create a new ASP.NET core application.
dotnet new mvc

## Launch Visual Studio Code in the context of the current working folder
code .

## To exclude files from git, just add to .gitignore, before committ it
code developerLocalNoted.txt
# Add "Hello World" message in the file
code .gitignore
# Add below lines into .gitignore file
# # Ignore files
# /developerLocalNoted.txt
# 
# # Ignore All Files and Folders
# /.vs/*/*.*
# /.vs/*/*/*.*
# /.vs/*/*/*/*.*
# /bin/*/*.*
# /obj/*.cache
# /obj/*.csproj*
# /obj/*.pack*
# /obj/*/*.*

## This will exclude folder Hello.txt
# git rm Hello.txt

## Build and Run in commandline 
dotnet build
dotnet run
# .net core 5 - browser https://localhost:5001 , ctrl+c to stop
# .net core 6 - browser https://localhost:7209 , ctrl+c to stop
# .net core 7 - browser https://localhost:7211 , ctrl+c to stop

## Commit the newly created development to local repository
## On master branch
git status
git add .
git commit -m "New web application created"
git status

## Verift current master branch had being committed
git branch --list
# To see the history of changes in the master branch run the command 
git log -v
# To investigate the actual changes in the commit, you can run the command 
git log -p
# q to exit when execute in command console, ctrl+c when execute in powershell

## Learn to reset log on committed changes
code Program.cs
# Add a comment as a changes
git status
git add Program.cs
git commit -m "Demo code line added"
git status
# vew git log
git log -v
# copy the "New web application created" commit hash code
$targetlog = '9ecc2f76024057fbc98158aa1e63324d2b1bc6a4'
# reset the changes to the "New web application created" committed copy
git reset --hard $targetlog
git log -v

### Demo for Module 02 - Local Repository & VS Code - End -


#########################################################
##########       Preparing for Next Demo       ##########
#########################################################


### Demo for Module 02 - Working with Git Repository Server - Start -

## Data Directory
$DataPath = $localProjectRoot
# Create Personal Access Token from Azure DevOps Portal and save to file
$MyFileName = "PAT_Token.txt"
$PAT_Token_Source = Join-Path $DataPath $MyFileName
$PAT_Token = Get-Content $PAT_Token_Source

## Create an Azure Repo name "Demo" with default "README.md"
git config -l

# Optional 1 - Install git with git credential maneger 
## Git Clone url
$gitUrl = 'https://TrainingEnv@dev.azure.com/TrainingEnv/eShopOnWeb/_git/Demo'
## Configure remote origin for local git repository
git remote add origin $gitUrl

# Optional 2 - Using PAT to login (Use this for Demo)
$gitUrl = "https://$($PAT_Token)@dev.azure.com/TrainingEnv/eShopOnWeb/_git/Demo"
## Configure remote origin for local git repository
git remote add origin $gitUrl 
## Optional 2nd remote location
# git remote add mydevops $gitUrl

# check remote setting
git remote

# Check setting
git config -l

# To remove remote origin setting
# git remote remove origin

# view both remote-tracking branches and local branches
git branch -a
## Push code to origin repository, the -u flag (upstream) for first push
git push -u origin master
# git push -u --force origin master
# verify on Azure DevOps portal

# Sync local master branch with remote
# git pull -f origin master

# Get local master branch with remote
# git pull origin master

### Demo for Module 02 - Working with Git Repository Server - End -


#########################################################
##########       Preparing for Next Demo       ##########
#########################################################


### Demo for Module 04 - Getting Ready Azure DecOps CLI - Start -

### Preparing Azure DecOps CLI integration
## Login to Azure
az login

## # List subscription
## az account list --output table
## # Set default subscription using name or id
## az account set --subscription 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'

## Ensure Azure DevOps extension install
az extension list-available --output table
az extension list --output table
az extension add --name azure-devops
## Update extension
az extension update --name azure-devops

## Azure DevOps Information
$AzureDevOpsServer="https://dev.azure.com/TrainingEnv"
$project="eShopOnWeb"

## Login to Azure DevOps using PAT Token (For This Demo)
$PAT_Token | az devops login
# to Target Organization
$PAT_Token | az devops login --organization $AzureDevOpsServer

## ## # Set Azure DevOps- Billing Subscription using name / id
## az devops configure -h
## az devops configure --list
## az devops configure --subscription 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'

## Understanding az devops command
az devops --help
az devops project --help
az devops project list --output table


### Verify Azure DecOps Enviromrnt using CLI
## List all Repositories in project
az repos list --organization $AzureDevOpsServer --project $project --output table

## Varify Branch
$azdevopsReposName = 'Demo'

# at Azure Repos
# az repos list --organization $AzureDevOpsServer --project $project `
#    --query "[?name=='$($azdevopsReposName)'].{Id:id,Name:name,DefaultBranch:defaultBranch,RemoteUrl:remoteUrl}" --output table
# or
az repos show --repository $azdevopsReposName --organization $AzureDevOpsServer --project $project --output table

### Demo for Module 04 - Getting Ready Azure DecOps CLI - End -


#########################################################
##########       Preparing for Next Demo       ##########
#########################################################


### Demo for Module 04 - Pull Request for Merging branches - Start -

# Checking repository
git branch --list
git branch -a

# Sync local master branch with remote
git pull -f origin master
# checkout master branch if is not current working branch
git checkout master
git branch

### Branching Demo - feature/myFeature-1 ###
## Create new Branch and Check out, by cloned the master branch into a local repository
$branchName = 'feature/myFeature-1'
git checkout -b $branchName
# Verify
git branch

## update code
# notepad Program.cs
# or
code Program.cs
# Optional
code .
# Verify files status
git status

## Commit Changes - All
# git add .
## Commit Changes - Target only
git add Program.cs

git commit -m "Feature 1 added to Program.cs"
# Verify files status
git status

## Push to Azure DevOps
# Verify Branches - Before action
az repos show --repository $azdevopsReposName --organization $AzureDevOpsServer --project $project --open

# Push changes
git push -u origin $branchName
git branch -a

# Verify Branches and the Work Items - After action
az repos show --repository $azdevopsReposName --organization $AzureDevOpsServer --project $project --open

## Create a new pull request (using the Azure DevOps CLI) to review the changes in the feature-1 branch
## Associate to Work Item 38 and 39 / 719 718
az repos pr create --title "Review Feature-1 before merging to master" `
    --work-items 2374 `
    --description "#Merge feature-1 to master" `
    --source-branch $branchName --target-branch master `
    --repository $azdevopsReposName `
    --project $project

# "codeReviewId": 56

# Tag name: Inner-Release-1

# Verify Pull Request - "codeReviewId": 50
az repos pr show --id 56 --organization $AzureDevOpsServer --open

## Use the –open switch when raising the pull request to open the pull request in a web browser after it has been created. 
## The –deletesource-branch switch can be used to delete the branch after the pull request is complete. 
## Also consider using –auto-complete to complete automatically when all policies have passed and the source branch can be merged into the target branch.

###### Assign the Tag name "demo_release_feture1" on master branch after merging the branch ######

### Demo for Module 04 - Pull Request for Merging branches - End -


#########################################################
##########       Preparing for Next Demo       ##########
#########################################################


### Demo for Module 04 - Resolving conflict - Start -
git checkout master
git pull origin master
git branch
### Branching Demo - feature/myFeature-2 ###
## Start work on Feature 2. Create a branch on remote from the master branch and do the checkout locally
$branchName = 'feature/myFeature-2'
git checkout -b $branchName
git branch

code Program.cs
# or
code .

git status
git add Program.cs
git commit -m "Feature 2 added to Program.cs"
git status

git push -u origin $branchName

# 719 718
$pr = az repos pr create --title "Review Feature-2 before merging to master" `
    --work-items 2369 2370 `
    --description "#Merge feature-2 to master" `
    --source-branch $branchName --target-branch master `
    --repository $azdevopsReposName --project $project 
$prJson = $pr | Out-String
$prFeature2 = $prJson | ConvertFrom-Json

# Verify Pull Request - "codeReviewId": 40
az repos pr show --id $prFeature2.codeReviewId --organization $AzureDevOpsServer --open


git checkout master 
git pull
git branch -a


## Refresh Tags
git fetch --all --tags

### Branching Demo - fof/bug-1 from release_feature1  ###
## a critical bug is reported in production against the feature-1 release. 
## In order to investigate the issue, you need to debug against the version of code currently deployed in production
$branchName = 'fof/bug-1'
# Tag Name
$sourceDevOpsBranch = 'demo_release_feture1'
## if tag not create will fail
git checkout -b $branchName $sourceDevOpsBranch 
git branch

code Program.cs
# or
code .

git status
git add Program.cs
git commit -m "Adding FOF changes"
git status

git push -u origin $branchName

$pr = az repos pr create --title "Review Bug-1 before merging to master" --work-items 2368 `
    --description "#Merge Bug-1 to master" `
    --source-branch $branchName --target-branch master --repository $azdevopsReposName --project $project 
$prJson = $pr | Out-String
$prBug1 = $prJson | ConvertFrom-Json

# Verify Pull Request - "codeReviewId": 12
az repos pr show --id $prBug1.codeReviewId --organization $AzureDevOpsServer --open

## As part of the pull request, the branch is deleted, however, you can still reference the full history to that point using the tag

## With the critical bug fix out of the way, let's go back to the review of the feature-2 pull request. 

## The Git Pull Request Merge Conflict resolution extension makes it possible to resolve merge conflicts right in the browser.


### Resolve merge conflicts
git branch
$branchName = 'feature/myFeature-2'
git checkout $branchName
git pull origin $branchName
git pull origin master
git branch

code Program.cs
# or
code .

git status
git add Program.cs
git commit -m "Resolve merge conflicts changes"
git status

git push

# $prList = az repos pr list --organization $AzureDevOpsServer --project $project | Out-String | ConvertFrom-Json
# $prFeature2 = $prList[0]

## Back to Portal to resolve the Pull Request as normal
# Verify Pull Request - "codeReviewId": 11
az repos pr show --id $prFeature2.codeReviewId --organization $AzureDevOpsServer --open

### Demo for Module 04 - Resolving conflict - End -


#########################################################
##########       Preparing for Next Demo       ##########
#########################################################


### Clean up the Demo

## Logout Azure DevOps
az devops logout

# Clean Up - As Need only
git checkout master
git branch --delete feature/myFeature-1 --force
git branch --delete feature/myFeature-2 --force
git branch --delete fof/bug-1 --force
git branch -a
# Update master from remote after remote commit state has being revert and tag being remove
git pull origin master

## Logout Azure
az logout

##### Scipting Enviroment Note #####
## In powershell CLI continue next line follow PowerShell use `
## In Command Prompt CLI continue next line use ^

## The Azure DevOps CLI supports returning the results of the query in JSON, JSONC, table, and TSV. 


