Get-VM | Get-TagAssignment |

where{$_.Tag -like '*VeeamReplication-SAPSupportingServices*'} |

Select @{N='VM';E={$_.Entity.Name}}