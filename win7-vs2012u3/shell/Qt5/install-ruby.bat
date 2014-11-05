title %~n0 %1
cd /D %ChocolateyInstall%

if exist C:\ruby200\bin goto RUBY_INSTALLED
call cinst ruby
set PATH=%PATH%;C:\ruby200\bin
:RUBY_INSTALLED

call cinst curl

call gem install sinatra --no-ri --no-rdoc
call gem install sinatra-contrib --no-ri --no-rdoc
call gem install ocra --no-ri --no-rdoc

REM from Seven Web Frameworks in Seven Weeks 
call cinst sqlite
call gem install rspec rack-test --no-ri --no-rdoc
call gem install sqlite3 data_mapper dm-sqlite-adapter --no-ri --no-rdoc
call gem install dm-serializer --no-ri --no-rdoc

