Clear-Host
$file = Import-Csv C:\Users\mw148186\Desktop\durp.csv

$input = Read-Host "Type Serial"

Write-Host "Searching for" $input

$model=$file.Where({$_.Serial -eq $input}).Model
$serial=$file.Where({$_.Serial -eq $input}).Serial
Write-Host $model $serial
