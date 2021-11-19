function Get-slDECRewardsSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("PlayerName")]
        $UserName
    )

    Process {
        $allRewardList = [System.Collections.Generic.List[object]]::new()
        $rewardTypes = @("dec_reward","quest_rewards","season_rewards")
        foreach ($type in $rewardTypes){
            try{
                $firstandLastDate = $null
                $dateRange = $null
                $averageGamesperDay = $null
                $averageDailyEarned = $null

                $balancehistoryParam = @{
                    UserName    = $UserName
                    TokenType   = "DEC"
                    Limit       = 5000
                    TransactionType = $type
                    ErrorAction = "Stop"
                }
                $decRewards = Get-slBalanceHistory @balancehistoryParam
                $Stats = $decRewards | Measure-Object -Property amount -Sum -Average -Maximum -Minimum
                $groupbyDay = $decRewards | Group-Object -Property {
                    $_.created_date.ToShortDateString()
                }
                $firstandLastDate = $decRewards | Sort-Object created_date | Select-Object -First 1 -Last 1
                if (($firstandLastDate | Measure-Object).Count -eq 2){
                    $dateRange = New-TimeSpan -Start $firstandLastDate[0].created_date -End $firstandLastDate[1].created_date -ErrorAction SilentlyContinue
                    $averageGamesperDay = [math]::round(($groupbyDay | Measure-Object -Property Count -Sum).Sum / $dateRange.Days)
                    $averageDailyEarned = [math]::round(($groupbyDay.Group | Measure-Object -Property amount -Sum).Sum / $dateRange.Days)
                }
    
                $rewardTypeName = switch ($type){
                    "dec_reward" {"Battle"}
                    "quest_rewards" {"Quest"}
                    "season_rewards" {"Season"}
                }
    
                $rewardSumary = [PSCustomObject]@{
                    PSTypeName  = "splinterlands.decrewardsummary"
                    RewardType  = $rewardTypeName
                    RewardCount = ($decRewards | Measure-Object).Count
                    AvgReward   = [math]::Round($Stats.Average,2)
                    TotalDays   = $dateRange.Days
                    AvgRewardsPerDay = $averageGamesperDay
                    AvgDailyDEC = $averageDailyEarned
                    Total       = $Stats.Sum
                    Stats       = $Stats
                    DateRange   = $dateRange
                    StartDate   = ($firstandLastDate | Select-Object -First 1).created_date
                    EndDate     = ($firstandLastDate | Select-Object -Last 1).created_date
                    RewardTransactions = $decRewards
                }

                $allRewardList.Add($rewardSumary)
                $rewardSumary
            }
            catch{
                Write-Warning "Unable to calculate [$type] reward summary"
            } #try/catch
        } #foreach

        #summary
        $decRewards = $allRewardList.RewardTransactions
        $Stats = $decRewards | Measure-Object -Property amount -Sum -Average -Maximum -Minimum
        $groupbyDay = $decRewards | Group-Object -Property {
            $_.created_date.ToShortDateString()
        }
        $firstandLastDate = $decRewards | Sort-Object created_date | Select-Object -First 1 -Last 1
        if (($firstandLastDate | Measure-Object).Count -eq 2){
            $dateRange = New-TimeSpan -Start $firstandLastDate[0].created_date -End $firstandLastDate[1].created_date -ErrorAction SilentlyContinue
            $averageGamesperDay = [math]::round(($groupbyDay | Measure-Object -Property Count -Sum).Sum / $dateRange.Days)
            $averageDailyEarned = [math]::round(($groupbyDay.Group | Measure-Object -Property amount -Sum).Sum / $dateRange.Days)
        }

        [PSCustomObject]@{
            PSTypeName  = "splinterlands.decrewardsummary"
            RewardType  = "All"
            RewardCount = ($decRewards | Measure-Object).Count
            AvgReward   = [math]::Round($Stats.Average,2)
            TotalDays   = $dateRange.Days
            AvgRewardsPerDay = $averageGamesperDay
            AvgDailyDEC = $averageDailyEarned
            Total       = $Stats.Sum
            Stats       = $Stats
            DateRange   = $dateRange
            StartDate   = ($firstandLastDate | Select-Object -First 1).created_date
            EndDate     = ($firstandLastDate | Select-Object -Last 1).created_date
            RewardTransactions = $decRewards
        }
    }
}