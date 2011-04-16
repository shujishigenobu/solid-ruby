$target_dir = ARGV[0]

conf_file = Dir[$target_dir + "/config/*/*.ini"].shift

case (conf_file_basename = File.basename(conf_file))
when "SNP_Finder.ini"
  analysis = "SNP_Finder" # BioScope 1.2
when "Find_SNPs.ini"
  analysis = "Find_SNPs" # BioScope 1.3
else
  p conf_file_basename
  raise "Not implemented yet"
end

p analysis

log_file = Dir[$target_dir + "/log/bioscope*.log"].shift

log = File.open(log_file).read

if /dibayes.run completed./.match(log) &&
    / Finished successfully/.match(log) &&
    /Closing JMS connection/.match(log)
  success = true
else
  
end
error_lines = []
log.split(/\n/).each do |l|
  error_lines << l if /FATAL/.match(l)
end

if success
  puts "Finished successfully."
else
  puts "Not finished."
  if error_lines.size > 0
    puts "Error found."
    puts error_lines
  end
end
