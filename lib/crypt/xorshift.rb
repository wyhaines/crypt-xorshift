begin
  require 'crypt/xorshift/ext'
rescue LoadError
  require 'crypt/xorshift/pure'
end
