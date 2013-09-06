module Activatable

  extend ActiveSupport::Concern


  def activate!; self.update_attribute(:active, true); end
  def deactivate!; self.update_attribute(:active, false); end

end
  