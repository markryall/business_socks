require 'cucumber/rake/task'
require 'spec/rake/spectask'

desc "Run all features"
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end

desc "Run spec"
Spec::Rake::SpecTask.new do |t|
  t.libs = [File.join(File.dirname(__FILE__),'..','lib')]
end

desc "Run features and tests"
task :default => [:spec, :features]
