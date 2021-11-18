function Resolve-slQuest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string]$QuestName
    )

    Process{
        switch ($QuestName) {
            "Stir the Volcano" {"Fire"}
            "Lyanna's Call" {"Earth"}
            "Defend the Borders" {"Life"}
            "Rising Dead" {"Death"}
            "Pirate Attacks" {"Water"}
            "Stubborn Mercenaries" {"No Neutrals"}
            "High Priority Targets" {"Dragon"}
            "Stealth Mission" {"Sneak"}
            default {"Unknown"}
        }
    }
}