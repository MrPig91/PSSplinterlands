function Resolve-slRuleset {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string[]]$RulesetName
    )

    Process{
        foreach ($ruleset in $RulesetName){
            switch ($ruleset){
                "Up Close & Personal"   {"Melee Only"}
                "Spreading Fury"        {"Fury Ability"}
                "Odd Ones Out"          {"Odds Only"}
                default {$ruleset}
            }
        }
    }
}