#! ruby -Ku

require 'rubygems'

Dir::chdir(ARGV[0])

#Process.setrlimit(Process::RLIMIT_CPU, 3)

$res = true

Process.fork { 
	path = "export PATH=/usr/bin:$PATH ; "
	$res = system(path+'g++ -O2 -lm -o a.out ./Main.cpp -ftemplate-depth-128 2> cerror.txt')
}
Process.wait
exit (File.exist?('a.out') ? 0 : 1)
