Capistrano::Configuration.instance.load do
  namespace :nginx do
    desc "Setup application in nginx"
    task "setup", :role => :web do
      nginx_conf_path = "/usr/local/nginx/conf/vhost"
      config_file = "config/deploy/nginx_conf.erb"
      unless File.exists?(config_file)
        config_file = File.join(File.dirname(__FILE__), "../../generators/capistrano/nginx/templates/_nginx_conf.erb")
      end
      config = ERB.new(File.read(config_file)).result(binding)
      set :user, sudo_user
      put config, "/tmp/#{application}"
      run "#{sudo} mv /tmp/#{application} #{nginx_conf_path}/#{application}.conf"
      # run "#{sudo} ln -fs #{release_path}/config/deploy/nginx.conf /usr/local/nginx/conf/vhost/#{application}.conf"
    end

    desc "Reload nginx configuration"
    task :reload, :role => :web do
      set :user, sudo_user
      run "#{sudo} /etc/init.d/nginx reload"
    end
  end
end
