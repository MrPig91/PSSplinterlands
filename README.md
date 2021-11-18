# PSSplinterlands
This is a powershell module used to interact with the Splinterlands API.

## Installation
Open a powershell as administrator and run the following command:
```Powershell
Install-Module -Name PSSplinterlands -Repository PSGallery
```

If you want to update to the latest version, run this command:
```Powershell
Update-Module PSSplinterlands
```

If you get and error like the following "The 'Command' command was found in the module 'PSSplinterlands', but the module could not be loaded." then you will need to set your Execution Policy to remote signed by running the command below. Please note that execution policy is not a security feature, so changing it will not make your system more or less secure. Execution Policy is used to prevent you from accidentally running scripts that goes aganist the policy, but it does not prevent those scripts being ran in bypass mode. You can read more about Execution Policy on its about page [here](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-7.1)
```Powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force
```

## Donate
If you find this module useful and want to donate my hive account is below
Hive account: mrpig29

## Getting DEC Rewards Summary
You can quickly get a summary of DEC rewards (battle, daily quest, and seasonal chest) by running the command below.
```Powershell
 Get-slDECRewardsSummary -UserName mrpig29

RewardType RewardCount AvgReward AvgDailyDEC AvgRewardsPerDay Total    TotalDays
---------- ----------- --------- ----------- ---------------- -----    ---------
Battle     635         5.67      124         22               3597.879 29
Quest      17          11.35     7           1                193      27
Season     2           62        8           0                124      15
All        654         5.99      135         23               3914.879 29
```

## Getting Transactions
Shown below are a couple examples of using the `Get-slBalanceHistory` function, which gets transaction within the last 30 days (API restriction).

Getting SPS claimed staking rewwards transactions.
```Powershell
Get-slBalanceHistory -UserName mrpig29 -TokenType SPS -Limit 5 -TransactionType claim_staking_rewards

player  token Amount type                  balance_end block_num created_date          counterparty
------  ----- ------ ----                  ----------- --------- ------------          ------------
mrpig29 SPS   0.001  claim_staking_rewards 5.707       59269254  11/17/2021 6:57:09 PM $SPS_STAKING_REWARDS
mrpig29 SPS   4.227  claim_staking_rewards 4.231       59269243  11/17/2021 6:56:36 PM $SPS_STAKING_REWARDS
mrpig29 SPS   0.004  claim_staking_rewards 202.519     59242180  11/16/2021 8:19:12 PM $SPS_STAKING_REWARDS
mrpig29 SPS   2.299  claim_staking_rewards 99.179      59242153  11/16/2021 8:17:51 PM $SPS_STAKING_REWARDS
mrpig29 SPS   2.295  claim_staking_rewards 95.314      59226455  11/16/2021 7:10:27 AM $SPS_STAKING_REWARDS
```
Getting the last 5 card rental transactions.
```Powershell
Get-slBalanceHistory -UserName mrpig29 -TokenType DEC -Limit 5 -TransactionType market_rental

player  token Amount  type          balance_end block_num created_date          counterparty
------  ----- ------  ----          ----------- --------- ------------          ------------
mrpig29 DEC   -45.74  market_rental 1437.625    59240585  11/16/2021 6:59:18 PM $RENTAL_ESCROW
mrpig29 DEC   -475    market_rental 730.823     59197579  11/15/2021 7:02:57 AM $RENTAL_ESCROW
mrpig29 DEC   -307.65 market_rental 2142.184    59038330  11/9/2021 5:57:51 PM  $RENTAL_ESCROW
mrpig29 DEC   -420    market_rental 6208.973    58987271  11/7/2021 11:15:24 PM $RENTAL_ESCROW
mrpig29 DEC   -3      market_rental 7389.857    58941763  11/6/2021 10:12:36 AM $RENTAL_ESCROW
```

## Getting Opponent Battle History Summary
The following example shows how to your current opponent's battle history summary. Please note, you must currently be in a battle for this command to work. Sometimes you might need to run it again if it fails the first time.
```Powershell
Get-slPlayerOutstandingBattle -PlayerName mrpig29 | Get-slPlayerBattleSummary


PlayerName    : jj24
Current Quest : Life - In Progess
Top Summoners : Drake of Arnak - 22% | Gold | armor: 1
                        Djinn Chwala        | 91% | L: 1 | attack: 4  | A: Thorns
                        Furious Chicken     | 55% | L: 1 | attack: 2  | A:
                        Kobold Miner        | 36% | L: 1 | attack: 3  | A: Sneak
                        Flame Monkey        | 27% | L: 1 | attack: 1  | A:
                        Serpentine Mystic   | 27% | L: 1 | magic: 2   | A: Affliction
                        Serpentine Spy      | 27% | L: 1 | attack: 4  | A: Opportunity

                Tyrus Paladium - 14% | White | armor: 1
                        Shieldbearer          | 71% | L: 1 | attack: 4  | A: Taunt
                        Armorsmith            | 71% | L: 1 | attack: 3  | A: Repair
                        Feral Spirit          | 57% | L: 1 | attack: 4  | A: Sneak
                        Venari Crystalsmith   | 57% | L: 1 | ranged: 3  | A: Tank Heal
                        Truthspeaker          | 57% | L: 1 |            | A: Protect
                        Battering Ram         | 43% | L: 1 | attack: 2  | A: Opportunity

                Zintar Mortalis - 8% | Black | attack: -1
                        Twisted Jester     | 100% | L: 1 | ranged: 4  | A: Snipe
                        Death Elemental    | 50% | L: 1 | magic: 2   | A: Snipe
                        Dark Ferryman      | 50% | L: 1 | ranged: 3  | A:
                        Harklaw            | 50% | L: 1 | attack: 3  | A: Shield
                        Shadowy Presence   | 50% | L: 1 |            | A:
                        Haunted Spirit     | 50% | L: 1 | attack: 4  | A: Heal

Top Monsters  : Furious Chicken - 50%
                Pirate Archer - 38%
                Sea Monster - 34%
                Crustacean King - 24%
                Battering Ram - 22%
                Djinn Chwala - 20%
```
