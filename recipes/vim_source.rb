#
# Cookbook Name:: vim
# Recipe:: vim_source
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
when "ubuntu"
  %w{
    python-dev mercurial lua5.2 liblua5.2-dev
  }.each do |package_name|
    package "#{package_name}" do
      action :install
    end
  end
when "centos"
  %w{
    lua-devel python-devel
  }.each do |package_name|
    package "#{package_name}" do
      action :install
    end
  end
end

hg "/usr/local/src/vim" do
  repository "https://vim.googlecode.com/hg/"
  reference "1e2bfe4f3e903110f27cb6231f6642e721808837"
  action :sync
end

case node['platform']
when "ubuntu"
  script "build_vim" do
    interpreter "bash"
    user "root"
    cwd "/usr/local/src/vim"
    code <<-EOH
      ./configure \
      --disable-selinux \
      --with-features=huge \
      --enable-pythoninterp \
      --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
      --enable-luainterp=yes \
      --with-lua-prefix=/usr \
      --enable-fail-if-missing ;
      make ; make install
    EOH
  end
when "centos"
  script "build_vim" do
    interpreter "bash"
    user "root"
    cwd "/usr/local/src/vim"
    code <<-EOH
      ./configure \
      --disable-selinux \
      --with-features=huge \
      --enable-pythoninterp \
      --with-python-config-dir=/usr/lib64/python2.6/config \
      --enable-luainterp=yes \
      --with-lua-prefix=/usr \
      --enable-fail-if-missing ;
      make ; make install
    EOH
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
