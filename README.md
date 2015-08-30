INSTALLATION
====================

1.  Clone project: `git clone git@github.com:hupahupa/phoenix_skeleton.git --recursive`
2.  Change to site folder: `cd phoenix_skeleton`
3.  Search and replace all `phoenix_skeleton` to `project_name`
4.  Run the vagrant: `vagrant up`
5.  Browse at: localhost:9500

Working Tips
====================
* Access Postgresql:
	+ . /vagrant/scripts/set_env.sh (this also Active virtual environment)
	+ psql
* Restart server:
	+ ./vagrant/scripts/restart.sh
* Dev mode debuging:
	+ ./vagrant/scripts/restart.sh
	+ tail -f /vagrant/logs/app.log => see the log
* Work with migration
//TODO

Reference Packages
====================
*	ELixir: http://elixir-lang.org/getting-started/introduction.html
*	PhoenixFramework: http://www.phoenixframework.org/
