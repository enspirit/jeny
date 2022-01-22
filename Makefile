package:
	bundle exec rake package

tests:
	bundle exec rake test

gem.push:
	ls pkg/jeny-*.gem | xargs gem push
