function Get-slPlayerActiveRental {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,ValueFromPipelineByPropertyName)]
        [string[]]$PlayerName,
        [Parameter()]
        [ValidateSet("renter","owner")]
        [string]$PlayerType = "renter"
    )

    Process{
        foreach ($player in $PlayerName){
            $Rentals = Invoke-SplinterlandsAPI -Uri "https://api2.splinterlands.com/market/active_rentals?$PlayerType=$player"
            foreach ($rental in $Rentals){
                try{
                    $rental.rental_date = [datetime]::Parse($rental.rental_date)
                    $rental.next_rental_payment = [datetime]::Parse($rental.next_rental_payment)
                    $rental.cancel_date = [datetime]::Parse($rental.cancel_date)
                }
                catch{
                    Write-Information "Unable to convert date properties to datetime type"
                }
                $rental | Add-Member -TypeName "splinterlands.playeractiverental"
                $rental | Add-Member -MemberType AliasProperty -Name DailyCost -Value buy_price
                $rental | Add-Member -MemberType NoteProperty -Name Cancelled -Value ([bool]$rental.cancel_tx)
                $rental
            }
        } #Foreach
    } #Process
}