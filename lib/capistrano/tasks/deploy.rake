namespace :deploy do
  task :restart do
    on roles(:app) do
      sudo 'systemctl daemon-reload'
      sudo "systemctl restart #{fetch :application}.service"
    end
  end

  task :setup do
  end

  task :generate_config_files do
    on roles :app do
      execute :mkdir, "-p #{shared_path}/config"
      config_files = fetch :config_files
      config_files.each { |file| upload_template file }
    end
  end
end

def upload_template(from, to=nil)
  to ||= from
  full_to_path = "#{shared_path}/config/#{to}"
  erb = ERB.new(File.new("config/deploy/#{from}.erb").read).result(binding)
  upload! StringIO.new(erb), full_to_path
  execute :chmod, "644 #{full_to_path}"
end

def sub_strings(input_string)
  output_string = input_string
  input_string.scan(/{{(\w*)}}/).each do |var|
    output_string.gsub!("{{#{var[0]}}}", fetch(var[0].to_sym))
  end
  output_string
end
