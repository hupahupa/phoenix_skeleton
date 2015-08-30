default[:site][:site_name] = 'site'
default[:site][:app_user] = 'site'
default[:site][:db][:database] = 'site'
default[:site][:db][:host] = 'localhost'
default[:site][:db][:user] = 'site'
default[:site][:secret_key] = 'dHKEf1IXUVQzs9ubg6pHULHaAOUaL0pod'
default[:site][:python][:virtualenv] = '/home/site/.virtualenvs/site'
default[:site][:server_aliases] = []
default[:elixir][:version] = "1.0.4"

#environment: local or dev or prod
default[:site][:env] = 'dev'

#db log debug
default[:site][:db][:debug] = false

#emails
default[:site][:emails][:admin] = 'youremail@yourdomain.com'

#email to send error
default[:site][:emails][:errors] = [
]
default[:site][:emails][:debug] = false

default[:site][:debug] = true

default[:nginx][:client_max_body_size] = '3M'
default[:site][:blocked_keywords] = [
    "/phpMyAdmin",
    "/mysqladmin",
    "/muieblackcat",
    "/manager/html",
    "/test",
    "/proxy.txt",
    ".php",
]
