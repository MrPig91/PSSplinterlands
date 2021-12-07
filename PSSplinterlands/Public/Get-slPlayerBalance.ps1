function Get-slPlayerBalance {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("UserName")]
        [string[]]$PlayerName
    )

    Process{
        foreach ($player in $PlayerName){
            $playerBalance = Invoke-SplinterlandsAPI -Uri "https://api2.splinterlands.com/players/balances?username=$player"
            $playerBalance | Foreach-Object {$_.psobject.typenames.insert(0,"splinterlands.playerbalance")}
            $playerBalance | Where-Object token -eq "ECR" | ForEach-Object {
                $_.balance = $_.balance / 100
                $_.last_reward_time = [datetime]$_.last_reward_time
            }
            $playerBalance
        }
    }
}