test:
	bundle exec rspec spec

lint:
	bundle exec rubocop -P

commit:
	@make lint
	@make test
	git commit -m "${gcmsg}"