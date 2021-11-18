function Invoke-SplinterlandsAPI {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Uri
    )

    try {
        Invoke-RestMethod -Uri $Uri
    }
    catch{
        $PSCmdlet.WriteError($_)
    }
}