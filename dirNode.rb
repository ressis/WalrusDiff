module DirNode
end

class Node
	attr_accessor :content
	attr_accessor :term
	attr_accessor :children

	def initialize(content,term=false)
		@content = content
		@term = term
		@children = Hash.new
	end

	def add_child(child)
		@children[child.content] = child
	end

	def [] x
		@children[x]
	end
	
	def to_html
		if @term
			return @content
		end
		str = "<a onclick='showOrHide(\"_#{hash}\")'>#{content}</a>"
		children = "<ul id='_#{hash}'>"
		@children.keys.each do |key|
			node = @children[key]
			children << "<li>#{node.to_html}</li>"
		end
		children << "</ul>"
		str+children
	end
end
