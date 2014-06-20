desc "install and run grunt html2js task"
task :grunt_html2js do 
  on roles :all do
  	execute "cd #{release_path} && grunt --gruntfile #{release_path}/Gruntfile.js html2js"
  end
end
after "deploy:updated", :grunt_html2js


task :print_variables do
	on roles :all do
    info "current_path_or_release is set to: #{current_path_or_release}"
    info "current_path is set to: #{current_path}"
    info "deploy_to is set to: #{fetch(:deploy_to)}"
  end
end
