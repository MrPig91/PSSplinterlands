function Get-slPlayerBattleSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("opponent_player")]
        [string]$PlayerName,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias("inactive")]
        [string]$IgnoreColors
    )

    Process{
        $IgnoreColorsList = $IgnoreColors -split ","
        $allCards = Get-slCard
        $recentBattles = Get-slBattleHistory -PlayerName $PlayerName
        $battleCount = ($recentBattles | Measure-Object).Count
        $playerQuest = Get-slPlayersQuest -PlayerName $PlayerName

        $top3Summoners = $recentBattles.PlayerTeam | Where-Object color -notin $IgnoreColorsList | Select-Object -ExpandProperty summoner |
            Group-Object card_detail_id | Sort-Object Count -Descending | Select-Object -First 3
        $summonerUsage = foreach ($summoner in $top3Summoners){
            $summonerDetails = $allCards | Where-Object Id -eq $summoner.Name
            $sPercentage = [math]::round(($summoner.count / $battleCount * 100))
            $summonerLevel = $summoner.group | Select-Object -First 1 -ExpandProperty level

            $summonerBattles = $recentBattles | Where-Object {$_.PlayerTeam.Summoner.card_detail_id -eq $summoner.name}
            $summonerBattleCount = ($summonerBattles | Measure-Object).Count
            $top6SummonerMonsters = $summonerBattles.PlayerTeam.monsters | Group-Object card_detail_id |
            Sort-Object Count -Descending | Select-Object -First 6
            $TopSummonerMonsters = foreach ($monster in $top6SummonerMonsters){
                $monsterDetails = $allCards | Where-Object Id -eq $monster.Name
                $monsterLevel = $monster.group | Select-Object -First 1 -ExpandProperty level
                $mPercentage = [math]::round(($monster.count / $summonerBattleCount * 100))
                [PSCustomObject]@{
                    Monster = $monsterDetails
                    Abilities = $monsterDetails.stats.abilities[0.. ($monsterLevel - 1)]
                    MonsterLevel = $monsterLevel
                    UsagePercentage = $mPercentage
                }
            }

            [PSCustomObject]@{
                Summoner = $summonerDetails
                UsagePercentage = $sPercentage
                SummonerLevel = $summonerLevel
                TopSummonerMonsters = $TopSummonerMonsters
            }
        }

        $top6Monsters = $recentBattles.PlayerTeam.monsters | Group-Object card_detail_id |
            Sort-Object Count -Descending | Select-Object -First 6
        $monsterUsage = foreach ($monster in $top6Monsters){
            $monsterLevel = $monster.group | Select-Object -First 1 -ExpandProperty level
            $monsterDetails = $allCards | Where-Object Id -eq $Monster.Name
            $mPercentage = [math]::round(($monster.count / $battleCount * 100))
            [PSCustomObject]@{
                Monster = $monsterDetails
                MonsterLevel = $monsterLevel
                Abilities = $monsterDetails.stats.abilities[0.. ($monsterLevel - 1)]
                UsagePercentage = $mPercentage
            }
        }

        [PSCustomObject]@{
            PSTypeName = "splinterlands.playerbattlesummary"
            PlayerName = $PlayerName
            CurrentQuest = $playerQuest
            TopSummoners = $summonerUsage
            TopMonsters = $monsterUsage
        }
    } #process
}