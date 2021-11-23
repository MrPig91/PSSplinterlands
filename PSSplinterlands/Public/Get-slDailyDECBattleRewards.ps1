function Get-slDailyDECBattleRewards {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [Alias("PlayerName")]
        [string]$UserName,
        [int]$Limit = 5000
    )

    Process{
        $balancehistoryParam = @{
            UserName    = $UserName
            TokenType   = "DEC"
            Limit       = $Limit
            TransactionType = "dec_reward"
            ErrorAction = "Stop"
        }
        try{
            $decRewards = Get-slBalanceHistory @balancehistoryParam
        }
        catch{
            Write-Error "Unable to get reward infor: $($_.Exception.Message)" -ErrorAction Stop
        }
        $groupbyDay = {$_.created_date.ToShortDateString()}
        $decRewardGroupByDay = $decRewards | Group-Object $groupbyDay
        foreach ($day in $decRewardGroupByDay){
            [PSCustomObject]@{
                Date = $day.Name
                BattleCount = $day.Count
                DecEarned = ($day.group | Measure-Object -property amount -Sum).sum
            }
        }
    } #Process
}