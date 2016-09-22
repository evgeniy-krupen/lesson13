node web2.minsk.epam.com {
    include '::mysql::server'
    include nginx
}

# create db with user and grants for user
mysql::db { 'test_mdb':
  user     => 'prod_user',
  password => 'prod_password',
  host     => 'localhost',
  grant    => ['SELECT', 'UPDATE'],
}
