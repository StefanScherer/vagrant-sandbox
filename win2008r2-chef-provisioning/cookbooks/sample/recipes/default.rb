#include_recipe "windows"
#windows_feature "Printing-Server-Role" do
#  action :install
#end
# enable the node as a DHCP Server
#windows_feature "DHCPServer" do
#  action :install
#end

user 'stefan' do
  action :create
  comment "Stefan Scherer"
  password "MySecret42"
end

# include_recipe "chocolatey"

# chocolatey "notepadplusplus"

# %w{ sysinternals 7zip notepadplusplus GoogleChrome Console2}.each do |pack|
#   chocolatey pack
# end


# chocolatey "DotNet4.5"

# chocolatey "PowerShell"

