require 'cucumber/rake/task'
require 'spec/rake/spectask'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end

Spec::Rake::SpecTask.new

desc "Run features and tests"
task :default => [:spec, :features]