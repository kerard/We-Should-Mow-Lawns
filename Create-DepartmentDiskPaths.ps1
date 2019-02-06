$rootmount = "c:\mount"
$disktype = Get-Content .\disktype.txt
$deptname = Get-Content .\departments.txt

foreach ( $type in $disktype )
    {     
        foreach ( $deptshortname in $deptname )
            {
                $fullpath = $rootmount + "\" + "cinco_mail_" + $type + "_" + $deptshortname
                md $fullpath
            }
    }