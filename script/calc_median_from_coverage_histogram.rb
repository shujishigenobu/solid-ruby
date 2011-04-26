
def calc_median_from_coverage_histogram_data(infile)
  coverage_to_count = {}

  File.open(infile).each do |l|
    next if /^\#/.match(l)
    a = l.chomp.split(/\t/)
    coverage_to_count[a[0].to_i] = a[1].to_i
  end

  total_count = coverage_to_count.values.inject(0){|sum, x| sum + x}
  
  sum = 0
  median = nil
  coverage_to_count.keys.sort.each do |k|
    v = coverage_to_count[k]
    sum += v
    #    p [k,v, sum]
    if sum > total_count / 2
      median = k
      break
    end

  end
  median   
end

if __FILE__ == $0
p  infile = ARGV[0]

  puts calc_median_from_coverage_histogram_data(infile)
end
