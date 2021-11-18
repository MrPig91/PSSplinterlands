function Resolve-slRarity {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [int]$Rarity
    )

    Process {
        switch ($Rarity){
            1 {"Common"}
            2 {"Rare"}
            3 {"Epic"}
            4 {"Summoner"}
            default {"Unknown"}
        }
    }
}