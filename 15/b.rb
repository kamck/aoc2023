#
# https://adventofcode.com/2023/day/15#part2
#
class Lens
  attr_reader :label, :focal

  def initialize(label, focal = nil)
    @label = label
    @focal = focal
  end

  def ==(oth)
    @label == oth.label
  end
end

def hash(str)
  str.chars.map(&:ord).inject(0) do |memo, char|
    (memo + char) * 17 % 256
  end
end

def upsert(box, new_lens)
  box.find_index(new_lens).then do |index|
    if index.nil?
      box << new_lens
    else
      box[index] = new_lens
    end
  end
end

def slot(box, step, new_lens)
  if step.include? "="
    upsert(box, new_lens)
  else
    box.delete(new_lens)
  end
end

def process(step, boxes)
  label = step.match(/^[a-zA-Z]+/).to_s
  box = hash(label).to_s
  focal = step.match(/[0-9]+$/).to_s.to_i

  boxes[box] ||= []
  slot(boxes[box], step, Lens.new(label, focal))
end

boxes = ARGF.each_with_object(Hash.new) do |line, boxes|
  line.chomp.split(",").each { |step| process(step, boxes) }
end

scores = boxes.map do |box, lenses|
  lenses.each_with_index.map do |lens, slot|
    (box.to_i + 1) * (slot + 1) * lens.focal
  end
end

pp scores.flatten.sum
