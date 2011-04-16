#===
# qvstat.rb
# 
# Read SOLiD qual file to make a matrix of base qualities


#require 'pp'
#alias :p :pp
require 'optparse'

POS_MAX_DEFAULT = 100

class Counter

  def initialize(length)
    @position = Hash.new
    (0..(length-1)).each do |i|
      @position[i] = Hash.new
      (-1..100).each do |j|
        @position[i][j] = 0
      end
    end
  end
  attr_accessor :position

  def load_qvfile(path)
    k = 0
    File.open(path).each do |l|
      next if /^\#/.match(l)
      next if /^>/.match(l)
      values = l.chomp.split.collect{|x| x.to_i}
      values.each_with_index do |v, i|
        #     [i, v]
        self.position[i][v] += 1
      end
      STDERR.print "#{k} reads processed...\r" if (k%10000 == 0)
      k += 1
    end
    nil
  end

end

### command start

opts = OptionParser.new
opts.on("-h", "--help"){ puts opts.to_s; exit }
args = opts.parse(ARGV)

infile = args[0]
length = args[1].to_i
pos_max = (args[2] || POS_MAX_DEFAULT).to_i

c = Counter.new(length)
c.load_qvfile(infile)

### output header
puts "#=== QV summary ==="
puts "# source: #{File.basename(infile)} (#{File.expand_path(infile)})"
puts "# read length (base): #{length}"
puts "# script: #{File.basename(__FILE__)} (#{File.expand_path(__FILE__)})"
puts "# date:   #{Time.now}"
puts "# by:     #{ENV['USER']}"
puts "# "
puts "# pos\t" + (-1..pos_max).to_a.join("\t")

### output matrix

(0..(length - 1)).each do |i|
  puts (i+1).to_s + "\t" +
    (-1..pos_max).collect{|j| c.position[i][j]}.join("\t")
end
