Param(
    
    [string]
    [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
    $query, 
   
    [string]
    $name
)

function Get-ConnectionString {
    Param( $connectionStringName )

    $webconfig = (Get-Content "web.config" -ErrorAction Stop) -as [Xml]

    if ($connectionStringName) {
        [string]$conn = $webconfig.DocumentElement.connectionStrings.add | Where-Object {$_.name -eq $connectionStringName} | Select-Object -ExpandProperty "connectionString"
    } else {
        [string]$conn = $webconfig.DocumentElement.connectionStrings.add | Select-Object -First 1 -ExpandProperty "connectionString"
    }

    if(!$conn) {
        throw "Could not find a connection string"
    }

    $conn
}

function Get-ConnectionProperties {
    Param ( [string]$conn )

    $sb = New-Object System.Data.Common.DbConnectionStringBuilder
    $sb.set_ConnectionString($conn)

    New-Object PSObject -Property @{Server=$sb["data source"]; Database=$sb["initial catalog"]}
}

$connectionString = Get-ConnectionString $name
$connection = Get-ConnectionProperties $connectionString

Invoke-Sqlcmd $query -ServerInstance $connection.Server -Database $connection.Database | Format-Table -Force -AutoSize