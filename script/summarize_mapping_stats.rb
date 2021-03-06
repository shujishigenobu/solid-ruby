target_dir_pattern = ARGV[0]

puts "# sciprt: #{$0}"
puts "# date:   #{Time.now}"
puts "# target dir: #{target_dir_pattern}"
puts "# " + %w{sample_name  F5orF3  mapping_rate  mapped_tags  /  total_tags  #start_point  avg_num_reads_per_startpoint}.join("\t")

Dir["#{target_dir_pattern}/output/F[35]/s_mapping/mapping-stats.txt"].sort.each do |file|


  txt = File.open(file).read
  total_tags = /(^\d[\d,]+) total tags found/.match(txt)[1].gsub(/,/, '').to_i

  mapped_tags = /(^\d+) Mapped reads/.match(txt)[1].to_i

  map_ratio = mapped_tags.to_f / total_tags

  sample_name = %r{([^/]+?)/output}.match(file)[1]
  sample_name.sub!(/ngs_cai_analysis_\d+_/, '')

  num_start_points = /Number of Starting Points in Uniquely placed tag\s+([\d,]+)/.match(txt)[1].gsub(/,/,"").to_i
  avg_num_reads_per_startpoint = /Average Number of Uniquely Mapped reads per Start Point\s+([\d,.]+)/.match(txt)[1].gsub(/,/,"").to_f

  f5_or_f3 = %r{/(F[35])/s_mapping}.match(file)[1]

  puts [sample_name,
        f5_or_f3,
        sprintf("%.1f%%", map_ratio * 100),
        mapped_tags,
        "/",
        total_tags,
        num_start_points,
        sprintf("%.2f", avg_num_reads_per_startpoint),
       ].join("\t")
end
