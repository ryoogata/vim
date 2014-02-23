#
# Cookbook Name:: vim
# Recipe:: vim_package
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
cookbook_file "/etc/profile.d/vim.sh" do
  source "vim.sh"
  mode "0644"
end

case node['platform']
when "centos"
  package "vim" do
    action :install
  end
end

directory "/root/.vim/bundle" do
  action :create
  recursive true
end

git "/root/.vim/bundle/neobundle.vim" do
    repository "git://github.com/Shougo/neobundle.vim.git"
    reference "master"
    action :sync
end

cookbook_file "/root/.vimrc" do
  source "vimrc"
end

script "exec-neoinstall" do
  interpreter "bash"
  user "root"
  code <<-EOH
    /root/.vim/bundle/neobundle.vim/bin/neoinstall
  EOH
end
