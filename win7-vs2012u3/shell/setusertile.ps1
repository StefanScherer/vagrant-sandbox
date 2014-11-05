param($UserName, $ImageFile)

$code = @" 
[DllImport("shell32.dll", EntryPoint = "#262", CharSet = CharSet.Unicode, PreserveSig = false)] 
 public static extern void SetUserTile(string username, int whatever, string picpath); 
 
public static void ChangeUserPicture(string username, string picpath) { 
    SetUserTile(username, 0, picpath); 
} 
"@ 

$Shell32 = Add-Type -MemberDefinition $code -Name 'Shell32' -NameSpace 'Win32' -PassThru
$Shell32::ChangeUserPicture($UserName, $ImageFile) 
