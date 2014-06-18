desc "install and run grunt html2js task"
task :install_and_run_grunt do 
  on roles :all do
  	execute "npm install #{fetch :current_path}/package.json --production"
  	execute "grunt --gruntfile #{fetch :current_path}/Gruntfile.js html2js"
  end
end
after "deploy:updated", :install_and_run_grunt
