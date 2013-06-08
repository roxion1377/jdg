#! ruby -Ku

path = ARGV[0]
tle = ARGV[1]
mle = ARGV[2].to_i * 1024
Dir::chdir(path) 
Dir::mkdir("outputs") if !File.exists?("outputs")
Dir::mkdir("results") if !File.exists?("results")
Dir::glob("in/**/in/*").each {|f|
	if File.file?(f)
		nm = f.split("/")[1]
		dd = "outputs/#{nm}"
		dr = "results/#{nm}"
		Dir::mkdir(dd) if !File.exists?(dd)
		Dir::mkdir(dr) if !File.exists?(dr)
		name = File::basename(f,".*")
		`ulimit -s unlimited ; cpu a.out #{tle} #{mle} results/#{nm}/#{name}.res < #{f} > outputs/#{nm}/#{name}.out`
	end
}
