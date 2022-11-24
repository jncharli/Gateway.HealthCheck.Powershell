Set-StrictMode -Version 2.0

# Load libraries (logging)
# ========================
$G_ScriptsFolder = Split-Path $MyInvocation.MyCommand.Path
. "$G_ScriptsFolder\..\_libraries\Logging.ps1"

# Load the constants
# ==================
. "$G_ScriptsFolder\_Constants.HealthCheck.ps1"

# Override some constants
# =======================
$LOG_FILENAME = "HealthCheck.log"

Function NumberOfFilesInFolders($myFolder)
{
    # ##############################
    # Count the number of files in a folder
    # Check if all ToSend and Transit folders are empty
    # ##############################

    return Get-ChildItem -File "$myFolder" | Measure-Object | %{$_.Count}
}

Function RunHealthCheck()
{
    # ##############################
    # Deemed to run on a daily basis
    # Check if all ToSend and Transit folders are empty (both FTP and Outlook)
    # ##############################

    $scriptName = $MyInvocation.MyCommand.Name
    LoggingInfo  $scriptName "Healthcheck is running"

    # Count files in the folders
    # --------------------------
    $countFrom = NumberOfFilesInFolders($FOLDER_FROM)
    $countFTPToSend = NumberOfFilesInFolders($FOLDER_FTP_TOSEND)
    $countFTPTransit = NumberOfFilesInFolders($FOLDER_FTP_TRANSIT)
    $countOutlookToSend = NumberOfFilesInFolders($FOLDER_OUTLOOK_TOSEND)
    $countProcess = NumberOfFilesInFolders($FOLDER_PROCESS)

    # Set the global status
    # ---------------------
    if (($countFrom -gt 0) -or ($countFTPToSend -gt 0) -or ($countFTPTransit -gt 0) -or ($countOutlookToSend -gt 0) -or ($countProcess -gt 0))
    {
        $status = "KO"
    }
    else
    {
        $status = "OK"
    }
    LoggingInfo $scriptname "HealthCheck : $status"

    # Send a mail to admin
    # --------------------
    # Sending a mail by Powershell to an Outlook server needs changes in the Outlook server
    # As the server is managed by La Poste, those changes are not possible
    # To send a mail, the procedure creates a file to External Gateway
    # The Routing table will indicate to send this mail to the admins, and to set the subject
    # of the mail as the name of the file
    # The name of the file will include OK or KO
    
    $currentDateTime = Get-Date -Format yyyyMMdd-HHmmss
    $fileName = $HEALTHCHECK_DIRECTORY_TOSEND + "\" + $currentDateTime + "_" + $HEALTHCHECK_FILE_FILENAME + "_" + $status + ".txt"
    $filename
    try
    {
        LoggingDebug $scriptName "Creating the status file to send to an admin in $filename"
        New-Item "$fileName" -ItemType File -ErrorAction Stop
        add-content -Path "$filename" "Number of From files = $countFrom" -ErrorAction Stop
        add-content -Path "$fileName" "Number of FTP ToSend files = $countFTPToSend" -ErrorAction Stop
        add-content -Path "$fileName" "Number of FTP Transit files = $countFTPTransit" -ErrorAction Stop
        add-content -Path "$fileName" "Number of Outlook ToSend files = $countOutlookToSend" -ErrorAction Stop
        add-content -Path "$fileName" "Number of Process files = $countProcess" -ErrorAction Stop

        LoggingInfo $scriptName "Mail stored in $HEALTHCHECK_DIRECTORY_TOSEND"
    }
    catch
    {
        LoggingInfo $scriptname "Impossible to create the HealthCheck file"
    }
    Finally
    {
        LoggingInfo $scriptName "Number of From files = $countFrom"
        LoggingInfo $scriptName "Number of FTP ToSend files = $countFTPToSend"
        LoggingInfo $scriptName "Number of FTP Transit files = $countFTPTransit"
        LoggingInfo $scriptName "Number of Outlook ToSend files = $countOutlookToSend"
        LoggingInfo $scriptName "Number of Process files = $countProcess"
    }
}

# ====================
# Run the health check
# ====================
RunHealthCheck
