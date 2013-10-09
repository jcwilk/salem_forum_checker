require 'rubygems'
require 'bundler'
Bundler.require(:default)

#TODO!!!: You gotta set these to yo creds!
$username, $password = YAML.load_file('./credentials.yml').values_at(:forum_username, :forum_password)

class ForumChecker
  attr_reader :a

  def initialize
    @a = Mechanize.new
  end

  def login
    puts "logging in as #{$username.inspect}..."
    a.get('http://login.salemthegame.com/portal/login-pw') do |page|
      logged_in = page.form_with(:action => 'login?r=/portal/profile') do |f|
        f['username']  = $username
        f['passwd']    = $password
      end.click_button
    end
    self
  end

  def fetch_message_count
    puts 'fetching messages...'
    message_count = nil
    a.get('http://forum.salemthegame.com/') do |page|
      link_text = page.links.to_a.find {|l| l.text =~ /new message/ && l.href =~ /ucp\.php/ }.text
      message_count = link_text.scan(/<strong>(.+)<\/strong>/).flatten.first.to_i
    end
    message_count
  end
end

checker = ForumChecker.new

checker.login
last_count = checker.fetch_message_count

`notify-send 'starting with #{last_count} messages'`
puts last_count

while true do
  begin
    sleep 10
    new_count = checker.fetch_message_count
    puts new_count
    `notify-send 'New message!'` if new_count > last_count
    last_count = new_count
  rescue
    puts "Caught error! [ #{$!.to_s} ] relogging in case it booted us..."
    checker.login
  end
end
