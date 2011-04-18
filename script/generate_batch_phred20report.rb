require 'stringio'

class QVMatrix

  def self.read(file, score_max) # file_path or IO object
    p file
    unless file.is_a?(IO)
      io = File.open(file)
    else
      io = file
    end
    txt = io.read
    io.close
    new(txt, score_max)
  end

  def initialize(txt, score_max)
    @score_max = score_max
    scores = nil
    scores_to_count = Hash.new(0)
    
    StringIO.new(txt).each_line do |l|
      if /^\#/.match(l)
        if /^\# pos/.match(l) # coluumn names
          a = l.chomp.split(/\t/)
          a.shift
          scores = a.collect{|x| x.to_i}
          scores.each do |s|
            scores_to_count[s] = 0
          end
        else
        end
        next
      end

      a = l.chomp.split(/\t/)
      pos = a.shift
      scores.each_with_index do |s, i|
        [i, s, a[i].to_i]
        scores_to_count[s] += a[i].to_i
      end
    end
    
    scores_to_count.delete_if{|k, v| k > @score_max}

    p scores_to_count

  end


end

QVMatrix.read(ARGV[0], 40)

exit

$input = ARGV[0] # qvstat output as a matrix (tab-del table)
QV = (ARGV[1].to_i | 20)
SCORE_MAX = (ARGV[2].to_i | 40)

scores = nil
scores_to_count = Hash.new(0)





qvsum = scores_to_count.select{|k, v| k >= QV}.collect{|k, v| v}.inject(0){|i, sum| i + sum}

# p scores_to_count.values.inject(0){|i, sum| i + sum}

 puts qvsum

# puts qvsum.to_s.reverse.gsub(/\d\d\d/, "\\0,").reverse.sub(/^,/, "")
