function Get-slPlayerOutstandingBattle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("UserName")]
        [string[]]$PlayerName
    )

    Process{
        foreach ($player in $PlayerName){
            $Battle = Invoke-SplinterlandsAPI -uri " https://api2.splinterlands.com/players/outstanding_match?username=$PlayerName"
            #api returns a string 'null' if no battle if found
            if ($Battle -ne "null"){
                $Battle | Add-Member -TypeName "splinterlands.outstandingbattle"

                $rulesetList = $Battle.ruleset -split "\|" | where {-not[string]::IsNullOrWhiteSpace($_)}
                $Battle | Add-Member -NotePropertyMembers @{
                    "RulesetList" = $rulesetList
                    "RulesetListFriendly" = ($rulesetList | Resolve-slRuleset)
                }

                $dateProperties = "created_date","expiration_date","match_date","submit_expiration_date"
                foreach ($dateProperty in $dateProperties){
                    try{
                        $Battle.$dateProperty = [datetime]::Parse($battle.$dateProperty)
                    }
                    catch{
                        Write-Information "Unable to parse date property [$dateProperty]"
                    }
                } #foreach date property
                $Battle
            } #if not null
        } #foreach player
    } #process
}