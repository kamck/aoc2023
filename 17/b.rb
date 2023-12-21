require "pqueue"

MINSTEPS = 4
MAXSTEPS = 10

Node = Data.define(:x, :y)

Vertex = Data.define(:node, :direction, :steps)

Graph = Data.define(:grid) do
  def neighbors(node)
    [
      [Node[node.x, node.y - 1], :up],
      [Node[node.x + 1, node.y], :right],
      [Node[node.x, node.y + 1], :down],
      [Node[node.x - 1, node.y], :left],
    ].filter do |n, _|
      n.x.between?(0, grid.first.length - 1) && n.y.between?(0, grid.length - 1)
    end
  end

  def cost(node)
    grid[node.y][node.x].to_i
  end

  def goal
    Node[grid.first.length - 1, grid.length - 1]
  end
end

def h(a, b)
  (a.x - b.x).abs + (a.y - b.y).abs
end

def backtracking?(current, neighbor)
  dir = {up: :down, right: :left, down: :up, left: :right}
  current == dir[neighbor]
end

def a_star(graph, start)
  came_from = Hash.new
  g_score = Hash.new { Float::INFINITY }
  f_score = Hash.new { Float::INFINITY }
  open_set = PQueue.new {|a, b| f_score[a] < f_score[b] }

  g_score[start] = 0
  f_score[start] = h(graph.goal, start.node)
  open_set << start

  while !open_set.empty?
    current = open_set.pop

    if current.node == graph.goal
      return [came_from, g_score]
    end

    graph.neighbors(current.node).each do |neighbor, direction|
      next if current.direction == direction && current.steps == MAXSTEPS
      next if current.direction != direction && current.steps < MINSTEPS && current.node != Node[0, 0]
      next if backtracking? current.direction, direction

      new_steps = current.direction == direction ? current.steps + 1 : 1
      v_neighbor = Vertex[neighbor, direction, new_steps]

      tentative_gscore = g_score[current] + graph.cost(neighbor)

      if tentative_gscore < g_score[v_neighbor]
        came_from[v_neighbor] = current
        g_score[v_neighbor] = tentative_gscore
        f_score[v_neighbor] = tentative_gscore + h(graph.goal, neighbor)

        if !open_set.include? v_neighbor
          open_set << v_neighbor
        end
      end
    end
  end

  puts "Goal not found"
  exit
end

graph = Graph.new(ARGF.readlines(chomp: true))
start = Vertex[Node[0, 0], nil, 0]

came_from, g_score = a_star(graph, start)

pp g_score[g_score.keys.find { _1.node == graph.goal }]
