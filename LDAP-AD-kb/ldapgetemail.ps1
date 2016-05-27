#
#  THIS QUERIES LDAP AND SHOWS EMAIL OF A USER
#
#  Run this using powerhsell


#From http://ask.programmershare.com/25793_10200940/

Clear-Host
#$dn = New-Object System.DirectoryServices.DirectoryEntry ("LDAP://WM2008R2ENT:389/dc=dom,dc=fr","jpb@dom.fr","Pwd")

# Look for a user
$user2Find = "username"
$Rech = new-object System.DirectoryServices.DirectorySearcher($dn)
$rc = $Rech.filter = "((sAMAccountName=$user2Find))"
$rc = $Rech.SearchScope = "subtree"
$rc = $Rech.PropertiesToLoad.Add("mail");

$theUser = $Rech.FindOne()
if ($theUser -ne $null)
{
  Write-Host $theUser.Properties["mail"]
}

