require 'yaml'
require 'pp'
alias :p :pp

$conf = ARGV[0]
$prefix = "job_" + File.basename($conf, ".yaml")

$ruby = 'jruby'
$qvstat = 'qvstat.rb'

str = File.open($conf).read
conf = YAML.load(str)


conf['lib_names'].each do |lib|
  lines = []
  lines << "QVFILE=#{conf['qv_dir']}/#{conf['qv_file']}\n".gsub(/%LIB_NAME%/, lib)
  lines << "LENGTH=#{conf['length']}\n"
  lines << "OUTF=`basename $QVFILE`.stat.txt"
  lines << "#{$ruby} #{$qvstat} $QVFILE $LENGTH > $OUTF"


  batchf = $prefix + "_" + lib + ".sh"
  File.open(batchf, "w"){|o| o.puts lines}
end
