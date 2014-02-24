#
# Cookbook Name:: vim
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node['platform']
when "centos"
  package "fontforge" do
    action :install
  end
end

cookbook_file "/etc/profile.d/vim.sh" do
    source "vim.sh"
      mode "0644"
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

directory "/usr/local/share/fonts" do
  action :create
  recursive true
end

cookbook_file "/usr/local/share/fonts/inconsolata-Powerline.ttf" do
  source "inconsolata-Powerline.ttf"
end

include_recipe "vim::vim_#{node["vim"]['install_method']}"

