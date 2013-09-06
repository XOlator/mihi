# Webapp errors
class Mihi::Unauthorized < StandardError; end
class Mihi::ActionTimeout < StandardError; end
class Mihi::ExpiredListing < StandardError; end