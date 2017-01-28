# Copyright (c) 2017 Chris Seaton
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Illustrates the process of constructing a graph from a fib function.

require_relative '../lib/rubyjit'
require_relative '../spec/rubyjit/fixtures'

builder = RubyJIT::IR::Builder.new
basic_blocks = builder.basic_blocks(RubyJIT::Fixtures::FIB_BYTECODE_RUBYJIT)

basic_blocks.each_value do |block|
  puts "Basic block #{block.start}:"
  block.insns.each do |insn|
    p insn
  end
  fragment = builder.basic_block_to_graph(block.insns)
  viz = RubyJIT::IR::Graphviz.new(fragment)
  viz.visualise "block#{block.start}.pdf"
end

builder = RubyJIT::IR::Builder.new
builder.build(RubyJIT::Fixtures::FIB_BYTECODE_RUBYJIT)
graph = builder.graph
viz = RubyJIT::IR::Graphviz.new(graph)
viz.visualise 'built.pdf'

postbuild = RubyJIT::Passes::PostBuild.new
postbuild.run(graph)

viz = RubyJIT::IR::Graphviz.new(graph)
viz.visualise 'post.pdf'