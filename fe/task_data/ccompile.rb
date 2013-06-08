#! ruby -Ku

require 'rubygems'

Dir::chdir(ARGV[0])

#Process.setrlimit(Process::RLIMIT_CPU, 3)

$res = true
Process.fork { 
	path = "export PATH=/usr/bin:$PATH ; "
	$res = system(path+'gcc -O2 -lm -o a.out ./Main.c 2> cerror.txt')
}
Process.wait
exit (File.exist?('a.out') ? 0 : 1)
