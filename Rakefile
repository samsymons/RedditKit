namespace :test do
  desc "Run the RedditKit tests for iOS"
  task :ios do
    $ios_success = system("xctool -workspace Tests/Tests.xcworkspace -scheme 'iOS Tests' test -parallelize -sdk iphonesimulator")
  end

  desc "Run the RedditKit tests for OS X"
  task :osx do
    $osx_success = system("xctool -workspace Tests/Tests.xcworkspace -scheme 'OS X Tests' test -parallelize -sdk macosx")
  end
end

desc "Runs the unit tests"
task :test => ['test:ios', 'test:osx'] do
  puts "\033[0;31m!! iOS unit tests failed" unless $ios_success
  puts "\033[0;31m!! OS X unit tests failed" unless $osx_success

  if $ios_success && $osx_success
    puts "\033[0;32m** All tests executed successfully"
  else
    exit(-1)
  end
end

task :default => ['test']
