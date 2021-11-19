function Get-slBattleHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("UserName")]
        [string]$PlayerName
    )

    try{
        $Battles = Invoke-SplinterlandsAPI -Uri "https://game-api.splinterlands.io/battle/history?player=$PlayerName"
        foreach ($battle in $Battles.battles){
            $battle.details = $battle.details | ConvertFrom-Json
            $Teams = @($battle.details.team1,$battle.details.team2)
            if ($PlayerName -eq $battle.player_1){
                $Enemy = $battle.player_2
            }
            else {
                $Enemy = $battle.player_1
            }
            $battle | Add-Member -NotePropertyMembers @{
                Player = $PlayerName
                Enemty = $Enemy
                PlayerTeam = $Teams | Where-Object player -eq $PlayerName
                EnemyTeam = $Teams | Where-Object player -eq $Enemy
            }
            $battle
        }
    }
    catch{
        $PSCmdlet.WriteError($_)
    }
}