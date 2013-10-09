require 'rubygems'
require 'bundler'
Bundler.require(:default)

#TODO!!!: You gotta set these to yo creds!
$forum_username, $forum_password, $gmail_user, $gmail_pass, $gmail_recipient = YAML.load_file('./credentials.yml').values_at(
  :forum_username, :forum_password, :gmail_user, :gmail_pass, :gmail_recipient
)

class ForumChecker
  attr_reader :a

  def initialize
    @a = Mechanize.new
    login
  end

  def login
    puts "logging in as #{$forum_username.inspect}..."
    a.get('http://login.salemthegame.com/portal/login-pw') do |page|
      logged_in = page.form_with(:action => 'login?r=/portal/profile') do |f|
        f['username']  = $forum_username
        f['passwd']    = $forum_password
      end.click_button
    end
    self
  end

  def fetch_message_count
    puts 'fetching messages...'
    message_count = nil
    a.get('http://forum.salemthegame.com/') do |page|
      link_text = page.links.to_a.find {|l| l.text =~ /new message/ && l.href =~ /ucp\.php/ }.text
      message_count = link_text.scan(/^(.+) new message/).flatten.first.to_i
    end
    message_count
  end
end

class Gmailer
  attr_reader :client

  def initialize
    connect
  end

  def connect
    @client = Gmail.connect!($gmail_user, $gmail_pass)
  end

  def send_message(_subject, _body)
    client.deliver do
      to $gmail_recipient
      subject _subject
      body _body
    end || raise('Could not deliver email')
  end
end

gmailer = Gmailer.new
checker = ForumChecker.new

last_count = checker.fetch_message_count

`notify-send 'starting with #{last_count} messages'`
puts last_count

while true do
  begin
    sleep 10
    new_count = checker.fetch_message_count
    puts new_count
    if new_count > last_count
      gmailer.send_message 'New salem message!', 'http://forum.salemthegame.com/ucp.php?i=pm&folder=inbox'
      `notify-send 'New message!'`
    end
    last_count = new_count
  rescue
    puts "Caught error! [ #{$!.to_s} ] relogging in case it booted us..."
    checker.login
    gmailer.connect
  end
end
