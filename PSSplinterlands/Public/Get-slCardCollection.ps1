function Get-slCardCollection {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("UserName")]
        [string]$PlayerName
    )

    try{
        $Uri = "https://api.splinterlands.io/cards/collection/$PlayerName"
        $Collection = Invoke-SplinterlandsAPI -Uri $Uri
        $Collection.cards | ForEach-Object {
            Add-Member -InputObject $_ -TypeName "splinterlands.card"
            try{
                $_.last_used_date = [datetime]::Parse($_.last_used_date)
            }
            catch{
                Write-Information "Unable to parse date" 
            }
        }
        $Collection.cards
    }
    catch{
        $PSCmdlet.WriteError($_)
    }
}