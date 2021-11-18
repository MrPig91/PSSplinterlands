function Get-slBalanceHistory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [Alias("PlayerName")]
        [string]$UserName,

        [Parameter()]
        [ValidateSet("DEC","SPS","Credits","Voucher","Merits")]
        [string]$TokenType = "DEC",

        [Parameter()]
        [int]$Limit = 5000,

        [Parameter()]
        [int]$Offset = 0
    )

    DynamicParam
    {
        $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
        $attributes = [System.Management.Automation.ParameterAttribute]::new()
        $attributeCollection.Add($attributes)

        switch ($TokenType){
            "DEC" {
                $ValidValues = [System.Management.Automation.ValidateSetAttribute]::new(
                    "dec_reward",
                    "season_rewards",
                    "guild_contribution",
                    "market_purchase",
                    "market_rental",
                    "rental_payment",
                    "rental_refund",
                    "rental_payment_fees",
                    "market_fees",
                    "quest_rewards",
                    "burn_cards",
                    "purchase_cl_presale_pack",
                    "mystery_prize",
                    "pack_purchase",
                    "orb_purchase",
                    "purchase_potion",
                    "tournament_creation",
                    "enter_tournament",
                    "leave_tournament",
                    "prize_tournament",
                    "cancel_tournament",
                    "token_transfer",
                    "leaderboard_prizes",
                    "token_award",
                    "unpaid_prizes"
                )
                break;
            }

            "SPS" {
                $ValidValues = [System.Management.Automation.ValidateSetAttribute]::new(
                    "token_award",
                    "stake_tokens",
                    "claim_staking_rewards",
                    "token_transfer",
                    "purchase_cl_presale_pack",
                    "tournament_payment",
                    "enter_tournament",
                    "leave_tournament",
                    "prize_tournament",
                    "cancel_tournament",
                    "unpaid_prizes"
                )
                break;
            }

            "Credits" {
                $ValidValues = [System.Management.Automation.ValidateSetAttribute]::new(
                    "purchase_cl_presale_pack",
                    "credits_purchase",
                    "market_purchase",
                    "market_rental",
                    "purchase_booster_pack"
                )
                break;
            }

            "Voucher" {
                $ValidValues = [System.Management.Automation.ValidateSetAttribute]::new(
                    "purchase_cl_presale_pack_voucher",
                    "voucher_drop",
                    "token_transfer"
                )
                break;
            }

            "Merits" {
                $ValidValues = [System.Management.Automation.ValidateSetAttribute]::new(
                    "brawl_prize",
                    "guild_gladius_purchase",
                    "guild_bldstone_purchase",
                    "guild_pwrstone_purchase"
                )
                break;
            }
        }
        $attributeCollection.Add($ValidValues)
        $dynParam1 = [System.Management.Automation.RuntimeDefinedParameter]::new(
            'TransactionType', [string], $attributeCollection
        )

        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $paramDictionary.Add('TransactionType', $dynParam1)
        return $paramDictionary
    }

    Begin {
        $Uri = "https://api2.splinterlands.com/players/balance_history"  
    }

    Process{
        try{
            $Body = @{
                username    = $UserName
                token_type  = $TokenType
                offset      = $Offset
                limit       = $Limit
            }

            if ($PSBoundParameters.ContainsKey("TransactionType")){
                $Body["types"] = $PSBoundParameters["TransactionType"]
            }

            $transactions = Invoke-RestMethod -Uri $Uri -Body $Body | ForEach-Object {$_}
            foreach ($transaction in $transactions){
                try {
                    $transaction.created_date = [datetime]::Parse($transaction.created_date)
                }
                catch{
                    Write-Information "Unable to parse date for created_date property"
                } #try/catch

                $decimalProperties = "amount","balance_end","balance_start"
                foreach ($property in $decimalProperties){
                    $transaction.$property = [double]$transaction.$property
                }
                
                $transaction.psobject.typenames.insert(0,"splinterlands.balancehistory")
                $transaction
            } #foreach
        }
        catch{
            $PSCmdlet.WriteError($_)
        } #try/catch
    } #Process
}