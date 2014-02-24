#
# Cookbook Name:: vim
# Recipe:: vim_package
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when "centos"
  package "vim" do
    action :install
  end
end

script "exec-neoinstall" do
  interpreter "bash"
  user "root"
  code <<-EOH
    /root/.vim/bundle/neobundle.vim/bin/neoinstall
  EOH
end
