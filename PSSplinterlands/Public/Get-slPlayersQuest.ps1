function Get-slPlayersQuest {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("UserName")]
        [string[]]$PlayerName
    )

    Process {
        foreach ($player in $PlayerName){
            #foreach at the end is needed for some weird reason
            try{
                $questInfo = Invoke-SplinterlandsAPI -Uri "https://api2.splinterlands.com/players/quests?username=$player" -ErrorAction Stop | ForEach-Object {$_}
                try{
                    $questInfo.created_date = [datetime]::Parse($questInfo.created_date)
                    $questInfo.claim_date = [datetime]::Parse($questInfo.claim_date)
                }
                catch{
                    Write-Information "Unable to parse date" 
                }
                $questInfo | Add-Member -TypeName "splinterlands.quest"
                $questInfo | Add-Member -MemberType NoteProperty -Name "QuestType" -Value (Resolve-slQuest $questInfo.Name)
                $questInfo | Add-Member -MemberType NoteProperty -Name "Completed" -Value ($questInfo.total_items -eq $questInfo.completed_items)
                $questInfo
            }
            catch{
                $PSCmdlet.WriteError($_)
            }
        }
    }
}