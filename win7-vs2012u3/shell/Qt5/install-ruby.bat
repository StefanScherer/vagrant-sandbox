title %~n0 %1
cd /D %ChocolateyInstall%

if exist C:\ruby200\bin goto RUBY_INSTALLED
call cinst ruby
set PATH=%PATH%;C:\ruby200\bin
:RUBY_INSTALLED

call gem install sinatra
call gem install sinatra-contrib
call gem install ocra

REM from Seven Web Frameworks in Seven Weeks 
call gem install rspec rack-test
call gem install sqlite3 data_mapper dm-sqlite-adapter
call gem install dm-serializer

