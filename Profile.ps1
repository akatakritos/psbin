filter Get-TypeName {if ($_ -eq $null) {'<null>'} else {$_.GetType().Fullname }}

$ProfileRoot = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$env:path += ";$ProfileRoot"