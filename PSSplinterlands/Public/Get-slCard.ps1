function Get-slCard {
    [CmdletBinding()]
    param(
        [int]$Id
    )

    try{
        $cards = Invoke-SplinterlandsAPI -Uri "https://api.splinterlands.io/cards/get_details"
        if ($cards){
            foreach ($card in $cards){
                $card | Add-Member -TypeName "splinterlands.card"
                Add-Member -InputObject $card -NotePropertyMembers @{
                    RarityName = Resolve-slRarity $card.Rarity
                    EditionName = ($card.editions -split "," | Resolve-slEdition)
                }
                $card
            }
        }
    }
    catch{
        $PSCmdlet.WriteError($_)
    }
}