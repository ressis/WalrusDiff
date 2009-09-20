require 'stringio'
require 'dirNode.rb'
require 'fileutils'
require 'ftools'
require 'erb'

@PREFIX='DIFFTEMP'

input = $stdin
out = $stdout

diff = input.read
files = diff.split("Index: ")

files.delete_at(0)

filesHTML = Hash.new

#colorize all of the individual files
files.each do |file|
	file = StringIO.new(file)
	filename = file.gets.strip
	file.gets # get rid of the line between the Index line and the file's diff

	#convert the diff to color by calling the colorizer script
	color = IO.popen('ruby colorizer.rb','r+')
	color.puts(file.read)
	color.close_write
	filesHTML[filename] = color.read
	color.close_read

	#output the color diff to a place that we can get to it easy
	directory = File.join(@PREFIX,File.dirname(filename))
	File.makedirs(directory)
	color = File.open(File.join(directory,"#{File.basename(filename)}.html"),'w')
	color.puts filesHTML[filename]
	color.close
end

root = RootNode.new

filesHTML.each_key do |file|
	name = File.join(@PREFIX,file)
	dirs = File.dirname(name).split(File::SEPARATOR)
	root[*dirs].add_child LinkNode.new(name)
end

File.open('index.html','w') do |index|
	erb = ERB.new(File.read('html/list.html'))
	index.write erb.result
end

`start index.html`

#FileUtils.rm_rf(@PREFIX)
