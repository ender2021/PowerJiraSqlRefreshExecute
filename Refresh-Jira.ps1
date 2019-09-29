#import modules
Import-Module PowerJira -Force
Import-Module SqlServer -Force
Import-Module PowerJiraSqlRefresh -Force

#import the variable $JiraCredentials
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath \credentials\Credentials.psm1) -Force

####################################################
#  CONFIGURATION                                   #
####################################################

#configure the database targets and refresh type
$paramSplat = @{
    SqlInstance = "localhost"
    SqlDatabase = "Jira_Experiment"
    RefreshType = (Get-JiraRefreshTypes).Differential
}

#configuration of the projects to pull
$getAll = $true
if(!$getAll) {
    $paramSplat.Add("ProjectKeys", @("GROPGDIS","GDISPROJ","GDISTRAIN","GRPRIAREP","GRPRIAWEB","SFSDEVOPS","GFO","GSIS","GSPP","GSISPLAN"))
}

####################################################
#  OPEN JIRA SESSION                               #
####################################################

Open-JiraSession @JiraCredentials

####################################################
#  PERFORM REFRESH                                 #
####################################################

Update-JiraSql @paramSplat -Verbose -ErrorAction "Stop"

####################################################
#  CLOSE JIRA SESSION                              #
####################################################

Close-JiraSession