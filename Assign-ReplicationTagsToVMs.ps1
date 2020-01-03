$spreadsheet = Import-Csv -Path 'C:\users\mw148186\OneDrive - The Andersons, Inc\vm_and_tag.csv'

foreach ($line in $spreadsheet)
    {
        New-TagAssignment -Entity (Get-VM -Name $line.vm) -Tag $line.tag
    }