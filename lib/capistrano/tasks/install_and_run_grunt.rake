desc "install and run grunt html2js task"
task :install_and_run_grunt do 
  on roles :all do
    execute "cd #{current_path}"
  	execute "npm install #{current_path}/package.json --production"
  	execute "grunt --gruntfile #{current_path}/Gruntfile.js html2js"
    execute "cd ~/"
  end
end
after "deploy:updated", :install_and_run_grunt


task :echo_variables do
	on roles :all do
    info "current_path_or_release is set to: #{current_path_or_release}"
    info "current_path is set to: #{current_path}"
    info "deploy_to is set to: #{fetch(:deploy_to)}"
  end
end


