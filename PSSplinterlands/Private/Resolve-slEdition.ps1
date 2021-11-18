function Resolve-slEdition {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [int]$Edition
    )

    Process {
        switch ($Edition){
            0 {"Alpha"}
            1 {"Beta"}
            2 {"Promo"}
            3 {"Reward"}
            4 {"Untamed"}
            5 {"Dice"}
            6 {"Gladius"}
            default {"Unknown"}
        }
    }
}