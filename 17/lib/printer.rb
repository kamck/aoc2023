def build_path(came_from, goal_node)
  goal = came_from.keys.find {|k| k.node == goal_node }
  total_path = [goal]
  current = goal

  if came_from[current] || current.node == goal
    while current
      total_path.unshift current
      current = came_from[current]
    end
  end

  total_path
end

def print_graph(graph, path)
  (0...graph.grid.length).each do |y|
    (0...graph.grid.first.length).each do |x|
      found = path.find { _1.node == Node[x, y] }
      if found
        c = case found.direction
            when :up then "^"
            when :right then ">"
            when :down then "V"
            when :left then "<"
            else graph.cost(Node[x, y])
            end
        print c
      else
        print graph.cost(Node[x, y])
      end
    end

    puts ""
  end
end
