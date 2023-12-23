#
# https://adventofcode.com/2023/day/18#part2
#
Point = Data.define(:x, :y)

class Marker
  def initialize(x = 0, y = 0)
    @x, @y = x, y
  end

  def U = move { @y -= 1 }
  def R = move { @x += 1 }
  def D = move { @y += 1 }
  def L = move { @x -= 1 }

  private

  def move
    yield
    Point[@x, @y]
  end
end

def parse_instruction(line)
  code = line.split.last
  direction = %w[R D L U][code[7].to_i]
  steps = code[2, 5].to_i(16)
  [direction, steps]
end

points = ARGF.each_with_object(Marker.new).flat_map do |line, marker|
  direction, steps = parse_instruction(line)
  steps.to_i.times.map { marker.send(direction.to_sym) }
end

a = points.each_cons(2)
  .inject(0) { |sum, (p1, p2)| sum + p1.x * p2.y - p1.y * p2.x }

pp (a + points.length) / 2 + 1

