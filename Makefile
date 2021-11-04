tests:
	bundle exec rake test:all

gem: pkg

pkg: gem
	bundle exec rake gem

gem.publish:
	ls pkg/*.gem | xargs gem push
