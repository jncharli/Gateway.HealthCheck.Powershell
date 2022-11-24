Set-StrictMode -Version 2.0

# Folders
# =======
$FOLDER_DATA = "\\APPS01\Data\ExternalGateway\Data"
#$G_ScriptsFolder is deduced from the location of the current file

# Logs
# ====
$LOG_FOLDER = "$FOLDER_DATA\_Logs"
$LOG_FILENAME = "HealthCheck.log"

$LOG_DISPLAYDEBUGLEVEL = $False
$LOG_DISPLAYONCONSOLE = $True
$LOG_SAVEINLOGFILE = $True

# Constants (Caution : redundant with Constants.FTPGateway)
# =========
$FOLDER_TOSEND = "1_ToSend"
$FOLDER_TRANSIT = "2_InTransit"

# Specific constants
# ==================
$HEALTHCHECK_FILE_FILENAME = "ExternalGateway.FTP-Outlook.HealthCheck"
$HEALTHCHECK_DIRECTORY_TOSEND = "$FOLDER_DATA\To.MiddleOffice.Outlook"

$FILTER_FOLDERS_FROM = "From.*"
$FILTER_FOLDERS_FTP = "To.*.*FTP"
$FILTER_FOLDERS_OUTLOOK = "To.*.Outlook"
$FILTER_FOLDERS_PROCESS = "Process.*"

$FOLDER_FROM = "$FOLDER_DATA\$FILTER_FOLDERS_FROM\*"
$FOLDER_FTP_TOSEND = "$FOLDER_DATA\$FILTER_FOLDERS_FTP\$FOLDER_TOSEND\*"
$FOLDER_FTP_TRANSIT = "$FOLDER_DATA\$FILTER_FOLDERS_FTP\$FOLDER_TRANSIT\*"
$FOLDER_OUTLOOK_TOSEND = "$FOLDER_DATA\$FILTER_FOLDERS_OUTLOOK\*"
$FOLDER_PROCESS = "$FOLDER_DATA\$FILTER_FOLDERS_PROCESS\*"
