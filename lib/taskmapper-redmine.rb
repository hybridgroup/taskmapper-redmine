require File.dirname(__FILE__) + '/redmine/redmine-api'

%w{ redmine ticket project comment api-extensions }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end

