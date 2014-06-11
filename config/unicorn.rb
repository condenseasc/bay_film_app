root = "/var/www/bay-projection/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/unicorn/unicorn.log"
stdout_path "#{root}/unicorn/unicorn.log"

listen "/tmp/unicorn.bay-projection.sock"
worker_processes 2
timeout 30