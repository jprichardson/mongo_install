#!/usr/local/bin/ruby

#this is adapted from: http://library.linode.com/databases/mongodb/

download_file = 'http://downloads.mongodb.org/linux/mongodb-linux-x86_64-1.2.2.tgz'
data_dir = '/data/db'
log_file = '/var/log/mongodb.log'
bin_dir = '/opt/bin'
service_file = '/etc/init.d/mongodb'
conf_file = '/etc/mongodb.conf'
mongo_user = 'mongodb'

file = download_file.split('/').last

puts('Downloading mongo...')
`wget #{download_file}`

puts('Extracting mongo...')
`tar zxvf #{file}`
mondir = file.chomp(File.extname(file))

`mv #{mondir} /opt/mongodb`

puts('Making directories and copying system files...')
Dir.mkdir('/data') if !Dir.exists?('/data')
Dir.mkdir(data_dir) if !Dir.exists?(data_dir)
Dir.mkdir(bin_dir) if !Dir.exists?(bin_dir)

`touch #{log_file}`

`cp files/mongodb-start #{bin_dir}/mongodb-start`
`chmod +x #{bin_dir}/mongodb-start`

`cp files/mongodb-stop #{bin_dir}/mongodb-stop`
`chmod +x #{bin_dir}/mongodb-stop`

`cp files/mongodb.service #{service_file}`
`cp files/mongodb.conf #{conf_file}`
`chmod +x #{service_file}`

puts("Creating user #{mongo_user} and installing service...")
`adduser --system --no-create-home --disabled-login --disabled-password --group mongodb`
`/usr/sbin/update-rc.d -f mongodb defaults`

`chown -R #{mongo_user}:#{mongo_user} #{data_dir}`
`chown #{mongo_user}:#{mongo_user} #{log_file}`

puts('Done.')
puts("run '/etc/init.d/mongodb start'")
