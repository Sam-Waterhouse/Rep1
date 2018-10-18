$env:PSModulePath = $env:PSModulePath + 'C:\Users\WaterhousePC\Documents\Rep1\Powershell\Modules'

$Modules = Get-ChildItem C:\Users\WaterhousePC\Documents\Rep1\Powershell\Modules -Recurse | Where {$_.Extension -eq '.psm1'}

Foreach ($module in $modules){
    Import-Module $module
}
