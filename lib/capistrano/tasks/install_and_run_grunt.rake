desc "install and run grunt html2js task"
task :install_and_run_grunt do 
  on roles :all do
  	execute "npm install --production"
  	execute "grunt html2js"
  end
end
after "deploy:updated", :install_and_run_grunt
