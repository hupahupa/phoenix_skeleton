include_recipe "apt"
include_recipe "nginx"
include_recipe "nginx"
include_recipe "elixir"
include_recipe "postgresql::client"
include_recipe "site::database"

site = node[:site]
app_user = site[:app_user]
python_env = site[:python][:virtualenv]
site_dir = site[:site_dir]
site_name = site[:site_name]
script_dir = "#{site_dir}/scripts"

%w{
    libjpeg-dev
    zlib1g-dev
    libpng12-dev
    libpq-dev
    libffi-dev
}.each do |pkg|
    package pkg do
        action :install
    end
end

user app_user do
    home "/home/#{app_user}"
    shell "/bin/bash"
    supports :manage_home => true
    action :create
end

[site[:log_dir], script_dir].each do |dir|
    directory dir do
        owner app_user
        action :create
        recursive true
    end
end

dirs = [
    "app/priv/static/images/uploads",
]
dirs.each do |component|
    the_dir = "#{site_dir}/#{component}"
    bash "Create Folder #{component}" do
        code <<-EOH
            mkdir -p #{the_dir}
            chown -R #{app_user}:www-data #{the_dir}
            chmod -R ug+rw #{the_dir}
            find #{the_dir} -type d | xargs chmod ug+x
        EOH
    end
end

template "#{script_dir}/set_env.sh" do
    source "set_env.sh.erb"
    mode "644"
end

template "#{script_dir}/site.sh" do
    source "site.sh.erb"
    mode "755"
end

template "/etc/init/#{site_name}.conf" do
    source "upstart_site.erb"
    mode "644"
end

#deploy script
template "#{script_dir}/deploy.sh" do
    source "deploy.sh.erb"
    mode "755"
end

template "#{script_dir}/restart.sh" do
    source "restart.sh.erb"
    mode "755"
end

#db config
template "#{site_dir}/app/config/db.json" do
    source "db.json.erb"
    mode "644"
end

execute "Get all elixir dependencies" do
    user app_user
    environment({
        "HOME" => "/home/#{app_user}",
        "LANGUAGE" => "en_US.UTF-8",
        "LANG" => "en_US.UTF-8",
        "LC_ALL" => "en_US.UTF-8",
    })
    cwd "#{site_dir}/app"
    command "echo Y | mix deps.get"
end

execute "Compile all elixir dependencies" do
    user app_user
    environment({
        "HOME" => "/home/#{app_user}",
        "LANGUAGE" => "en_US.UTF-8",
        "LANG" => "en_US.UTF-8",
        "LC_ALL" => "en_US.UTF-8",
    })
    cwd "#{site_dir}/app"
    command "echo Y | mix compile"
end

service site_name do
    provider Chef::Provider::Service::Upstart
    action [:enable, :start]
end


# Nginx
template "/etc/nginx/sites-available/#{site_name}" do
    source "nginx_site.erb"
    mode "644"
    notifies :restart, "service[nginx]"
end

nginx_site site_name do
    action :enable
end

nginx_site "default" do
    action :disable
end


template "/etc/logrotate.d/#{site_name}" do
    source "logrotate.erb"
    mode "644"
end
