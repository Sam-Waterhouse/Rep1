## Used to create diplomat builds.
Function Get-Folder($initialDirectory){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select a folder"

    if($foldername.ShowDialog() -eq "OK"){
        $folder += $foldername.SelectedPath
    }
    return $folder
}

Function Select-Base{
    [cmdletbinding()]
    Param(
        $DefaultBuildLocation = "C:\Users\WaterhousePC\Documents\Hagrid\Diplomat\branches\base"
    )

    Write-Verbose "Testing $DefaultBuildLocation for Diplomat Base"
    if(Test-Path $DefaultBuildLocation){
        Write-Verbose "$DefaultBuildLocation exists. Returning."
        Return $DefaultBuildLocation
    }
    else{
        Write-Verbose "No Diplomat base found. Executing Get-Folder"
        $DiplomatBase = Get-Folder
        if ($DiplomatBase){
            Write-Verbose "$DiplomatBuild selected as base image."
            Return $DiplomatBase
        }
        else{
            Write-Error -Message "No Diplomat Base selected" -ErrorAction "Stop"
        }
    }
}

Function Select-Build{
    [cmdletbinding()]
    Param(

    )
    Write-Verbose "Executing Get-Folder for a Diplomat build."
    $DiplomatBuild = Get-Folder
    Write-Verbose "$DiplomatBuild Selected as Diplomat Build"
    if ($DiplomatBuild){        
        Return $DiplomatBuild
    }
    else{
        Write-Error -Message "No Diplomat Build selected" -ErrorAction "Stop"
    }
}
Function Create-DiplomatBuild{
    [cmdletbinding()]
    param(
        $OutputDirectory = 'C:\Users\WaterhousePC\Documents\Hagrid\Diplomat Builds',
        $DiplomatBuild,
        $DiplomatBase
    )

    BEGIN{
        $Date = Get-Date -Format FileDateTime
        Write-Verbose "Date: $Date"
        $DiplomatBase = Select-Base
        $DiplomatBuild = Select-Build               
        $Buildname = $DiplomatBuild.split('\')[-1] + $Date
        Write-Verbose "Buildname: $Buildname" 
        $FinalDirectory = $OutputDirectory + '\' + $Buildname
    }
    PROCESS{
        Write-Verbose "Creating $FinalDirectory"
        New-Item $FinalDirectory -ItemType Directory
        Set-Location $OutputDirectory
        Write-Verbose "Copying base image to final directory"
        robocopy $DiplomatBase $FinalDirectory /e
        Write-Verbose "Copying Diplomat build to src directory"
        robocopy $DiplomatBuild "$FinalDirectory\src" /e
    }
    END{
        ##Clean up build image
        $Excessfiles = Get-ChildItem $FinalDirectory | Where-Object {$_.Extension -eq ".PROJECT" -or $_.Extension -eq ".CLASSPATH"}
        Set-Location $FinalDirectory
        Foreach ($Excessfile in $Excessfiles){
            Write-Verbose "Removing excess file: $ExcessFile"
            Remove-Item -Path $Excessfile -Force
        }
    }
}

Create-DiplomatBuild