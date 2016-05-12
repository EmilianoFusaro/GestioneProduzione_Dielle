require 'spreadsheet'

book=Spreadsheet::Workbook.new
sheet1= book.create_worksheet :name=> "Prova"
sheet1.row(0).concat %w{Name Age Post}
sheet1.row(1).push 'Emiliano','41','12'
sheet1.row(2).push 'Antonio','42','2'
sheet1.row(3).push 'Fausto','40','1'
book.write 'c:/esempio.xls'


#--------------------------------------------------Documentazione Usata
#https://www.youtube.com/watch?v=defnCnzag0Y
#https://rubygems.org/gems/spreadsheet
#https://github.com/zdavatz/spreadsheet
#https://gist.github.com/phollyer/1214475
#installare in automatico le gemme da script
#http://stackoverflow.com/questions/9384756/after-installing-a-gem-within-a-script-how-do-i-load-the-gem
#installare localmente gemma
#gem install --local path_to_gem/filename.gem
#debugger
#http://guides.rubyonrails.org/v2.3.11/debugging_rails_applications.html
#http://guides.rubyonrails.org/debugging_rails_applications.html
#http://edgeguides.rubyonrails.org/debugging_rails_applications.html
#Editor
#https://www.reddit.com/r/ruby/comments/2vb7du/is_rubymine_worth_it/
#DEBUG
#http://blog.honeybadger.io/
#http://blog.honeybadger.io/remote-debugging-with-byebug-rails-and-pow/   #debug in remoto
#http://stackoverflow.com/questions/31669226/rails-byebug-did-not-stop-application	
#https://www.jetbrains.com/help/ruby/2016.1/using-angularjs.html?origin=old_help
#https://github.com/deivid-rodriguez/byebug/issues/51
#http://www.jackkinsella.ie/2014/06/06/debugging-rails-with-built-in-tools.html
#http://www.codeproject.com/Articles/659643/Csharp-Query-Excel-and-CSV-Files-Using-LinqToExcel
#http://johnatten.com/2013/09/25/c-query-excel-and-csv-files-using-linqtoexcel/
#http://stackoverflow.com/questions/1527790/how-can-i-write-to-an-excel-spreadsheet-using-linq
#https://www.discovermeteor.com/blog/text-editors-meteor-development/



#Installare Ruby
#https://gorails.com/setup/osx/10.11-el-capitan
#http://railsapps.github.io/installrubyonrails-mac.html
#https://github.com/postmodern/chruby
#https://www.ruby-lang.org/it/documentation/installation/#rbenv
#aggiornare modificare e settare
#https://developer.xamarin.com/guides/testcloud/calabash/configuring/osx/updating-ruby-using-rbenv/
#http://stackoverflow.com/questions/30461201/how-do-i-edit-path-bash-profile-on-osx
#http://rbenv.org/
#https://github.com/rbenv/rbenv
#https://github.com/rbenv/rbenv#rbenv-local
#http://stackoverflow.com/questions/23702954/rbenv-install-list-does-not-list-version-2-1-2
#http://misheska.com/blog/2013/06/15/using-rbenv-to-manage-multiple-versions-of-ruby/
#https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-14-04
#https://www.heroku.com/ruby
#http://makandracards.com/makandra/25477-rbenv-how-to-update-list-of-available-ruby-versions-on-linux
#https://github.com/rbenv/ruby-build
#http://octopress.org/docs/setup/rbenv/
#http://installrails.com/
#http://installrails.com/steps/install_rvm_and_ruby
#edit path file
#http://stackoverflow.com/questions/30461201/how-do-i-edit-path-bash-profile-on-osx

#Installare MacOsX El Capitan Da 0
#http://www.universalaccess.it/guida-installazione-da-zero-di-el-capitan-da-chiavetta-usb/
#http://www.ispazio.net/536322/come-installare-os-x-el-capitan-in-maniera-pulita-da-una-penna-usb-guida
