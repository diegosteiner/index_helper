require 'index_helper/index_helper'
module IndexHelper
  class Railtie < Rails::Railtie
    initializer "index_helper.index_helper" do
      ActionView::Base.send :include, IndexHelper
    end
  end
end
