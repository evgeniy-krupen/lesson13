**1. I set up dashboard**

$ yum -y install mysql-server
$ rpm -ivh http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-1.noarch.rpm
$ yum install puppet-dashboard

$ /etc/init.d/mysqld start

Then in mysql:


CREATE DATABASE dashboard CHARACTER SET utf8;
CREATE USER 'dashboard'@'localhost' IDENTIFIED BY 'my_password';
GRANT ALL PRIVILEGES ON dashboard.* TO 'dashboard'@'localhost';

I changed dashboard config:

cd /usr/share/puppet-dashboard/config;
sudo vi database.yml

production:
  database: dashboard
  username: dashboard
  password: my_password
  encoding: utf8
  adapter: mysql


rake RAILS_ENV=production db:migrate 


On puppetserver:

$ vi /etc/puppet/puppet.conf
[master]
reports = store, http
reporturl = http://localhost:3000/reports/upload

[agent]
report = true


On client:

$ puppet agent --verbose --test --server chef-server.minsk.epam.com
![](https://github.com/evgeniy-krupen/lesson13/blob/master/source/dash.png)

But my dashboard did not work (it did not see puppet client) and I decided to install Foreman

Here is guide: https://theforeman.org/manuals/1.12/quickstart_guide.html

I verified puppet client in Foreman
![](https://github.com/evgeniy-krupen/lesson13/blob/master/source/f_foreman2.png)

**2. I created new environment "prod".**

I follow your instruction in courseware but my puppet client addressed only in "production" environment

**3. I created module and manifest**

$ mkdir prod/{manifests, modules}

$ mkdir production/modules/nginx/manifests

And I created module and manifest for nginx.

I tried to create new environment in puppetserver but puppet-client addressed to "production" every time.
![](https://github.com/evgeniy-krupen/lesson13/blob/master/source/issue1.png)

I solved this problem by creating foreman_env (in webUI)


I found out my problems with it in the end of day:

**I forgot add section [prod] in puppet.conf(on puppetserver).**


$ puppet agent --server chef-server.minsk.epam.com -t --environment prod

**4. Run puppet client**

![](https://github.com/evgeniy-krupen/lesson13/blob/master/source/c_exit.png)

**5. Report**
![](https://github.com/evgeniy-krupen/lesson13/blob/master/source/f_graph.png)

[Log](https://github.com/evgeniy-krupen/lesson13/blob/master/file.log)


