update innovator.[user] set [password] = '607920b64fe136f9ab2389e371852af2' where login_name in ('admin','root')
update innovator.[user] set logon_enabled='1' where login_name in ('admin','root')
update innovator.[user] set working_directory='C:\Temp' where login_name in ('admin','root')
update innovator.[user] set email='email@fake.com' where email is not null or email not like '%@%'