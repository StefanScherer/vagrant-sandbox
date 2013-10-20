#
# Cookbook Name:: windomain
# Recipe:: ps - printserver
#
# Copyright (C) 2013 Stefan Scherer
# 
# All rights reserved - Do Not Redistribute
#

windows_feature "Printing-Server-Role" do
  action :install
end

