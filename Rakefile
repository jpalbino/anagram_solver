require 'rake'

task :cls do |t|
    system('cls')
end

require 'rake/testtask'
Rake::TestTask.new do |t|
    t.libs = ['lib', 'test']
end
task :test => :cls