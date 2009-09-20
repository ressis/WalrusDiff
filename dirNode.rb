module DirNode
end

class RootNode
	def initialize()
		@children = Hash.new do |hash, key|
			hash[key] = Node.new(key)
		end
	end

	def [] *x
		i = 0
		tmp = @children
		while i < x.length
			tmp = tmp[x[i]]
			i+=1
		end
		tmp
	end
  
  def to_html
    html = "<ul>"
    @children.keys.sort.each do |dir|
      html << "<li>#{@children[dir].to_html}</li>"
    end
    html<<"</ul>"
    html
  end
end

class Node
	attr_accessor :content
	attr_accessor :children

	def initialize(content)
		@content = content
		@children = Hash.new
	end

	def add_child(child)
		@children[child.content] = child
	end

	def [] x
		@children[x] = Node.new(x) if @children[x].nil?
		@children[x]
	end
	
	def to_html
		str = "<a onclick='showOrHide(\"_#{hash}\")'>#{content}</a>"
		children = "<ul id='_#{hash}'>"
		@children.keys.sort.each do |key|
			node = @children[key]
			children << "<li>#{node.to_html}</li>"
		end
		children << "</ul>"
		str+children
	end
end

class LinkNode
	attr_accessor :content
	def initialize(dest)
		@dest = dest
		@content = dest
	end

	def to_html
		"<a onclick='window.open(\"#{@dest}.html\",\"child\")'>#{File.basename @dest}</a>"
	end
end
